import 'package:flutter/cupertino.dart';

class UserCountryModel {
  int code; // 244,
  String tw; // "安哥拉",
  String en; // "Angola",
  String locale; // "AO",
  String zh; // "安哥拉"

  UserCountryModel(
      {required this.code,
      required this.tw,
      required this.en,
      required this.locale,
      required this.zh});

  String currentLocalText(BuildContext context) {
    var local = Localizations.localeOf(context);
    if (local.languageCode.toLowerCase() == 'zh') {
      if (local.countryCode == 'TW') {
        return tw;
      } else if (local.countryCode == 'HK') {
        return tw;
      }
      return zh;
    }
    return en;
  }

  static List<UserCountryModel> fromResponse(Map<String, dynamic> response) {
    var data = response['data'] as List<dynamic>;
    List<UserCountryModel> result = [];
    for (Map<String, dynamic> d in data) {
      result.add(UserCountryModel(
          code: d['code'] ?? -1, // 244,
          tw: d['tw'] ?? "", // "安哥拉",
          en: d['en'] ?? "", // "Angola",
          locale: d['locale'] ?? "", // "AO",
          zh: d['zh'] ?? "" // "安哥拉"
          ));
    }
    return result;
  }
}
