import 'package:flutter/material.dart';
import 'package:wigtoday_app/utils/color.dart';
import 'package:wigtoday_app/utils/font.dart';


class BZTheme {
  // 亮色主题
  static final ThemeData light = ThemeData(
    primaryColor: BZColor.primary,
    shadowColor: BZColor.shadow,
    disabledColor: BZColor.light,
    cardColor: BZColor.card,
    dividerColor: BZColor.divider,
    brightness: Brightness.light,
    scaffoldBackgroundColor: BZColor.background,
    dialogBackgroundColor: BZColor.card,
    indicatorColor: BZColor.primary,
    hintColor: BZColor.grey,
    appBarTheme: const AppBarTheme(
      backgroundColor: BZColor.nav,
      foregroundColor: BZColor.title,
      elevation: 0.5,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: BZFontSize.navTitle,
        color: BZColor.title,
      ),
      actionsIconTheme: IconThemeData(
        color: BZColor.title,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: BZColor.tab,
      selectedItemColor: BZColor.primary,
      unselectedItemColor: BZColor.tabText,
    ),
    cardTheme: const CardTheme(
      color: BZColor.card,
      shadowColor: BZColor.nav,
      elevation: 1,
      margin: EdgeInsets.fromLTRB(10, 16, 10, 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
    ),
    textTheme: const TextTheme(
      headline1: TextStyle(
        fontSize: BZFontSize.max,
        fontWeight: FontWeight.bold,
      ),
      headline2: TextStyle(
        fontSize: BZFontSize.big,
      ),
      subtitle1: TextStyle(
        fontSize: BZFontSize.navTitle,
        color: BZColor.title,
      ),
      subtitle2: TextStyle(
        fontSize: BZFontSize.title,
        color: BZColor.semi
      ),
      bodyText1: TextStyle(
        fontSize: BZFontSize.content,
        color: BZColor.grey
      ),
      bodyText2: TextStyle(
        fontSize: BZFontSize.min,
        color: BZColor.light
      ),
    ),
    chipTheme: const ChipThemeData(
      backgroundColor: Color(0xfff2f2f2),
      disabledColor: BZColor.grey,
      selectedColor: Color(0xfffff0f0),
      secondarySelectedColor: Colors.white,//BZColor.semi,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      labelStyle: TextStyle(
        fontSize: BZFontSize.content,
        color: Colors.white,
      ),
      secondaryLabelStyle: TextStyle(
        fontSize: BZFontSize.content,
        color: BZColor.title,
      ),
      brightness: Brightness.light,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: Colors.white,
      backgroundColor: BZColor.primary,
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: BZColor.card,
      elevation: 1,
      titleTextStyle: TextStyle(
        fontSize: BZFontSize.title,
        color: BZColor.title,
      ),
      contentTextStyle: TextStyle(
        fontSize: BZFontSize.content,
        color: BZColor.semi,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: BZColor.divider,
      thickness: 1,
      space: 0,
    ),
    listTileTheme: const ListTileThemeData(
      dense: true,
      textColor: BZColor.title,
      horizontalTitleGap: 8,
      minLeadingWidth: 30,
    ),
    tabBarTheme: const TabBarTheme(
      indicatorSize: TabBarIndicatorSize.label,
      labelColor: BZColor.primary,
      labelStyle: TextStyle(fontSize: BZFontSize.title),
      labelPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 5,),
      unselectedLabelColor: BZColor.grey,
      unselectedLabelStyle: TextStyle(fontSize: BZFontSize.title),
    ),
    sliderTheme: const SliderThemeData(
      trackHeight: 3,
      activeTrackColor: BZColor.primary,
      inactiveTrackColor: BZColor.light,
      thumbColor: BZColor.card,
      valueIndicatorColor: BZColor.semi,
      rangeValueIndicatorShape: RectangularRangeSliderValueIndicatorShape(),
    ),
  );


  // 暗色主题
  static final ThemeData dark = ThemeData(
    primaryColor: BZColor.darkPrimary,
    shadowColor: BZColor.darkShadow,
    disabledColor: BZColor.darkLight,
    cardColor: BZColor.darkCard,
    dividerColor: BZColor.darkDivider,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: BZColor.darkBackground,
    dialogBackgroundColor: BZColor.darkCard,
    indicatorColor: BZColor.darkPrimary,
    hintColor: BZColor.darkGrey,
    appBarTheme: const AppBarTheme(
      backgroundColor: BZColor.darkNav,
      foregroundColor: BZColor.darkTitle,
      elevation: 0.5,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: BZFontSize.navTitle,
        color: BZColor.darkTitle,
      ),
      actionsIconTheme: IconThemeData(
        color: BZColor.darkTitle,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: BZColor.darkTab,
      selectedItemColor: BZColor.darkPrimary,
      unselectedItemColor: BZColor.darkTabText,
    ),
    cardTheme: const CardTheme(
      color: BZColor.darkCard,
      shadowColor: BZColor.darkNav,
      elevation: 4,
      margin: EdgeInsets.fromLTRB(10, 16, 10, 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
    ),
    textTheme: const TextTheme(
      headline1: TextStyle(
        fontSize: BZFontSize.max,
        fontWeight: FontWeight.bold,
      ),
      headline2: TextStyle(
        fontSize: BZFontSize.big,
      ),
      subtitle1: TextStyle(
        fontSize: BZFontSize.navTitle,
        color: BZColor.darkTitle,
      ),
      subtitle2: TextStyle(
        fontSize: BZFontSize.title,
        color: BZColor.darkSemi,
      ),
      bodyText1: TextStyle(
        fontSize: BZFontSize.content,
        color: BZColor.darkGrey,
      ),
      bodyText2: TextStyle(
        fontSize: BZFontSize.min,
        color: BZColor.darkLight,
      ),
    ),
    chipTheme: const ChipThemeData(
      backgroundColor: Color(0xff282828),
      disabledColor: BZColor.darkGrey,
      selectedColor: Color(0xff101010),
      checkmarkColor: Colors.white,
      secondarySelectedColor: BZColor.darkSemi,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      labelStyle: TextStyle(
        fontSize: BZFontSize.content,
        color: Colors.white,
      ),
      secondaryLabelStyle: TextStyle(
        fontSize: BZFontSize.content,
        color: BZColor.darkTitle,
      ),
      brightness: Brightness.dark,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: Colors.white,
      backgroundColor: BZColor.darkPrimary,
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: BZColor.darkCard,
      elevation: 1,
      titleTextStyle: TextStyle(
        fontSize: BZFontSize.title,
        color: BZColor.darkTitle,
      ),
      contentTextStyle: TextStyle(
        fontSize: BZFontSize.content,
        color: BZColor.darkSemi,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: BZColor.darkDivider,
      thickness: 1,
    ),
    listTileTheme: const ListTileThemeData(
      dense: true,
      textColor: BZColor.darkTitle,
      horizontalTitleGap: 8,
      minLeadingWidth: 30,
    ),
    tabBarTheme: const TabBarTheme(
      indicatorSize: TabBarIndicatorSize.label,
      labelColor: BZColor.darkPrimary,
      labelStyle: TextStyle(fontSize: BZFontSize.title),
      labelPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 8,),
      unselectedLabelColor: BZColor.darkGrey,
      unselectedLabelStyle: TextStyle(fontSize: BZFontSize.title),
    ),
    sliderTheme: const SliderThemeData(
      trackHeight: 3,
      activeTrackColor: BZColor.darkPrimary,
      inactiveTrackColor: BZColor.darkLight,
      thumbColor: BZColor.darkGrey,
      valueIndicatorColor: BZColor.darkLight,
      rangeValueIndicatorShape: RectangularRangeSliderValueIndicatorShape(),
    ),
  );


  // 判断当前主题模式是否为暗色主题
  static isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
}