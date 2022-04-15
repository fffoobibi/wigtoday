import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wigtoday_app/app/user/models/user_profile.dart';
import 'package:wigtoday_app/utils/accounts.dart';
import 'package:wigtoday_app/utils/event_bus.dart';
import 'package:wigtoday_app/utils/font.dart';
import 'package:wigtoday_app/utils/size.dart';
import 'package:wigtoday_app/utils/theme.dart';
import 'package:wigtoday_app/widgets/components.dart';

class EmailScecurity extends StatefulWidget {
  EmailScecurity({Key? key, required this.userProFileModle}) : super(key: key);
  UserProFileModle? userProFileModle;

  @override
  // ignore: no_logic_in_create_state
  State<EmailScecurity> createState() =>
      // ignore: no_logic_in_create_state
      _EmailScecurityState(userProFileModle: userProFileModle);
}

class _EmailScecurityState extends State<EmailScecurity> with Components {
  late StreamSubscription stream;
  final accountControl = TextEditingController();
  UserProFileModle? userProFileModle;

  _EmailScecurityState({required this.userProFileModle});

  @override
  void initState() {
    super.initState();
    stream = eventBus.on<WigTodayEvent>().listen((event) {
      accountControl.text = event.profileModel!.account;
    });
  }

  @override
  void dispose() {
    super.dispose();
    stream.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var spacing = 10.0;
    if (userProFileModle != null) {
      accountControl.text = userProFileModle!.account;
    }

    Future<bool> sendEmailCode() async {
      try {
        var resp = await post('/passport/getEmailAuthCode',
            data: {'email': userProFileModle!.account, 'type': 'findpwd'});
        if (resp['code'] == 0) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (ctx) =>
                      EmailSecurityNext(userProFileModle: userProFileModle!)));
        } else {
          showToast(msg: resp['msg'], ctx: context);
        }
        // ignore: empty_catches
      } catch (e) {
      } finally {
        return true;
      }
    }

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
              SizedBox(height: spacing),
              Text(textLocation(context).textEmailTips,
                  style: createTextStyle(
                      size: BZFontSize.title, color: Colors.red)),
              SizedBox(height: spacing * 5),
              createLoadingButton(textLocation(context).btnTextNext,
                  hPadding: 40, onTap: sendEmailCode),
            ],
          ),
        )));
  }
}

class EmailSecurityNext extends StatefulWidget {
  UserProFileModle userProFileModle;
  EmailSecurityNext({Key? key, required this.userProFileModle})
      : super(key: key);

  @override
  State<EmailSecurityNext> createState() =>
      _EmailSecurityNextState(userProFileModle: userProFileModle);
}

class _EmailSecurityNextState extends State<EmailSecurityNext> with Components {
  UserProFileModle? userProFileModle;
  _EmailSecurityNextState({required this.userProFileModle});

  final codeControl = TextEditingController();

  Future<bool> submit() async {
    try {
      var resp = await post('/user/verifyEmail',
          data: {'type': 'active', 'code': codeControl.text},
          headers: getTokenHeaders(userProFileModle!));
      if (resp['code'] == 0) {
        Navigator.push(context,
            MaterialPageRoute(builder: (ctx) => EmailSecurityCompleted()));
      } else {
        showToast(msg: resp['msg'], ctx: context);
      }
      // ignore: empty_catches
    } catch (e) {
    } finally {
      // ignore: control_flow_in_finally
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
              decoration: BZTheme.isDark(context)
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
                  hPadding: 40, onTap: submit)
            ],
          ),
        )));
  }
}

// ignore: must_be_immutable
// class EmailSecurityConfirmPwd extends StatefulWidget {
//   UserProFileModle userProFileModle;
//   String code;

//   EmailSecurityConfirmPwd(
//       {Key? key, required this.userProFileModle, required this.code})
//       : super(key: key);

//   @override
//   State<EmailSecurityConfirmPwd> createState() =>
//       // ignore: no_logic_in_create_state
//       _EmailSecurityConfirmPwdState(
//           userProFileModle: userProFileModle, code: code);
// }

// class _EmailSecurityConfirmPwdState extends State<EmailSecurityConfirmPwd>
//     with Components {
//   String code;
//   UserProFileModle userProFileModle;

//   _EmailSecurityConfirmPwdState(
//       {required this.userProFileModle, required this.code});

//   final pwdControl = TextEditingController();
//   final confirmControl = TextEditingController();

//   Future<bool> resetNewPwd() async {
//     try {
//       if (pwdControl.text != confirmControl.text) {
//         showToast(msg: '两次密码不一致', ctx: context);
//         print('t1: ${pwdControl.text} t2: ${confirmControl.text}');
//         return false;
//       }
//       var postData = {
//         'account': userProFileModle.account,
//         'code': code,
//         'password': pwdControl.text
//       };

//       print('post data ===> $postData');

//       var resp = await post('/passport/resetPassword', data: postData);
//       if (resp['code'] == 0) {
//         Navigator.push(context,
//                 MaterialPageRoute(builder: (ctx) => EmailSecurityCompleted()))
//             .then((v) {
//           AccountManage.updateActiveUser(newPwd: pwdControl.text);
//         });
//         return true;
//       } else {
//         showToast(msg: resp['msg'], ctx: context);
//         return false;
//       }
//     } catch (e) {
//       return false;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     var spacing = 10.0;
//     return Scaffold(
//         appBar: PreferredSize(
//             preferredSize: const Size.fromHeight(120),
//             child: Container(
//               decoration: BZTheme.isDark(context)
//                   ? null
//                   : const BoxDecoration(
//                       image: DecorationImage(
//                           image: AssetImage('assets/images/security.png'),
//                           fit: BoxFit.cover,
//                           repeat: ImageRepeat.noRepeat)),
//               child: SafeArea(
//                 child: Stack(
//                   children: [
//                     Positioned(
//                         top: 40,
//                         left: BZSize.pageWidth / 2 - 40,
//                         child: ClipOval(
//                             child: getAvatar(
//                                 model: userProFileModle,
//                                 context: context,
//                                 height: 80,
//                                 width: 80))),
//                     Positioned(
//                         right: 0,
//                         child: IconButton(
//                           onPressed: () => Navigator.pop(context),
//                           icon: const Icon(Icons.close),
//                           iconSize: 40,
//                         ))
//                   ],
//                 ),
//               ),
//             )),
//         body: SingleChildScrollView(
//             child: Container(
//           padding: const EdgeInsets.all(12),
//           child: Column(
//             children: [
//               Text(userProFileModle.account,
//                   style: createTextStyle(size: BZFontSize.big, ctx: context)),
//               SizedBox(height: spacing * 4),
//               createInputField(textLocation(context).inputTipsNewPwd,
//                   controller: pwdControl, width: double.infinity, ctx: context),
//               SizedBox(height: spacing * 1),
//               createInputField(textLocation(context).inputTipsConfirmPwd,
//                   controller: confirmControl,
//                   width: double.infinity,
//                   ctx: context),
//               SizedBox(height: spacing * 5),
//               createButton(textLocation(context).btnTextSubmit, hPadding: 40,
//                   onTap: () {
//                 resetNewPwd();
//               })
//             ],
//           ),
//         )));
//   }
// }

class EmailSecurityCompleted extends StatelessWidget with Components {
  EmailSecurityCompleted({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var spacing = 10.0;
    return Scaffold(
        appBar: createAppBar(
            height: 120,
            backgroundAssetName:
                BZTheme.isDark(context) ? null : 'assets/images/security.png',
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
                textLocation(context).feedBackVerificationCodeOk,
                style: createTextStyle(size: BZFontSize.subTitle, ctx: context),
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
