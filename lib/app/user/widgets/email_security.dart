import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wigtoday_app/utils/size.dart';
import 'package:wigtoday_app/utils/theme.dart';
import 'package:wigtoday_app/widgets/components.dart';

class EmailScecurity extends StatefulWidget {
  EmailScecurity({Key? key}) : super(key: key);

  @override
  State<EmailScecurity> createState() => _EmailScecurityState();
}

class _EmailScecurityState extends State<EmailScecurity> with Components {
  String? email = '16543418546@qq.com';

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
                  ctx: context,
                  width: double.infinity,
                  readOnly: true,
                  hintStyle: createTextStyle(
                      size: 12, color: Colors.grey, ctx: context)),
              SizedBox(height: spacing * 5),
              createButton(textLocation(context).btnTextNext, hPadding: 40,
                  onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (ctx) => EmailSecurityNext()));
              }),
            ],
          ),
        )));
  }
}

class EmailSecurityNext extends StatefulWidget {
  EmailSecurityNext({Key? key}) : super(key: key);

  @override
  State<EmailSecurityNext> createState() => _EmailSecurityNextState();
}

class _EmailSecurityNextState extends State<EmailSecurityNext> with Components {
  String? email = '1572343243@qq.com';

  @override
  Widget build(BuildContext context) {
    var url = 'https://p0.ssl.img.360kuai.com/t016e2f42c2f1145dc5.webp';
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
              Text(email!, style: createTextStyle(size: 20, ctx: context)),
              SizedBox(height: spacing * 4),
              createInputField(textLocation(context).inputTipsVerification,
                  width: double.infinity, ctx: context),
              SizedBox(height: spacing * 5),
              createButton(textLocation(context).btnTextNext, hPadding: 40, onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (ctx) =>
                            EmailSecurityCompleted(headerUrl: url)));
              })
            ],
          ),
        )));
  }
}

class EmailSecurityCompleted extends StatelessWidget with Components {
  EmailSecurityCompleted({Key? key, required this.headerUrl}) : super(key: key);
  String headerUrl;

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
                'Congratulations on your password change success!',
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
