import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:wigtoday_app/app/user/models/user_cache.dart';
import 'package:wigtoday_app/utils/accounts.dart';
import 'package:wigtoday_app/utils/shared.dart';

import 'package:wigtoday_app/utils/theme.dart';
import 'package:wigtoday_app/app/tabbar/tabbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 加载缓存账号
  var activeUser = await AccountManager.getActiveUser();
  runApp(MyApp(cacheModel: activeUser));

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Color(0x00000000),
    systemNavigationBarColor: Color(0x00000000),
  ));
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [SystemUiOverlay.top],
  );
}

class MyApp extends StatelessWidget {
  UserCacheModel? cacheModel;

  MyApp({Key? key, required this.cacheModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SharedWidget(
        shareData: ShareData(userName: 'ggggg'),
        child: MaterialApp(
          title: 'Wigtoday',
          debugShowCheckedModeBanner: false,
          theme: BZTheme.light,
          darkTheme: BZTheme.dark,
          home: BZTabBar(cacheModel: cacheModel),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          builder: (context, widget) {
            // 设置文字大小不随系统设置改变
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: FlutterEasyLoading(
                child: widget!,
              ),
            );
          },
        ));
  }
}
