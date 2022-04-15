// ignore_for_file: unnecessary_this, empty_catches

import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pickers/style/picker_style.dart';
import 'package:flutter_pickers/time_picker/model/date_mode.dart';
import 'package:flutter_pickers/time_picker/model/pduration.dart';
import 'package:flutter_pickers/time_picker/model/suffix.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wigtoday_app/app/user/models/use_country.dart';
import 'package:wigtoday_app/app/user/models/user_profile.dart';
import 'package:wigtoday_app/utils/accounts.dart';
import 'package:wigtoday_app/utils/color.dart';
import 'package:wigtoday_app/utils/event_bus.dart';
import 'package:wigtoday_app/utils/font.dart';
import 'package:wigtoday_app/utils/size.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:wigtoday_app/widgets/components.dart';

// ignore: must_be_immutable
class UserProfile extends StatefulWidget {
  bool isLogin;
  UserProFileModle? userProFileModle;
  List<UserCountryModel>? countryList;
  UserProfile(
      {Key? key,
      required this.isLogin,
      required this.userProFileModle,
      required this.countryList})
      : super(key: key);

  @override
  State<UserProfile> createState() =>
      // ignore: no_logic_in_create_state
      _UserProfileState(isLogin, userProFileModle, countryList);
}

class _UserProfileState extends State<UserProfile>
    with Components, AutomaticKeepAliveClientMixin {
  bool isLogin;
  UserProFileModle? _userProFileModle;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker picker = ImagePicker();
  File? imageFile;

  final _firstNameControl = TextEditingController();
  final _lastNameControl = TextEditingController();
  final _genderControl = TextEditingController();
  final _countryControl = TextEditingController();
  final _birthControl = TextEditingController();
  final _phoneControl = TextEditingController();
  final _instantControl = TextEditingController();
  final _addressControl = TextEditingController();
  
  int trueCountryIndex = 0;
  int trueGenderIndex=0;

  _UserProfileState(this.isLogin, this._userProFileModle, this.countryList);

  List<UserCountryModel>? countryList;

  late StreamSubscription stream;

  Map<String, dynamic> postData(String? avatar) {
    return {
      'first_name': _firstNameControl.text,
      'last_name': _lastNameControl.text,
      'gender': 1,
      'country': countryList![trueCountryIndex].en,
      'birthday': _birthControl.text,
      'phone': _phoneControl.text,
      'other_instant': _instantControl.text,
      'address': _addressControl.text,
      'avatar': avatar
    }..removeWhere((key, value) => value == null);
  }

  bool get validate {
    return true;
  }

  Future<String?> uploadAvatarImage(File image) async {
    try {
      String path = image.path;
      var name = path.substring(path.lastIndexOf("/") + 1, path.length);
      var suffix = name.substring(name.lastIndexOf(".") + 1, name.length);
      FormData formData = FormData.fromMap({
        "dir": "avatar",
        "image": await MultipartFile.fromFile(path, filename: name)
      });
      var resp = await post('/upload?dir', fdata: formData);
      if (resp['code'] == 0) {
        // showToast(msg: "图片上传成功", ctx: context);
        return resp['data'];
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> save() async {
    try {
      if (validate) {
        String? avatar;
        if (imageFile != null) {
          String? avatarName = await uploadAvatarImage(imageFile!); // 上传头像
          if (avatarName != null) {
            avatar = avatarName;
          }
        }

        if (imageFile != null && avatar == null) {
          showToast(msg: '头像上传失败!', ctx: context);
          return true;
        }
        print('post data: ${postData(avatar)}');
        var resp = await post('/user/updateProfile',
            data: postData(avatar),
            headers: getTokenHeaders(_userProFileModle!));

        if (resp['code'] == 0) {
          showToast(msg: resp['msg'], ctx: context);
          var updatedProfile = await AccountManager.fetchUserProfileModel(
              currentProfileModel: _userProFileModle!);
          print('update info: ${updatedProfile!.phone}');
          if (updatedProfile != null) {
            var activeUser = await AccountManager.getActiveUser();
            activeUser!.userProFileModle = updatedProfile;
            bool saved = await activeUser.save();
            print('save again $saved');

            // modify event
            eventBus.fire(WigTodayEvent(
                isLogin,
                WigtodayEventType.modify,
                _userProFileModle!
                    .getUserCacheModel(isActive: true, pwd: activeUser.passwd),
                updatedProfile));
          }
        } else {
          // print('save error: ${resp["msg"]}');
          showToast(msg: resp['msg'], ctx: context);
        }
      } else {
        showToast(
            msg: 'validate error', ctx: context, gravity: ToastGravity.CENTER);
      }
      return true;
    } catch (e) {
      return true;
    }
  }

  void loadProfileInfo() {
    if (_userProFileModle != null) {
      _firstNameControl.text = _userProFileModle!.firstName;
      _lastNameControl.text = _userProFileModle!.lastName;
      _genderControl.text = _userProFileModle!.gender == 1
          ? textLocation(context).textMale
          : textLocation(context).textFemale;
      _countryControl.text = _userProFileModle!.country;
      _birthControl.text = _userProFileModle!.birthday;
      _phoneControl.text = _userProFileModle!.phone;
      _instantControl.text = _userProFileModle!.otherInstant;
      _addressControl.text = _userProFileModle!.address;
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    stream = eventBus.on<WigTodayEvent>().listen((event) {
      print('get event in user profile =====');
      if (event.type != WigtodayEventType.modify) {
        isLogin = event.isLogin;
        _userProFileModle = event.profileModel;
        loadProfileInfo();
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    stream.cancel();
  }

  LocaleType getLocalType() {
    var local = Localizations.localeOf(context);
    if (local.languageCode.toLowerCase() == 'zh') {
      if (local.countryCode == 'TW') {
        return LocaleType.tw;
      } else if (local.countryCode == 'HK') {
        return LocaleType.tw;
      }
      return LocaleType.zh;
    }
    return LocaleType.en;
  }

  Suffix _getSuffix() {
    String month;
    String day;
    LocaleType type = getLocalType();
    if (type == LocaleType.zh || type == LocaleType.tw) {
      month = ' 月';
      day = ' 日';
    } else {
      month = ' M';
      day = ' d';
    }
    return Suffix(month: month, days: day);
  }

  PDuration _getDate() {
    int? month;
    int? day;
    if (isLogin) {
      if (_userProFileModle!.birthday.isNotEmpty) {
        var res = _userProFileModle!.birthday.split('-');
        month = int.parse(res[0]);
        day = int.parse(res[1]);
      }
    }
    return PDuration(month: month, day: day);
  }

  void dateOnTap() {
    Pickers.showDatePicker(context,
        mode: DateMode.MD,
        suffix: _getSuffix(),
        selectDate: _getDate(), onConfirm: (p) {
      String m = '${p.month}'.padLeft(2, '0');
      String d = '${p.day}'.padLeft(2, '0');
      _birthControl.text = '$m-$d';
    },
        pickerStyle: PickerStyle(
            textSize: BZFontSize.navTitle,
            cancelButton: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  textLocation(context).textCancel,
                  style: createTextStyle(ctx: context, size: BZFontSize.title),
                )),
            commitButton: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  textLocation(context).btnTextConfirm,
                  style: createTextStyle(ctx: context, size: BZFontSize.title),
                )),
            headDecoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                color: isDark(context) ? BZColor.darkCard : BZColor.card),
            textColor: isDark(context) ? BZColor.darkTitle : BZColor.title,
            backgroundColor:
                isDark(context) ? BZColor.darkCard : BZColor.card));
  }

  void maleOnTap() {
    var males = [
      textLocation(context).textFemale,
      textLocation(context).textMale,
    ];

    Pickers.showSinglePicker(context, onConfirm: (data, position) {
      trueGenderIndex = position;
      _genderControl.text = data;
    },
        pickerStyle: PickerStyle(
            textSize: BZFontSize.navTitle,
            cancelButton: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  textLocation(context).textCancel,
                  style: createTextStyle(ctx: context, size: BZFontSize.title),
                )),
            commitButton: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  textLocation(context).btnTextConfirm,
                  style: createTextStyle(ctx: context, size: BZFontSize.title),
                )),
            headDecoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                color: isDark(context) ? BZColor.darkCard : BZColor.card),
            textColor: isDark(context) ? BZColor.darkTitle : BZColor.title,
            backgroundColor: isDark(context) ? BZColor.darkCard : BZColor.card),
        data: males);
  }

  void countryOnTap() {
    Pickers.showSinglePicker(context, onConfirm: (data, position) {
      trueCountryIndex = position;
      _countryControl.text = data;
    },
        pickerStyle: PickerStyle(
            textSize: BZFontSize.navTitle,
            cancelButton: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  textLocation(context).textCancel,
                  style: createTextStyle(ctx: context, size: BZFontSize.title),
                )),
            commitButton: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  textLocation(context).btnTextConfirm,
                  style: createTextStyle(ctx: context, size: BZFontSize.title),
                )),
            headDecoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                color: isDark(context) ? BZColor.darkCard : BZColor.card),
            textColor: isDark(context) ? BZColor.darkTitle : BZColor.title,
            backgroundColor: isDark(context) ? BZColor.darkCard : BZColor.card),
        data: countryList != null
            ? countryList!.map((e) => e.currentLocalText(context)).toList()
            : []);
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

  Widget _createUserImagePolicy(double radius) {
    if (isLogin) {
      if (_userProFileModle!.avatar.isEmpty) {
        return Container(
            child: Icon(
              Icons.person_rounded,
              color: Color(0xffECECEC),
              size: radius,
            ),
            height: radius * 2,
            width: radius * 2,
            color: isDark(context) ? BZColor.darkBackground : Colors.white);
      }
      return Image.network(_userProFileModle!.avatar,
          height: radius * 2, width: radius * 2, fit: BoxFit.cover);
    }
    return Image.asset('assets/icons/user${isDark(context) ? "_dark" : ""}.png',
        height: radius * 2, width: radius * 2, fit: BoxFit.cover);
  }

  Widget _createUserImage(BuildContext context, {double radius = 50.0}) {
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
                            style: createTextStyle(
                                size: BZFontSize.title, ctx: context))),
                    const Divider(),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(textLocation(context).textCancel,
                            style: createTextStyle(
                                size: BZFontSize.title, ctx: context)))
                  ]),
                ));
      },
      child: Stack(children: [
        ClipOval(
            child: imageFile != null
                ? Image.file(imageFile!,
                    height: radius * 2, width: radius * 2, fit: BoxFit.cover)
                : _createUserImagePolicy(radius)),
        // ),
        Positioned(
            bottom: 0,
            left: 0,
            child: ClipOval(
                child: Column(children: [
              Container(
                width: radius * 2,
                height: radius * 2 - 25,
                // color: _createUserImageColor(),
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
                      ctx: context, controller: _firstNameControl),
                  createInputField(textLocation(context).inputTipsLastName,
                      ctx: context, controller: _lastNameControl),
                ],
              ),
              SizedBox(height: spacing),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  createInputField(textLocation(context).inputTipsGender,
                      suffixIcon: Icon(Icons.arrow_drop_down_outlined),
                      ctx: context,
                      readOnly: true,
                      controller: _genderControl),
                  createInputField(textLocation(context).inputTipsCountry,
                      suffixIcon: Icon(Icons.arrow_drop_down_outlined),
                      ctx: context,
                      readOnly: true,
                      controller: _countryControl,
                      onTap: countryOnTap),
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
                  child: createInputField(textLocation(context).inputTipsMobile,
                      controller: _phoneControl,
                      keyboardType: TextInputType.number,
                      width: double.infinity,
                      ctx: context)),
              SizedBox(height: spacing),
              Align(
                  alignment: Alignment.centerLeft,
                  child: createInputField(
                      textLocation(context).inputTipsMessenger,
                      controller: _instantControl,
                      ctx: context,
                      width: double.infinity)),
              SizedBox(height: spacing),
              Align(
                  alignment: Alignment.centerLeft,
                  child: createInputField(
                      textLocation(context).inputTipsAddress,
                      controller: _addressControl,
                      ctx: context,
                      width: double.infinity)),
              const SizedBox(height: 20),
              createLoadingButton(textLocation(context).btnTextSave,
                  hPadding: 40, onTap: save),
            ])));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double avtarRadius = 50;
    loadProfileInfo();
    print('buld profile_page =====');

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
                            ? (isLogin
                                ? (_userProFileModle!.avatar.isNotEmpty
                                        ? NetworkImage(_userProFileModle!.avatar)
                                        : AssetImage(
                                            'assets/icons/user${isDark(context) ? "_dark" : ""}.png'))
                                    as ImageProvider
                                : AssetImage(isDark(context)
                                    ? 'assets/icons/user.png'
                                    : 'assets/icons/user_dark.png'))
                            : FileImage(imageFile!),
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
