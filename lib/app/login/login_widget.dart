import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wigtoday_app/app/login/models/login.dart';
import 'package:wigtoday_app/app/user/models/user_cache.dart';
import 'package:wigtoday_app/app/user/models/user_profile.dart';
import 'package:wigtoday_app/app/user/pages/forget_pwd_page.dart';
import 'package:wigtoday_app/utils/color.dart';
import 'package:wigtoday_app/utils/font.dart';
import 'package:wigtoday_app/utils/event_bus.dart';
import 'package:wigtoday_app/utils/storage.dart';
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

  double padding = 20.0;
  late LoginModel _loginModel;

  final _formKey = GlobalKey<FormState>();

  final accountControl = TextEditingController();
  final passwdControl = TextEditingController();

  void loadLatestedUser() async {
    var user = await UserCacheModel.getActiveUser();
    if (user != null) {
      accountControl.text = user.account;
      passwdControl.text = user.passwd;
    }
  }

  Future<bool> login() async {
    if (_formKey.currentState!.validate()) {
      String _account = accountControl.text;
      String _password = passwdControl.text;

      Map<String, dynamic> postData = {
        'account': _account,
        'password': _password
      };
      if (_account.isEmpty) {
        showToast(msg: 'Please Input Account!', ctx: context);
        return false;
      }
      if (_password.isEmpty) {
        showToast(msg: 'Please Input Password!', ctx: context);
        return false;
      }
      var resp = await post('/passport/login', data: postData);

      if (resp['code'] == 0) {
        _loginModel = LoginModel.fromResponse(resp['data']);
        var userResp = await post('/user/profile',
            headers: {'Authorization': "Beaer ${_loginModel.token}"});
        userResp['data']['token'] = _loginModel.token;
        var userProfileModel = UserProFileModle.fromResponse(userResp);
        // print('login success ===> ${userProfileModel.avatar}');

        // 缓存账号
        UserCacheModel cacheModel = UserCacheModel(
            userProFileModle: userProfileModel,
            userId: _loginModel.id,
            account: _account,
            passwd: _password,
            isActive: true,
            cacheTime: DateTime.now().millisecondsSinceEpoch);
        cacheModel.save(updateCreateTime: true);

        // 跳转并更新用户页面
        Navigator.pop(context);
        
        eventBus.fire(WigTodayEvent(
            true, WigtodayEventType.login, null, userProfileModel));
        return true;
      } else {
        showToast(msg: resp['msg'], ctx: context);
        return false;
      }
    }
    return false;
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
                    controller: accountControl,
                    hintText: textLocation(context).hintEmail,
                    hintStyle: const TextStyle(fontSize: BZFontSize.subTitle),
                    width: double.infinity,
                    ctx: context,
                    restWidget: InkWell(
                        splashColor: Colors.transparent,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => ForgetPwdPage(
                                      account: accountControl.text)));
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
                    controller: passwdControl,
                    hintText: textLocation(context).hintTypePwd,
                    hintStyle: const TextStyle(fontSize: BZFontSize.subTitle),
                    //   setter: (val) {
                    // _password = val;},
                    width: double.infinity,
                    ctx: context),
                const SizedBox(height: 20),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: textLocation(context)
                          .textIncorrect, //'Incorrect email or password.',
                      style: const TextStyle(color: Colors.red))
                ])),
                const SizedBox(height: 30),

                // createButton(textLocation(context).btnTextSign,
                //     hPadding: 40, width: double.infinity, onTap: login),

                createLoadingButton(textLocation(context).btnTextSign,
                    onTap: login, width: double.infinity, hPadding: 40),

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
    loadLatestedUser();
    // Storage.clear();
    UserCacheModel.getCacheUsers().then(((value) {
      print('users =======>: $value');
    }));
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

class _RegisterPageState extends State<RegisterPage>
    with Components, AutomaticKeepAliveClientMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _inputs = List<String?>.generate(5, (index) => '');
  final _controllers = List.generate(5, (index) => TextEditingController());

  List<Map<String, dynamic>> _createConditions() {
    return [
      {'obscureText': false, 'hintText': textLocation(context).hintFirstName},
      {'obscureText': false, 'hintText': textLocation(context).hintLastName},
      {'obscureText': false, 'hintText': textLocation(context).hintEmail},
      {'obscureText': true, 'hintText': textLocation(context).hintPwd},
      {'obscureText': true, 'hintText': textLocation(context).hintConfirmPwd}
    ];
  }

  @override
  bool get wantKeepAlive => true;

  Future<bool> register() async {
    bool checkFail =
        _inputs.any((element) => element == null || element.isEmpty);
    if (checkFail) {
      Fluttertoast.showToast(msg: '请输入全部数据!', gravity: ToastGravity.TOP);
      return false;
    }
    if (_inputs[3]!.length < 6 || _inputs[3]!.length > 16) {
      Fluttertoast.showToast(msg: '密码长度6到16位', gravity: ToastGravity.TOP);
      return false;
    }
    if (_inputs[3] != _inputs[4]) {
      Fluttertoast.showToast(msg: '确认密码与输入密码不一致!', gravity: ToastGravity.TOP);
      return false;
    }
    var postData = {
      'first_name': _inputs[0],
      'last_name': _inputs[1],
      'account': _inputs[2],
      'password': _inputs[3],
      'register_type': 0,
      'is_subion': 1,
    };
    // print('post::  $postData');
    var resp = await post('/passport/register', data: postData);
    if (resp['code'] != 0) {
      showToast(msg: resp['msg'], ctx: context);
      return false;
    } else {
      String token = resp['data']['token'];
      var headers = {'Authorization': "Beaer $token"};
      var userResp = await post('/user/profile', headers: headers);
      userResp['data']['token'] = token;
      var userProfileModel = UserProFileModle.fromResponse(userResp);
      var cacheModel =
          userProfileModel.getUserCacheModel(pwd: _inputs[3]!, isActive: true);

      // 保存至本地
      cacheModel.save().then((value) {
        Navigator.pop(context);
        eventBus.fire(WigTodayEvent(
            true, WigtodayEventType.login, null, userProfileModel));
      });
      return true;
    }
  }

  Widget _createLoginRegion(BuildContext context) {
    return Column(children: [
      // createButton(textLocation(context).btnTextRegister,
      //     hPadding: 40, width: double.infinity, onTap: () {
      //   register(context);
      // }),
      createLoadingButton(textLocation(context).btnTextRegister,
          onTap: register, width: double.infinity, hPadding: 40),
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
    final _conditions = _createConditions();
    return SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(20),
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    ...List.generate(
                        _controllers.length,
                        (index) => Column(
                              children: [
                                createInputField(textFieldNames[index],
                                    hintStyle: const TextStyle(
                                        fontSize: BZFontSize.subTitle),
                                    hintText: _conditions[index]['hintText'],
                                    obscureText: _conditions[index]
                                        ['obscureText'],
                                    controller: _controllers[index],
                                    ctx: context,
                                    width: double.infinity,
                                    spacing: 10, setter: (val) {
                                  _inputs[index] = val;
                                }),
                                const SizedBox(
                                  height: 5,
                                )
                              ],
                            )),
                    const SizedBox(height: 30),
                    _createLoginRegion(context)
                  ],
                ))));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _createPage(context);
  }
}
