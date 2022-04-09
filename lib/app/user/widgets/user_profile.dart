import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wigtoday_app/app/user/models/user_center.dart';
import 'package:wigtoday_app/utils/color.dart';
import 'package:wigtoday_app/utils/font.dart';
import 'package:wigtoday_app/utils/formatter.dart';
import 'package:wigtoday_app/utils/size.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
// import 'package:flutter_pickers/pickers.dart';
// show DatePicker;

import 'package:wigtoday_app/widgets/components.dart';

class UserProfile extends StatefulWidget {
  UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> with Components {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final UserCenterModel _inputModel = UserCenterModel();
  final ImagePicker picker = ImagePicker();
  File? imageFile;

  final _birthControl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _birthControl.text = timeFormat(DateTime.now().millisecondsSinceEpoch, 'yyyy/MM/dd'); 
  }

  LocaleType getLocalType(){
    var local = Localizations.localeOf(context);
    if (local.languageCode.toLowerCase() == 'zh'){
      if (local.countryCode =='TW'){
        return LocaleType.tw;
      }else if(local.countryCode =='HK'){
        return LocaleType.tw;
      }
      return LocaleType.zh;
    }
    return LocaleType.en;
  }

  dateOnTap() {
    // Pickers.showDatePicker(context,
    //     pickerStyle: PickerStyle(
    //       headDecoration: BoxDecoration(
    //         color: isDark(context) ? BZColor.darkCard : BZColor.card
    //       ),
    //         textColor: isDark(context) ? BZColor.darkTitle : BZColor.title,
    //         backgroundColor:
    //             isDark(context) ? BZColor.darkCard : BZColor.card));

    // showDatePicker(context: context, initialDate: DateTime.now(),
    // firstDate: DateTime(1900,1,1),
    // lastDate: DateTime.now());
    
    DatePicker.showDatePicker(context,
        locale: getLocalType(),
        theme: DatePickerTheme(
          cancelStyle: createTextStyle(size: BZFontSize.subTitle, ctx: context),
          doneStyle: createTextStyle(size: BZFontSize.subTitle, ctx: context, color: Colors.orange),
          itemStyle: createTextStyle(size: BZFontSize.navTitle, ctx: context),
          backgroundColor: isDark(context) ? BZColor.darkCard : BZColor.card),
        showTitleActions: true, // 是否展示顶部操作按钮
        minTime: DateTime(1900, 1, 1), // 最小时间
        maxTime: DateTime.now(), // 最大时间
        // 确定事件
        onConfirm: (date) {
        _birthControl.text = timeFormat(date.millisecondsSinceEpoch, 'yyyy/MM/dd');
    },
      currentTime: DateTime.parse(_birthControl.text.replaceAll('/', '')));
  }

  Widget _createDateTimeInputField() {
    return TextFormField(
      readOnly: true,
      onTap: () {
        DatePicker.showDatePicker(context,
            // 是否展示顶部操作按钮
            showTitleActions: true,
            // 最小时间
            minTime: DateTime(1900, 1, 1),
            // 最大时间
            maxTime: DateTime.now(),
            // change事件
            onChanged: (date) {
          print('change $date');
        },
            // 确定事件
            onConfirm: (date) {
          print('confirm $date');
        },
            // 当前时间
            currentTime: DateTime.now());
        // 语言
        // locale: LocaleType.zh);
      },
      textAlign: TextAlign.start,
      decoration: InputDecoration(
          suffixIcon: const Icon(Icons.date_range),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(1))),
      // onSaved: setter,
    );
  }

  Widget _createInputField(String title,
      {double spacing = 15,
      FormFieldSetter<String>? setter,
      Widget? inputField,
      double? width}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
            text: TextSpan(children: [
          const TextSpan(text: '* ', style: TextStyle(color: Colors.red)),
          TextSpan(text: title, style: const TextStyle(color: Colors.black))
        ])),
        SizedBox(height: spacing),
        SizedBox(
            height: 40,
            width: width ?? BZSize.pageWidth / 3,
            child: inputField ??
                TextFormField(
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(1))),
                  // onSaved: setter,
                ))
      ],
    );
  }

  Future _getImage() async {
    //选择相册
    var pickerImages = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickerImages != null) {
        imageFile = File(pickerImages.path);
        Navigator.pop(context);
      }
    });
  }

  Future _cropImage(File img) async {
    File? croppedFile = await ImageCropper().cropImage(
        sourcePath: img.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: const AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: const IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      imageFile = croppedFile;
    }
  }

  Widget _createUserImage(BuildContext context, {double radius = 50.0}) {
    var url = 'https://p0.ssl.img.360kuai.com/t016e2f42c2f1145dc5.webp';
    return Container(
        child: InkWell(
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (ctx) => Container(
                  height: 200,
                  child: Column(children: [
                    TextButton(
                        onPressed: () {
                          _getImage();
                        },
                        child: Text(textLocation(context).textSelectPicture,
                            style: createTextStyle(size: BZFontSize.title, ctx: context))),
                    const Divider(),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(textLocation(context).textCancel,
                            style: createTextStyle(size: BZFontSize.title, ctx: context)))
                  ]),
                ));
      },
      child: Stack(children: [
        ClipOval(
          child: imageFile != null
              ? Image.file(imageFile!,
                  height: radius * 2, width: radius * 2, fit: BoxFit.cover)
              : Image.network(url,
                  height: radius * 2, width: radius * 2, fit: BoxFit.cover),
        ),
        Positioned(
            bottom: 0,
            left: 0,
            child: ClipOval(
                child: Column(children: [
              Container(
                width: radius * 2,
                height: radius * 2 - 25,
                color: Colors.transparent,
              ),
              Container(
                  width: radius * 2,
                  height: 25,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(200, 92, 80, 74)))
            ]))),
        Positioned(
            child: const Icon(
              Icons.camera_alt_outlined,
              size: 20,
              color: Colors.white,
            ),
            bottom: 2,
            left: radius - 10),
        // Align(child: Icon(Icons.camera_alt_outlined, size: 25,), alignment: Alignment.center,)
      ]),
    ));
  }

  Widget _createFileds(BuildContext context, double spacing) {
    return Container(
        decoration: BoxDecoration(
            color: isDark(context)
                ? BZColor.darkCard
                : BZColor.card, // Colors.white,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        child: Form(
            key: _formKey,
            child: Column(children: [
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  createInputField(textLocation(context).inputTipsFirstName,
                      ctx: context),
                  createInputField(textLocation(context).inputTipsLastName,
                      ctx: context),
                  // _createInputField('FirstName', spacing: spacing),
                  // _createInputField('LastName', spacing: spacing)
                ],
              ),
              SizedBox(height: spacing),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  createInputField(textLocation(context).inputTipsGender,
                      ctx: context, readOnly: true),
                  createInputField(textLocation(context).inputTipsCountry,
                      ctx: context, readOnly: true),
                  // _createInputField('FirstName', spacing: spacing),
                  // _createInputField('LastName', spacing: spacing)
                ],
              ),
              SizedBox(height: spacing),
              Align(
                  alignment: Alignment.centerLeft,
                  child: createInputField(textLocation(context).inputTipsBirth,
                      controller: _birthControl,
                      readOnly: true,
                      onTap: dateOnTap,
                      ctx: context,
                      suffixIcon: const Icon(Icons.date_range),
                      width: double.infinity)),
              SizedBox(height: spacing),
              Align(
                  alignment: Alignment.centerLeft,
                  child: createInputField(
                      textLocation(context).inputTipsMobile,
                      keyboardType: TextInputType.number,
                      width: double.infinity, ctx: context)),
              SizedBox(height: spacing),
              Align(
                  alignment: Alignment.centerLeft,
                  child: createInputField(
                      textLocation(context).inputTipsMessenger,
                      ctx: context,
                      width: double.infinity)),
              SizedBox(height: spacing),
              Align(
                  alignment: Alignment.centerLeft,
                  child: createInputField(
                      textLocation(context).inputTipsAddress,
                      ctx: context,
                      width: double.infinity)),
              const SizedBox(height: 20),
              createButton(textLocation(context).btnTextSave, hPadding: 40,
                  onTap: () {
                print('save');
              }),
            ])));
  }

  @override
  Widget build(BuildContext context) {
    double avtarRadius = 50;
    var url = 'https://p0.ssl.img.360kuai.com/t016e2f42c2f1145dc5.webp';
    return Scaffold(
      backgroundColor: isDark(context)
          ? BZColor.darkBackground
          : BZColor.background, //Colors.transparent,
      body: SingleChildScrollView(
        child: Container(
            height: BZSize.pageHeight,
            child: Stack(children: [
              Column(
                children: [
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageFile == null
                            ? NetworkImage(url)
                            : FileImage(imageFile!) as ImageProvider,
                        // NetworkImage(url), //背景图片
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: ClipRRect(
                      child: BackdropFilter(
                          //背景滤镜
                          filter:
                              ImageFilter.blur(sigmaX: 10, sigmaY: 10), //背景模糊化
                          child: const Text('')),
                    ),
                  ),
                  Expanded(child: _createFileds(context, 15))
                ],
              ),
              Positioned(
                child: _createUserImage(context, radius: avtarRadius),
                left: BZSize.pageWidth / 2 - avtarRadius,
                top: 150 - avtarRadius,
              ),
              Positioned(
                  child: SafeArea(
                      child: BackButton(
                          onPressed: () => Navigator.of(context).pop()),
                      top: true)),
            ])),
      ),
    );
  }
}
