import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wigtoday_app/app/user/models/user_cache.dart';
import 'package:wigtoday_app/app/user/models/user_profile.dart';
import 'package:wigtoday_app/utils/event_bus.dart';
import 'package:wigtoday_app/utils/size.dart';
import 'package:wigtoday_app/utils/theme.dart';
import 'package:wigtoday_app/widgets/components.dart';

// ignore: must_be_immutable
class ChangePassword extends StatefulWidget {
  UserProFileModle? userProFileModle;
  ChangePassword({Key? key, required this.userProFileModle}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<ChangePassword> createState() =>
      // ignore: no_logic_in_create_state
      _ChangePasswordState(userProFileModle: userProFileModle);
}

class _ChangePasswordState extends State<ChangePassword> with Components {
  _ChangePasswordState({this.userProFileModle});

  UserProFileModle? userProFileModle;
  late StreamSubscription stream;

  final oldControl = TextEditingController();
  final newControl = TextEditingController();
  final confirmControl = TextEditingController();

  String get oldPwd => oldControl.text;
  String get newPwd => newControl.text;
  String get firmPwd => confirmControl.text;

  Future<void> changePwd() async {
    try {
      print('start changePwd ====> ');
      if (oldPwd.isEmpty || newPwd.isEmpty || firmPwd.isEmpty) {
        showToast(msg: '请输入所有参数!', ctx: context);
        return;
      }
      if (newPwd != firmPwd) {
        showToast(msg: '请确认新的密码!', ctx: context);
        return;
      }

      if (oldPwd.isNotEmpty &&
          newPwd.isNotEmpty &&
          firmPwd.isNotEmpty &&
          (newPwd == firmPwd)) {
        var data = {'oldPassword': oldPwd, 'newPassword': newPwd};
        var resp = await post('/user/updatePassword',
            data: data, headers: getTokenHeaders(userProFileModle!));
        if (resp['code'] == 0) {
          UserCacheModel.getActiveUser().then((value) {
            if (value != null) {
              value.passwd = newPwd;
              value.save().then((value) {
                showToast(msg: resp['msg'], ctx: context);
                Future.delayed(const Duration(seconds: 1)).then((value) {
                  Navigator.pop(context);
                });
              });
            }
          });
        } else {
          showToast(msg: resp['msg'], ctx: context);
        }
      }
    } catch (e) {
      print('changePwd error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    stream = eventBus.on<WigTodayEvent>().listen((event) {
      setState(() {
        userProFileModle = event.profileModel;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    stream.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var url = 'https://p0.ssl.img.360kuai.com/t016e2f42c2f1145dc5.webp';
    var spacing = 10.0;
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(120),
            child: Container(
              decoration: BoxDecoration(
                  image: BZTheme.isDark(context)
                      ? null
                      : const DecorationImage(
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
                            child: getAvatar(
                                model: userProFileModle!,
                                context: context,
                                height: 80,
                                width: 80)

                            // Image.network(url,
                            //   height: 80, width: 80, fit: BoxFit.cover)
                            )),
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
              Text(userProFileModle!.account,
                  style: createTextStyle(
                      size: 20, ctx: context, weight: FontWeight.bold)),
              SizedBox(height: spacing * 4),
              createInputField(textLocation(context).inputTipsOldPwd,
                  controller: oldControl, width: double.infinity, ctx: context),
              SizedBox(height: spacing * 2),
              createInputField(textLocation(context).inputTipsNewPwd,
                  controller: newControl, width: double.infinity, ctx: context),
              SizedBox(height: spacing * 2),
              createInputField(textLocation(context).inputTipsConfirmPwd,
                  controller: confirmControl,
                  width: double.infinity,
                  ctx: context),
              SizedBox(height: spacing * 3),
              createButton(textLocation(context).btnTextSubmit, hPadding: 40,
                  onTap: () {
                changePwd();
              })
            ],
          ),
        )));
  }
}
