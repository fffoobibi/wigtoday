import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wigtoday_app/app/user/models/user_profile.dart';
import 'package:wigtoday_app/utils/accounts.dart';
import 'package:wigtoday_app/utils/font.dart';
import 'package:wigtoday_app/utils/size.dart';
import 'package:wigtoday_app/widgets/components.dart';

class ForgetPwdPage extends StatefulWidget {
  ForgetPwdPage({Key? key, required this.account}) : super(key: key);
  String? account;

  @override
  // ignore: no_logic_in_create_state
  State<ForgetPwdPage> createState() => _ForgetPwdPageState(account: account);
}

class _ForgetPwdPageState extends State<ForgetPwdPage> with Components {
  String? account;
  late UserProFileModle userProFileModle;

  final accountControl = TextEditingController();

  _ForgetPwdPageState({required this.account});

  @override
  void initState() {
    super.initState();

    userProFileModle = UserProFileModle.getGuestModel();
    if (account != null) {
      accountControl.text = account as String;
      userProFileModle.account = account as String;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var spacing = 10.0;
    // if (userProFileModle != null) {
    //   accountControl.text = userProFileModle.account;
    // }

    Future<bool> sendEmailCode() async {
      try {
        var resp = await post('/passport/getEmailAuthCode',
            data: {'email': accountControl.text, 'type': 'findpwd'});
        print('data ====> ');
        if (resp['code'] == 0) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (ctx) =>
                      ForgetPwdNext(userProFileModle: userProFileModle, correctCode: resp['data']['code'],)));
          return true;
        } else {
          showToast(msg: resp['msg'], ctx: context);
          return true;
        }
        // ignore: empty_catches
      } catch (e) {
        return true;
      }
    }

    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(120),
            child: Container(
              decoration: BoxDecoration(
                  image: isDark(context)
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
                        left: 0,
                        child: Container(
                            width: BZSize.pageWidth,
                            child: Image.asset('assets/images/logo_title.png',
                                height: 40))),
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
              createInputField(textLocation(context).inputTipsEmailAddress,
                  controller: accountControl,
                  ctx: context,
                  width: double.infinity,
                  readOnly: true,
                  hintStyle: createTextStyle(
                      size: BZFontSize.content,
                      color: Colors.grey,
                      ctx: context)),
              SizedBox(height: spacing * 5),
              createLoadingButton(textLocation(context).btnTextNext,
                  hPadding: 40, onTap: sendEmailCode),
            ],
          ),
        )));
  }
}

class ForgetPwdNext extends StatefulWidget {
  UserProFileModle userProFileModle;
  String correctCode;
  ForgetPwdNext({Key? key, required this.userProFileModle, required this.correctCode}) : super(key: key);

  @override
  State<ForgetPwdNext> createState() =>
      _ForgetPwdNextState(userProFileModle: userProFileModle, correctCode: correctCode);
}

class _ForgetPwdNextState extends State<ForgetPwdNext> with Components {
  UserProFileModle? userProFileModle;
  String correctCode;
  _ForgetPwdNextState({required this.userProFileModle, required this.correctCode});

  final codeControl = TextEditingController();

  Future<bool> checkCode() async {
    try {
      if (correctCode ==codeControl.text) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (ctx) => ForgetPwdConfirmPwd(
                    code: codeControl.text,
                    userProFileModle: userProFileModle!)));
        return true;
      } else {
          showToast(msg: 'error auth code!', ctx: context);
        return true;
      }
    } catch (e) {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    var spacing = 10.0;
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(120),
            child: Container(
              decoration: isDark(context)
                  ? null
                  : const BoxDecoration(
                      image: DecorationImage(
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
                                width: 80))),
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
                  style: createTextStyle(size: BZFontSize.big, ctx: context)),
              SizedBox(height: spacing),
              Text(textLocation(context).feedBackVerificationCodeHasSent,
                  style: createTextStyle(size: BZFontSize.title, ctx: context)),
              SizedBox(height: spacing * 4),
              createInputField(textLocation(context).inputTipsVerification,
                  controller: codeControl,
                  width: double.infinity,
                  ctx: context),
              SizedBox(height: spacing * 5),
              // createInputField(textLocation(context).inputTipsConfirmPwd,
              // width: double.infinity, ctx: context
              // ),
              createLoadingButton(textLocation(context).btnTextNext,
                  hPadding: 40, onTap: checkCode)
            ],
          ),
        )));
  }
}

// ignore: must_be_immutable
class ForgetPwdConfirmPwd extends StatefulWidget {
  UserProFileModle userProFileModle;
  String code;

  ForgetPwdConfirmPwd(
      {Key? key, required this.userProFileModle, required this.code})
      : super(key: key);

  @override
  State<ForgetPwdConfirmPwd> createState() =>
      // ignore: no_logic_in_create_state
      _ForgetPwdConfirmPwdState(userProFileModle: userProFileModle, code: code);
}

class _ForgetPwdConfirmPwdState extends State<ForgetPwdConfirmPwd>
    with Components {
  String code;
  UserProFileModle userProFileModle;

  _ForgetPwdConfirmPwdState(
      {required this.userProFileModle, required this.code});

  final pwdControl = TextEditingController();
  final confirmControl = TextEditingController();

  Future<bool> resetNewPwd() async {
    try {
      if (pwdControl.text != confirmControl.text) {
        showToast(msg: '两次密码不一致', ctx: context);
        // print('t1: ${pwdControl.text} t2: ${confirmControl.text}');
        return false;
      }
      var postData = {
        'account': userProFileModle.account,
        'code': code,
        'password': pwdControl.text
      };
      var resp = await post('/passport/resetPassword', data: postData);
      if (resp['code'] == 0) {
        Navigator.push(context,
                MaterialPageRoute(builder: (ctx) => ForgetPwdCompleted()));
        //     .then((v) {
        //   AccountManage.updateActiveUser(newPwd: pwdControl.text);
        // });
        return true;
      } else {
        showToast(msg: resp['msg'], ctx: context);
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var spacing = 10.0;
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(120),
            child: Container(
              decoration: isDark(context)
                  ? null
                  : const BoxDecoration(
                      image: DecorationImage(
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
                                model: userProFileModle,
                                context: context,
                                height: 80,
                                width: 80))),
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
              Text(userProFileModle.account,
                  style: createTextStyle(size: BZFontSize.big, ctx: context)),
              SizedBox(height: spacing * 4),
              createInputField(textLocation(context).inputTipsNewPwd,
                  controller: pwdControl, width: double.infinity, ctx: context),
              SizedBox(height: spacing * 1),
              createInputField(textLocation(context).inputTipsConfirmPwd,
                  controller: confirmControl,
                  width: double.infinity,
                  ctx: context),
              SizedBox(height: spacing * 5),
              createLoadingButton(textLocation(context).btnTextSubmit,
                  hPadding: 40, onTap: resetNewPwd)
            ],
          ),
        )));
  }
}

class ForgetPwdCompleted extends StatelessWidget with Components {
  ForgetPwdCompleted({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var spacing = 10.0;
    return Scaffold(
        appBar: createAppBar(
            height: 120,
            backgroundAssetName:
                isDark(context) ? null : 'assets/images/security.png',
            child: Stack(
              children: [
                Positioned(
                    right: 0,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                      iconSize: 40,
                    ))
              ],
            )),
        body: SingleChildScrollView(
            child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              SizedBox(height: spacing * 4),
              Image.asset('assets/icons/complete.png',
                  height: 50, width: 50, fit: BoxFit.cover),
              SizedBox(height: spacing * 3),
              Text(
                textLocation(context).feedBackResetPasswdOk,
                // 'Congratulations on your password change success!',
                style: createTextStyle(size: 12, ctx: context),
              ),
              SizedBox(height: spacing * 5),
              createButton(
                textLocation(context).btnTextConfirm,
                hPadding: 40,
              )
            ],
          ),
        )));
  }
}
