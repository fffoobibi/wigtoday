import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wigtoday_app/app/user/models/user_profile.dart';
import 'package:wigtoday_app/app/user/pages/change_password_page.dart';
import 'package:wigtoday_app/app/user/pages/email_security_page.dart';
import 'package:wigtoday_app/utils/color.dart';
import 'package:wigtoday_app/utils/event_bus.dart';
import 'package:wigtoday_app/utils/font.dart';
import 'package:wigtoday_app/utils/size.dart';
import 'package:wigtoday_app/utils/theme.dart';
import 'package:wigtoday_app/widgets/components.dart';

// ignore: must_be_immutable
class SecurityPage extends StatefulWidget {
  UserProFileModle userProFileModle;
  SecurityPage({Key? key, required this.userProFileModle}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<SecurityPage> createState() =>
      // ignore: no_logic_in_create_state
      _SecurityPageState(userProFileModle: userProFileModle);
}

class _SecurityPageState extends State<SecurityPage> with Components {
  _SecurityPageState({required this.userProFileModle});

  final answerControl = TextEditingController();

  late UserProFileModle userProFileModle;
  late StreamSubscription stream;
  List<Map<String, dynamic>> questionList = [];
  int currentQuestionIndex = 0;

  String get currentQuestion =>
      questionList.isEmpty ? '' : questionList[currentQuestionIndex]['q'];

  @override
  void initState() {
    super.initState();
    stream = eventBus.on<WigTodayEvent>().listen((event) {
      initLogin(event);
    });
    fetchQuestionList();
  }

  @override
  void dispose() {
    super.dispose();
    stream.cancel();
  }

  void initLogin(WigTodayEvent event) {
    setState(() {
      userProFileModle = event.profileModel!;
    });
  }

  void fetchQuestionList() {
    get('/passport/questions').then((value) {
      if (value['code'] == 0) {
        setState(() {
          questionList.clear();
          questionList.addAll(List.generate(value['data'].length,
              (index) => value['data'][index] as Map<String, dynamic>));
        });
      }
    });
  }

  Future<void> submitQuestion() async {
    try {
      var data = {
        'question_id': questionList[currentQuestionIndex]['id'],
        'answer': answerControl.text
      };
      print('data ==? $data');

      var resp = await post(
        '/user/setAnswer',
        data: data,
        headers: getTokenHeaders(userProFileModle),
      );
      if (resp['code'] == 0) {
        showToast(msg: resp['msg'], ctx: context);

      } else {
        showToast(msg: resp['msg'], ctx: context);
      }
    } catch (e) {}
  }

  void createSelectQuestionDialog(
      BuildContext c, void Function(void Function()) s) {
    showDialog(
        context: context,
        builder: (ctx) {
          return SimpleDialog(
              backgroundColor:
                  isDark(context) ? BZColor.darkCard : BZColor.card,
              children: List.generate(questionList.length, (index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SimpleDialogOption(
                      onPressed: () {
                        s(() {
                          currentQuestionIndex = index;
                        });
                        Navigator.pop(context);
                      },
                      child: Text(questionList[index]['q'],
                          style: createTextStyle(
                              size: BZFontSize.title, ctx: context)),
                    ),
                    const Divider(height: 1),
                  ],
                );
              }));
        });
  }

  Widget createSecurityWidget(
      String title, String message, String iconPath, Color titleColor,
      {double radius = 10, double iconSize = 30, VoidCallback? onPress}) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        decoration: BoxDecoration(
            color: BZTheme.isDark(context) ? BZColor.darkCard : BZColor.card,
            borderRadius: BorderRadius.circular(radius)),
        child: InkWell(
          onTap: onPress,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(iconPath,
                  height: iconSize, width: iconSize, fit: BoxFit.cover),
              const SizedBox(width: 5),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(
                      title,
                      style: createTextStyle(
                          size: BZFontSize.navTitle,
                          ctx: context,
                          weight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      message,
                      style:
                          createTextStyle(size: BZFontSize.title, ctx: context),
                    ),
                  ])),
              const Icon(Icons.keyboard_arrow_right)
            ],
          ),
        ));
  }

  void showModalSheet(BuildContext context) {
    showModalBottomSheet(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        context: context,
        builder: (ctx) {
          return StatefulBuilder(builder: (ctx, s) {
            return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: BZTheme.isDark(context)
                        ? BZColor.darkCard
                        : Colors.white,
                    borderRadius: BorderRadius.circular(20.0)),
                //topLeft: Radius.circular(10), topRight: Radius.circular(10))),
                height: BZSize.pageHeight / 2 - 10,
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        textLocation(context).settingsSecurityPageQuestion,
                        style: createTextStyle(
                            size: BZFontSize.navTitle, ctx: context),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                        iconSize: 35,
                      )
                    ],
                  ),
                  createInputField(textLocation(context).inputTipsSafety,
                      suffixIcon: const Icon(Icons.arrow_drop_down),
                      width: double.infinity,
                      spacing: 5,
                      hintText: currentQuestion,
                      hintStyle: createTextStyle(
                          light: Colors.grey,
                          dark: BZColor.darkGrey,
                          size: BZFontSize.subTitle,
                          ctx: context),
                      readOnly: true,
                      onTap: () => createSelectQuestionDialog(ctx, s),
                      ctx: context),
                  const SizedBox(height: 10),
                  createInputField(textLocation(context).inputTipsAnswer,
                      controller: answerControl,
                      width: double.infinity,
                      spacing: 5,
                      ctx: context),
                  const SizedBox(height: 20),
                  createButton(textLocation(context).btnTextConfirm,
                      hPadding: 0, onTap: () {
                        submitQuestion();
                    // EasyLoading.show();
                    // Future.delayed(Duration(seconds: 1))
                    //     .then((value) => EasyLoading.dismiss());
                  })
                ]));
          });

          // return container;
        });
  }

  Widget createQuestionBottomSheet(
      BuildContext c, void Function(void Function()) s) {
    return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: BZTheme.isDark(context) ? BZColor.darkCard : Colors.white,
            borderRadius: BorderRadius.circular(20.0)),
        //topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        height: BZSize.pageHeight / 2 - 10,
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                textLocation(context).settingsSecurityPageQuestion,
                style: createTextStyle(size: BZFontSize.navTitle, ctx: context),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
                iconSize: 35,
              )
            ],
          ),
          createInputField(textLocation(context).inputTipsSafety,
              suffixIcon: const Icon(Icons.arrow_drop_down),
              width: double.infinity,
              spacing: 5,
              hintText: currentQuestion,
              hintStyle: createTextStyle(
                  light: Colors.grey,
                  dark: BZColor.darkGrey,
                  size: BZFontSize.subTitle,
                  ctx: context),
              readOnly: true,
              onTap: () => createSelectQuestionDialog(c, s),
              ctx: context),
          const SizedBox(height: 10),
          createInputField(textLocation(context).inputTipsAnswer,
              width: double.infinity, spacing: 5, ctx: context),
          const SizedBox(height: 20),
          createButton(textLocation(context).btnTextConfirm, hPadding: 0)
        ]));
  }

  @override
  Widget build(BuildContext context) {
    var spacing = 10.0;
    var padding = 12.0;
    final titles = <String>[
      textLocation(context).settingsSecurityPwdTips,
      textLocation(context).settingsSecurityEmailTips,
      textLocation(context).settingsSecurityQuestionTips,
    ];
    return Scaffold(
        backgroundColor: BZTheme.isDark(context)
            ? BZColor.darkBackground
            : const Color(0xffECECEC),
        appBar: createAppBar(
            child: Row(
              children: [BackButton(onPressed: () => Navigator.pop(context))],
            ),
            backgroundAssetName:
                BZTheme.isDark(context) ? null : 'assets/images/security.png',
            height: 60),
        body: Container(
          padding: EdgeInsets.all(padding),
          child: Column(children: [
            Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  textLocation(context).settingsSecurityPageTitle,
                  style: createTextStyle(
                      size: 20, ctx: context, weight: FontWeight.bold),
                )),
            SizedBox(height: spacing * 3),
            createSecurityWidget(
                textLocation(context).settingsSecurityPageChangePwd,
                titles[0],
                'assets/icons/password_security.png',
                const Color(0xff57DE9C), onPress: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) =>
                          ChangePassword(userProFileModle: userProFileModle)));
            }),
            SizedBox(height: spacing),
            createSecurityWidget(
                textLocation(context).settingsSecurityPageEmail,
                titles[1],
                'assets/icons/email_security.png',
                const Color(0xffFE4D6F), onPress: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) => EmailScecurity(
                            userProFileModle: userProFileModle,
                          )));
            }),
            SizedBox(height: spacing),
            createSecurityWidget(
                textLocation(context).settingsSecurityPageQuestion,
                titles[2],
                'assets/icons/question_security.png',
                const Color(0xff7F88EF), onPress: () {
              showModalSheet(context);
            }),
          ]),
        ));
  }
}
