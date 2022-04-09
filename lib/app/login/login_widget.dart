import 'package:flutter/material.dart';
import 'package:wigtoday_app/utils/color.dart';
import 'package:wigtoday_app/utils/font.dart';
import 'package:wigtoday_app/widgets/components.dart';

class LoginWidget extends StatefulWidget {
  // 登录页面
  const LoginWidget({Key? key}) : super(key: key);
  // final List<Widget> tabWidgets = const [LoginPage(), RegisterPage()];

  @override
  State<StatefulWidget> createState() => _LoginWidgetPage();
}

class _LoginWidgetPage extends State<LoginWidget>
    with TickerProviderStateMixin, Components {
  late TabController _tabController;
  late List<Widget> _tabWidgets;

  void initStateWithContext(BuildContext context) {
    _tabWidgets = const [LoginPage(), RegisterPage()];
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      // print('change: ${_tabController.index}');
    });
  }

  @override
  Widget build(BuildContext context) {
    initStateWithContext(context);
    return Scaffold(
      backgroundColor:
          isDark(context) ? BZColor.darkBackground : BZColor.background,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: TabBar(
              unselectedLabelColor: Colors.transparent,
              indicatorColor: isDark(context) ? Colors.red : Colors.black,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 3.0,
              controller: _tabController,
              tabs: [
                Tab(
                    child: Text(textLocation(context).capSign,
                        style: createTextStyle(
                            ctx: context,
                            size: BZFontSize.big,
                            weight: FontWeight.bold))),
                Tab(
                    child: Text(textLocation(context).capRegister,
                        style: createTextStyle(
                            ctx: context,
                            size: BZFontSize.big,
                            weight: FontWeight.bold)))
              ])),
      body: TabBarView(controller: _tabController, children: _tabWidgets),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage>
    with AutomaticKeepAliveClientMixin, Components {
  // 登录页面

  String? _account;
  String? _password;

  final _formKey = GlobalKey<FormState>();
  double padding = 20.0;

  void loginOk() {
    _formKey.currentState!.validate();
    print('login state ====> : $_account, $_password');
  }

  Widget _createPage(BuildContext context) {
    return SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  textLocation(context).textHello,
                  style: createTextStyle(size: 56 / 2, ctx: context),
                ),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: textLocation(context).textWelcome,
                      style: createTextStyle(
                          ctx: context, size: BZFontSize.content)),
                  TextSpan(
                      text: textLocation(context).textRegister,
                      style: createTextStyle(
                          size: BZFontSize.content,
                          weight: FontWeight.bold,
                          ctx: context))
                ])),
                const SizedBox(height: 10),
                createInputField(textLocation(context).inputTipsEmailAddress,
                  validator: (value) {
                    if (value =='') {
                      return "请输入账号";
                    }
                    return null;
                  }, 
                  setter: (val) {
                    _account = val;
                  },
                  width: double.infinity,
                  ctx: context,
                  restWidget: InkWell(
                      splashColor: Colors.transparent,
                      onTap: () {
                        // print('tap ======>');
                      },
                      child: Text(
                        textLocation(context).inputTipsForgetPwd,
                        style: createTextStyle(
                            size: BZFontSize.content,
                            ctx: context,
                            dark: BZColor.darkGrey,
                            light: BZColor.grey),
                      ))),
                const SizedBox(height: 10),
                createInputField(textLocation(context).titlePassword,
                    setter: (val) {
                  _password = val;
                }, width: double.infinity, ctx: context),

                // Row(children: [
                //   Expanded(
                //       flex: 1,
                //       child: RichText(
                //           text: TextSpan(children: [
                //         const TextSpan(
                //             text: '* ',
                //             style: TextStyle(color: Colors.red, fontSize: BZFontSize.min)),
                //         TextSpan(
                //             text: textLocation(context).inputTipsEmailAddress,
                //             style: createTextStyle(size: BZFontSize.min, ctx: context))
                //       ]))),
                //   Expanded(
                //     flex: 0,
                //     child: RichText(
                //         text: TextSpan(
                //             text: textLocation(context).inputTipsForgetPwd,
                //             style: createTextStyle(
                //                 light: BZColor.grey,
                //                 dark: BZColor.darkGrey,
                //                 size: BZFontSize.min,
                //                 ctx: context))),
                //   ),
                // ]),
                // const SizedBox(height: 10),
                // const SizedBox(
                //     height: 30,
                //     width: 630,
                //     child: TextField(
                //       decoration: InputDecoration(
                //           border: OutlineInputBorder(
                //               borderRadius: BorderRadius.all(Radius.circular(3)))),
                //     )),
                // const SizedBox(height: 10),
                // RichText(
                //     text: TextSpan(children: [
                //   const TextSpan(
                //       text: '* ',
                //       style: TextStyle(color: Colors.red, fontSize: 11)),
                //   TextSpan(
                //       text: textLocation(context).titlePassword,
                //       style: createTextStyle(size: BZFontSize.min, ctx: context))
                // ])),
                // const SizedBox(height: 10),
                // const SizedBox(
                //     height: 30,
                //     width: 630,
                //     child: TextField(
                //       obscureText: true,
                //       decoration: InputDecoration(
                //           border: OutlineInputBorder(
                //               borderRadius: BorderRadius.all(Radius.circular(3)))),
                //     )),
                const SizedBox(height: 20),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: textLocation(context)
                          .textIncorrect, //'Incorrect email or password.',
                      style: const TextStyle(color: Colors.red))
                ])),
                const SizedBox(height: 30),
                createButton(textLocation(context).btnTextSign,
                    hPadding: 40, width: double.infinity, onTap: loginOk),
                // Row(
                //     // width: 500 / 2,
                //     children: [
                //       Expanded(
                //           child: Container(
                //         height: 90 / 2,
                //         padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                //         child: ElevatedButton(
                //             style: ButtonStyle(
                //                 elevation: MaterialStateProperty.all(0),
                //                 shadowColor:
                //                     MaterialStateProperty.all(Colors.transparent),
                //                 backgroundColor: MaterialStateProperty.all(Colors.red)),
                //             onPressed: () {
                //               loginOk(context);
                //             },
                //             child: const Text('SIGN IN',
                //                 style: TextStyle(
                //                     color: Colors.white,
                //                     fontFamily: 'sfpro-bold',
                //                     fontSize: 32 / 2))),
                //       )),
                //     ]),
                const SizedBox(
                  height: 70,
                ),
                Center(
                    child: Text(textLocation(context).textLogin,
                        style: createTextStyle(
                            light: BZColor.grey,
                            dark: BZColor.darkGrey,
                            size: BZFontSize.title,
                            ctx: context))),
                const SizedBox(height: 20),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    Ink(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25)),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(25),
                        onTap: () {},
                        child: ClipOval(
                            child: Image.asset(
                          'assets/icons/instagram.png',
                          height: 50,
                          width: 50,
                        )),
                      ),
                    ),
                    Ink(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25)),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(25),
                        onTap: () {},
                        child: ClipOval(
                            child: Image.asset(
                          'assets/icons/pinterest.png',
                          height: 50,
                          width: 50,
                        )),
                      ),
                    ),
                    Ink(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25)),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(25),
                        onTap: () {},
                        child: ClipOval(
                            child: Image.asset(
                          'assets/icons/facebook.png',
                          height: 50,
                          width: 50,
                        )),
                      ),
                    )
                  ],
                )
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    print('build login =======>');
    return _createPage(context);
  }

  @override
  bool get wantKeepAlive => true;
}

class RegisterPage extends StatefulWidget {
  // 注册页面
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> with Components {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _createTextFieldSpan(String title) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 20 / 2),
      RichText(
          text: TextSpan(children: [
        const TextSpan(
            text: '* ', style: TextStyle(color: Colors.red, fontSize: 22 / 2)),
        TextSpan(
            text: title,
            style: const TextStyle(
                fontSize: 22 / 2, fontFamily: 'sfpro', color: Colors.black))
      ])),
      const SizedBox(height: 20 / 2),
      const SizedBox(
          height: 60 / 2,
          width: 630,
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(3)))),
          )),
    ]);
  }

  void onLogin(BuildContext context) {
    // print('login ok ');
    // Navigator.push(context, MaterialPageRoute(builder: (ctx)=> const UserInfoPage(isLogin: true,)));
  }

  Widget _createLoginRegion(BuildContext context) {
    return Column(children: [
      createButton(textLocation(context).btnTextLogin,
          hPadding: 40, width: double.infinity, onTap: () {
        onLogin(context);
      }),
      const SizedBox(
        height: 70,
      ),
      Center(
          child: Text(textLocation(context).textLogin,
              style: createTextStyle(
                  light: BZColor.grey,
                  dark: BZColor.darkGrey,
                  size: BZFontSize.title,
                  ctx: context))),
      const SizedBox(height: 20),
      ButtonBar(alignment: MainAxisAlignment.center, children: [
        Ink(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
          child: InkWell(
            borderRadius: BorderRadius.circular(25),
            onTap: () {},
            child: ClipOval(
                child: Image.asset(
              'assets/icons/instagram.png',
              height: 50,
              width: 50,
            )),
          ),
        ),
        Ink(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
          child: InkWell(
            borderRadius: BorderRadius.circular(25),
            onTap: () {},
            child: ClipOval(
                child: Image.asset(
              'assets/icons/pinterest.png',
              height: 50,
              width: 50,
            )),
          ),
        ),
        Ink(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
          child: InkWell(
            borderRadius: BorderRadius.circular(25),
            onTap: () {},
            child: ClipOval(
                child: Image.asset(
              'assets/icons/facebook.png',
              height: 50,
              width: 50,
            )),
          ),
        ),
      ]),
      const SizedBox(
        height: 30,
      ),
      RichText(
        text: const TextSpan(children: [
          TextSpan(
              text: 'Already registered?',
              style: TextStyle(color: Color(0xff5a5a5a), fontSize: 28 / 2)),
          TextSpan(
              text: ' Login',
              style: TextStyle(color: Colors.black, fontSize: 28 / 2))
        ]),
      )
    ]);
  }

  Widget _createPage(BuildContext context) {
    final textFieldNames = <String>[
      textLocation(context).inputTipsFirstName,
      textLocation(context).inputTipsLastName,
      textLocation(context).inputTipsEmailAddress,
      textLocation(context).titlePassword,
      textLocation(context).inputTipsConfirmPwd
    ];
    return SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(20),
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    for (String title in textFieldNames)
                      Column(
                        children: [
                          createInputField(title,
                              ctx: context,
                              width: double.infinity,
                              spacing: 10),
                          const SizedBox(
                            height: 5,
                          )
                        ],
                      ),
                    const SizedBox(height: 30),
                    _createLoginRegion(context)
                  ],
                ))));
  }

  @override
  Widget build(BuildContext context) {
    return _createPage(context);
  }
}
