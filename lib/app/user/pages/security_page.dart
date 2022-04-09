import 'package:flutter/material.dart';
import 'package:wigtoday_app/app/user/widgets/change_password.dart';
import 'package:wigtoday_app/app/user/widgets/email_security.dart';
import 'package:wigtoday_app/utils/color.dart';
import 'package:wigtoday_app/utils/size.dart';
import 'package:wigtoday_app/utils/theme.dart';
import 'package:wigtoday_app/widgets/components.dart';


class SecurityPage extends StatefulWidget {
  SecurityPage({Key? key}) : super(key: key);

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> with Components {
  final titles = <String>[
    'Change your password regula ty to increaeeyour accounts protection .',
    'Please reset the password by venficatcrvi email the password is forgotten or theaccomm asten .',
    'Please reset the passwrod by venficatcrvi email the password is forgotten or theaccomm asten .'
  ];

  Widget createSecurityWidget(
      String title, String message, String iconPath, Color titleColor,
      {double radius = 10, double iconSize = 30, VoidCallback? onPress}) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        decoration: BoxDecoration(
            color: BZTheme.isDark(context) ? BZColor.darkCard: BZColor.card, borderRadius: BorderRadius.circular(radius)),
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
                      style: createTextStyle(size: 20, ctx: context, weight: FontWeight.bold),
                      // style: TextStyle(
                      //     color: titleColor,
                      //     fontFamily: 'SF Pro',
                      //     fontSize: 20,
                      //     fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      message,
                      style: createTextStyle(size: 14, ctx: context),
                      // style: const TextStyle(
                          // color: Colors.black,
                          // fontFamily: 'SF Pro',
                          // fontSize: 14),
                    ),
                  ])),
              const Icon(Icons.keyboard_arrow_right)
            ],
          ),
        ));
  }

  void showModalSheet(BuildContext context, Widget container) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        context: context,
        builder: (ctx) {
          return container;
        });
  }

  Widget createQuestionBottomSheet(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: BZTheme.isDark(context) ?BZColor.darkCard: Colors.white,
            borderRadius: BorderRadius.circular(20.0)),
        //topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        height: BZSize.pageHeight / 2 - 10,
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                textLocation(context).settingsSecurityPageQuestion,
                style: createTextStyle(size: 20, ctx: context),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
                iconSize: 35,
              )
            ],
          ),
          createInputField(textLocation(context).inputTipsSafety,
              width: double.infinity,
              spacing: 5,
              hintText: 'What primary school did you attend?',
              hintStyle: const TextStyle(
                  color: Colors.grey, fontFamily: 'SF Pro', fontSize: 13),
              readOnly: true,
              ctx: context),
          const SizedBox(height: 10),
          createInputField(textLocation(context).inputTipsAnswer, width: double.infinity, spacing: 5, ctx: context),
          const SizedBox(height: 20),
          createButton(textLocation(context).btnTextConfirm, hPadding: 0)
        ]));
  }

  @override
  Widget build(BuildContext context) {
    var radius = 10.0;
    var spacing = 10.0;
    var padding = 12.0;
    return Scaffold(
        backgroundColor: BZTheme.isDark(context)? BZColor.darkBackground:const Color(0xffECECEC),
        appBar: createAppBar(
          child: Container(
            child: Row(
              children: [BackButton(onPressed: () => Navigator.pop(context))],
            ),
          ),
          backgroundAssetName: BZTheme.isDark(context)? null: 'assets/images/security.png',
          height: 60),
    
        body: Container(
          padding: EdgeInsets.all(padding),
          child: Column(children: [
            Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  textLocation(context).settingsSecurityPageTitle,
                  style: createTextStyle(size: 20, ctx: context, weight: FontWeight.bold),
                )),
            SizedBox(height: spacing * 3),
            createSecurityWidget(
              textLocation(context).settingsSecurityPageChangePwd,
                titles[0],
                'assets/icons/password_security.png',
                const Color(0xff57DE9C), onPress: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (ctx) => ChangePassword()));
            }),
            SizedBox(height: spacing),
            createSecurityWidget(
                textLocation(context).settingsSecurityPageEmail,
                titles[1],
                'assets/icons/email_security.png',
                const Color(0xffFE4D6F), onPress: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (ctx) => EmailScecurity()));
            }),
            SizedBox(height: spacing),
            createSecurityWidget(
              textLocation(context).settingsSecurityPageQuestion,
                titles[2],
                'assets/icons/question_security.png',
                const Color(0xff7F88EF), onPress: () {
              showModalSheet(context, createQuestionBottomSheet(context));
            }),
          ]),
        ));
  }
}
