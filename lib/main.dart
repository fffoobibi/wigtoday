import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:wigtoday_app/utils/theme.dart';
import 'package:wigtoday_app/app/tabbar/tabbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  //TODO: Firebase config
  // await Firebase.initializeApp();

  runApp(const MyApp());

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color(0x00000000),
      systemNavigationBarColor: Color(0x00000000),
    )
  );
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [SystemUiOverlay.top],
  );
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wigtoday',
      debugShowCheckedModeBanner: false,
      theme: BZTheme.light,
      darkTheme: BZTheme.dark,
      home: const BZTabBar(),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      builder: (context, widget) {
        // 设置文字大小不随系统设置改变
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: widget!,
        );
      },
    );
  }
}
