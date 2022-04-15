import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wigtoday_app/app/user/models/use_country.dart';
import 'package:wigtoday_app/app/user/models/user_profile.dart';
import 'package:wigtoday_app/app/user/pages/about_us_page.dart';
import 'package:wigtoday_app/app/user/pages/address_list_page.dart';
import 'package:wigtoday_app/app/user/pages/security_page.dart';
import 'package:wigtoday_app/app/user/pages/user_profile_page.dart';
import 'package:wigtoday_app/utils/accounts.dart';
// import 'package:wigtoday_app/app/user/widgets/user_profile.dart';
import 'package:wigtoday_app/utils/color.dart';
import 'package:wigtoday_app/utils/event_bus.dart';
import 'package:wigtoday_app/utils/font.dart';
import 'package:wigtoday_app/utils/shared.dart';
import 'package:wigtoday_app/utils/theme.dart';
import 'package:wigtoday_app/widgets/components.dart';

// ignore: must_be_immutable
class SettingsPage extends StatefulWidget {
  bool isLogin;
  UserProFileModle? userProFileModle;
  List<UserCountryModel>? countrList;

  SettingsPage(
      {Key? key, required this.isLogin, required this.userProFileModle, required this.countrList})
      : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<SettingsPage> createState() =>
      _SettingsPageState(isLogin, userProFileModle, countrList);
}

class _SettingsPageState extends State<SettingsPage>
    with Components, AutomaticKeepAliveClientMixin {
  final double spacing = 10.0;
  final double padding = 12.0;

  UserProFileModle? _userProFileModle;
  List<UserCountryModel>? countrList;

  late bool isLogin;
  late StreamSubscription _stream;

  int? _currentAccount;

  _SettingsPageState(this.isLogin, this._userProFileModle, this.countrList);

  void createMenuItemOnPress(BuildContext context, int index) {
    if (isLogin) {
      switch (index) {
        case 0:
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (ctx) => UserProfile(
                      isLogin: isLogin, userProFileModle: _userProFileModle, countryList: countrList)));
          break;

        case 2:
          Navigator.push(context,
              MaterialPageRoute(builder: (ctx) => const AddressListPage()));
          break;

        case 5: // account security
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (ctx) => SecurityPage(
                        userProFileModle: _userProFileModle!,
                      )));
          break;

        case 9:
          Navigator.push(
              context, MaterialPageRoute(builder: (ctx) => AboutUsPage()));
          break;

        default:
          return;
      }
    } else {
      showToast(msg: '请登录', ctx: context);
    }
  }

  void wigTodayEventSlot(WigTodayEvent event) {
    setState(() {
      isLogin = event.isLogin;
      _userProFileModle = event.profileModel;
    });
  }

  Future<void> showSwitchAccount() async {
    var users = await AccountManager.getCacheUsers();
    var currentUser = await AccountManager.getActiveUser();
    _currentAccount =
        _userProFileModle != null ? users.indexOf(currentUser!) : null;

    showDialog(
        context: context,
        builder: (ctx) {
          return StatefulBuilder(builder: (c, setState) {
            return SimpleDialog(
                children: List.generate(
                    users.length,
                    (index) => SimpleDialogOption(
                          child: RadioListTile(
                              onChanged: (int? value) {
                                print('select =====> $index');
                                setState(() {
                                  _currentAccount = value!;
                                  eventBus.fire(WigTodayEvent(
                                    true,
                                    WigtodayEventType.switchUser,
                                    users[value],
                                    users[value].userProFileModle,
                                  ));
                                  Navigator.pop(c);
                                });
                              },
                              groupValue: _currentAccount,
                              value: index,
                              title: Text(
                                users[index].account,
                                style: createTextStyle(
                                    size: BZFontSize.title, ctx: c),
                              )),
                        )));
          });
        });
  }

  void logoutOut() {
    eventBus.fire(WigTodayEvent(false, WigtodayEventType.logut));
    Navigator.pop(context);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _stream = eventBus.on<WigTodayEvent>().listen((event) {
      if (event.type == WigtodayEventType.login || event.type ==WigtodayEventType.switchUser||event.type == WigtodayEventType.modify) {
        wigTodayEventSlot(event);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _stream.cancel();
  }

  Widget createMenuItem({
    required String title,
    VoidCallback? onTap,
    required String assetleading,
    double size = 25,
  }) {
    return Container(
        height: 40,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: InkWell(
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                assetleading,
                height: size,
                width: size,
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                child: Text(
                  title,
                  style: createTextStyle(
                      size: 14, color: Colors.black, ctx: context),
                ),
              ),
              const Icon(Icons.keyboard_arrow_right)
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    print('sharedata in settings ===> ${SharedWidget.of(context).userName}');

    final List<List<String>> settingItems = [
      [textLocation(context).settingsProfile, 'assets/icons/MyProfile.png'],
      [
        textLocation(context).settingsEditPwd,
        'assets/icons/password_security.png'
      ],
      [textLocation(context).settingsAddress, 'assets/icons/address.png'],
      [textLocation(context).settingsLanguage, 'assets/icons/language.png'],
      [
        textLocation(context).settingsPartner,
        'assets/icons/PartnerProgram.png'
      ],
      [
        textLocation(context).settingsAccountSecurity,
        'assets/icons/question_security.png'
      ],
      [
        textLocation(context).settingsNotification,
        'assets/icons/Notification.png'
      ],
      [textLocation(context).settingsDarkMode, 'assets/icons/darkmode.png'],
      [textLocation(context).settingsClearCache, 'assets/icons/clearcache.png'],
      [textLocation(context).settingsAboutUs, 'assets/icons/aboutus.png'],
    ];
    return Scaffold(
      backgroundColor: BZTheme.isDark(context) ? null : const Color(0xffECECEC),
      appBar: createAppBar(
          child: Row(
            children: [BackButton(onPressed: () => Navigator.pop(context))],
          ),
          backgroundAssetName:
              BZTheme.isDark(context) ? null : 'assets/images/security.png',
          height: 60),
      body: Column(
        children: [
          Container(
            color: BZTheme.isDark(context)
                ? BZColor.darkBackground
                : const Color(0xffECECEC),
            padding: EdgeInsets.symmetric(horizontal: padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(height: spacing),
                Text(textLocation(context).settingsTitle,
                    style: createTextStyle(
                        weight: FontWeight.bold,
                        size: BZFontSize.max,
                        ctx: context)),
                SizedBox(height: spacing * 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ClipOval(
                        child: Container(
                            height: 80,
                            width: 80,
                            color: isDark(context)
                                ? BZColor.darkCard
                                : BZColor.card,
                            child: isLogin
                                ? getAvatar(
                                    model: _userProFileModle!,
                                    context: context,
                                    height: 60,
                                    width: 60)
                                : Icon(
                                    Icons.person_rounded,
                                    size: 60,
                                    color: isDark(context)
                                        ? null
                                        : const Color(0xffECECEC),
                                  ))),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                  isLogin
                                      ? _userProFileModle!.authEmail
                                      : textLocation(context).titleRegister +
                                          ' / ' +
                                          textLocation(context)
                                              .titleSign, //'Diefered@google.com',
                                  style: createTextStyle(
                                      weight: FontWeight.bold,
                                      size: BZFontSize.big,
                                      ctx: context)),
                              const SizedBox(width: 2),
                              Icon(
                                isLogin
                                    ? (_userProFileModle!.isMan
                                        ? Icons.male_outlined
                                        : Icons.female_outlined)
                                    : Icons.person_off_sharp,
                                color: const Color(0xffFC4867),
                              )
                            ]),
                        SizedBox(height: spacing),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(Icons.email_outlined),
                            Text(
                              textLocation(context).settingsEmail,
                              style: createTextStyle(
                                  size: 12,
                                  color: const Color(0xff5A5A5A),
                                  ctx: context,
                                  light: BZColor.semi,
                                  dark: BZColor.darkSemi),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
          Expanded(
              child: Container(
            // height: BZSize.pageHeight - 60 - 100,
            padding: const EdgeInsets.symmetric(horizontal: 0),
            decoration: BoxDecoration(
                // color: Colors.white,
                color: isDark(context) ? BZColor.darkCard : BZColor.card,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10))),
            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    decoration: BoxDecoration(
                        color: BZTheme.isDark(context)
                            ? BZColor.darkCard
                            : BZColor.card,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    child: Column(
                      children: [
                        ...List.generate(settingItems.length, (index) {
                          return Column(children: [
                            createMenuItem(
                                title: settingItems[index][0],
                                assetleading: settingItems[index][1],
                                onTap: () {
                                  createMenuItemOnPress(context, index);
                                }),
                            // const Divider(),
                            const Divider(height: 0),
                            // Divider(color:BZTheme.isDark(context) ? BZColor.darkDivider : BZColor.divider) //Color(0xffEAEAEA))
                          ]);
                        }),
                        const SizedBox(
                          height: 10,
                        ),
                        createNormalButton(textLocation(context).settingsSwitch,
                            onPress: () {
                          showSwitchAccount();
                        },
                            vPadding: 15,
                            background: Color(0xffECECEC),
                            ctx: context,
                            textStyle: createTextStyle(size: 16, ctx: context)),
                        createNormalButton(textLocation(context).settingsLogout,
                            onPress: logoutOut,
                            background: Colors.transparent,
                            textStyle: createTextStyle(size: 16, ctx: context)),
                      ],
                    )),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
