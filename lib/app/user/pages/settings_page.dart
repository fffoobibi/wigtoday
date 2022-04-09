import 'package:flutter/material.dart';
import 'package:wigtoday_app/app/user/pages/address_list_page.dart';
import 'package:wigtoday_app/app/user/pages/security_page.dart';
import 'package:wigtoday_app/app/user/widgets/about_us.dart';
import 'package:wigtoday_app/app/user/widgets/user_profile.dart';
import 'package:wigtoday_app/utils/color.dart';
import 'package:wigtoday_app/utils/theme.dart';
import 'package:wigtoday_app/widgets/components.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with Components {
  final double spacing = 10.0;
  final double padding = 12.0;


  VoidCallback? createMenuItemOnPress(BuildContext context, int index) {
    switch (index) {
      case 0:
        return () => Navigator.push(
            context, MaterialPageRoute(builder: (ctx) => UserProfile()));
      case 2:
        return () => Navigator.push(context,
            MaterialPageRoute(builder: (ctx) => const AddressListPage()));
      case 5: // account security
        return () => Navigator.push(
            context, MaterialPageRoute(builder: (ctx) => SecurityPage()));
      case 9:
        return () => Navigator.push(
            context, MaterialPageRoute(builder: (ctx) => AboutUsPage()));
      default:
        return null;
    }
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
                  style: createTextStyle(size: 14, color: Colors.black, ctx: context),
                ),
              ),
              const Icon(Icons.keyboard_arrow_right)
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    var url = 'https://p0.ssl.img.360kuai.com/t016e2f42c2f1145dc5.webp';
    final List<List<String>> settingItems = [
      [AppLocalizations.of(context)!.settingsProfile, 'assets/icons/MyProfile.png'],
      [AppLocalizations.of(context)!.settingsEditPwd, 'assets/icons/password_security.png'],
      [AppLocalizations.of(context)!.settingsAddress, 'assets/icons/address.png'],
      [AppLocalizations.of(context)!.settingsLanguage,'assets/icons/language.png'],
      [AppLocalizations.of(context)!.settingsPartner, 'assets/icons/PartnerProgram.png'],
      [AppLocalizations.of(context)!.settingsAccountSecurity, 'assets/icons/question_security.png'],
      [AppLocalizations.of(context)!.settingsNotification, 'assets/icons/Notification.png'],
      [AppLocalizations.of(context)!.settingsDarkMode, 'assets/icons/darkmode.png'],
      [AppLocalizations.of(context)!.settingsClearCache, 'assets/icons/clearcache.png'],
      [AppLocalizations.of(context)!.settingsAboutUs, 'assets/icons/aboutus.png'],
      ];
    return Scaffold(
      backgroundColor: BZTheme.isDark(context)? null: const Color(0xffECECEC),
      appBar: createAppBar(
          child: Container(
            child: Row(
              children: [BackButton(onPressed: () => Navigator.pop(context))],
            ),
          ),
          backgroundAssetName: BZTheme.isDark(context)? null: 'assets/images/security.png',
          height: 60),
      body: Column(
        children: [
          Container(
            color: BZTheme.isDark(context) ? BZColor.darkBackground :const Color(0xffECECEC),
            padding: EdgeInsets.symmetric(horizontal: padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(height: spacing),
                Text(AppLocalizations.of(context)!.settingsTitle,
                    style: createTextStyle(weight: FontWeight.bold, size: 30, ctx: context)),
                SizedBox(height: spacing * 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ClipOval(
                        child: Image.network(
                      url,
                      height: 80,
                      width: 80,
                    )),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Diefered@google.com',
                                  style: createTextStyle(
                                      weight: FontWeight.bold, size: 20, ctx: context)),
                              const SizedBox(width: 2),
                              const Icon(
                                Icons.female_outlined,
                                color: Color(0xffFC4867),
                              )
                            ]),
                        SizedBox(height: spacing),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(Icons.email_outlined),
                            Text(
                              AppLocalizations.of(context)!.settingsEmail,
                              style: createTextStyle(
                                  size: 12, color: const Color(0xff5A5A5A), ctx: context, light: BZColor.semi, dark: BZColor.darkSemi),
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
            padding: EdgeInsets.symmetric(horizontal: 0),
            decoration: BoxDecoration(
                // color: Colors.white,
                color: BZTheme.isDark(context) ? BZColor.darkCard: BZColor.card,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10))),
            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    decoration: BoxDecoration(
                        color: BZTheme.isDark(context) ? BZColor.darkCard: BZColor.card,
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
                                onTap: createMenuItemOnPress(context, index)),
                              // const Divider(),
                            const Divider(height: 0),
                            // Divider(color:BZTheme.isDark(context) ? BZColor.darkDivider : BZColor.divider) //Color(0xffEAEAEA))
                          ]);
                        }),
                        const SizedBox(
                          height: 10,
                        ),
                        createNormalButton(AppLocalizations.of(context)!.settingsSwitch,
                            vPadding: 15,
                            background: Color(0xffECECEC),
                            ctx: context,
                            textStyle: createTextStyle(size: 16, ctx: context)),
                        createNormalButton(AppLocalizations.of(context)!.settingsLogout,
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
