import 'package:flutter/material.dart';
import 'package:wigtoday_app/utils/size.dart';
import 'package:wigtoday_app/utils/theme.dart';
import 'package:wigtoday_app/widgets/components.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> with Components {
  String? email = '82204556@qq.com';
  String? headerUrl;

  @override
  Widget build(BuildContext context) {
    var url = 'https://p0.ssl.img.360kuai.com/t016e2f42c2f1145dc5.webp';
    var spacing = 10.0;
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(120),
            child: Container(
              decoration:  BoxDecoration(
                  image: BZTheme.isDark(context) ? null: const DecorationImage(
                      image: AssetImage('assets/images/security.png'),
                      fit: BoxFit.cover,
                      repeat: ImageRepeat.noRepeat)),
              child: SafeArea(
                child: Stack(
                  children: [
                    Positioned(
                        top: 40,
                        left: BZSize.pageWidth / 2 - 40,
                        child: ClipOval(
                            child: Image.network(url,
                                height: 80, width: 80, fit: BoxFit.cover))),
                    Positioned(
                        right: 0,
                        child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                          iconSize: 40,
                        ))
                  ],
                ),
              ),
            )),
        body: SingleChildScrollView(
            child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Text(
                email!,
                style: createTextStyle(size: 20, ctx: context, weight: FontWeight.bold)
              
              ),
              SizedBox(height: spacing * 4),
              createInputField(textLocation(context).inputTipsOldPwd, width: double.infinity, ctx: context),
              SizedBox(height: spacing * 2),
              createInputField(textLocation(context).inputTipsNewPwd, width: double.infinity, ctx: context),
              SizedBox(height: spacing * 2),
              createInputField(textLocation(context).inputTipsConfirmPwd, width: double.infinity, ctx:context),
              SizedBox(height: spacing * 3),
              createButton(textLocation(context).btnTextSubmit, hPadding: 40)
            ],
          ),
        )));
  }
}
