import 'dart:convert';

import 'package:wigtoday_app/app/user/models/user_profile.dart';
import 'package:wigtoday_app/utils/storage.dart';

class UserCacheModel {
  static const maxInstances = 3; // 最多记住账号
  static const maxKeepTime = 24 * 60 * 60 * 14; // 记住时间
  static const cacheKey = 'wigtodayCacheUsers';

  int userId;
  String account;
  String passwd;
  bool isActive;
  UserProFileModle userProFileModle;
  int cacheTime;

  UserCacheModel(
      {required this.userId,
      required this.account,
      required this.passwd,
      required this.isActive,
      required this.userProFileModle,
      required this.cacheTime});

  bool get canKeep =>
      DateTime.now().millisecondsSinceEpoch - cacheTime * 1000 <
      maxKeepTime * 1000;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is UserCacheModel) {
      return userId == other.userId;
    } else {
      return false;
    }
  }

  @override
  int get hashCode {
    return userId.hashCode;
  }

  @override
  String toString() {
    return toJson();
  }

  String toJson() {
    return jsonEncode({
      'account': account,
      'passwd': passwd,
      'isActive': isActive,
      'userId': userId,
      'userProFileModle': userProFileModle.toJson(),
      'cacheTime': cacheTime
    });
  }

  Future<bool> save({bool updateCreateTime = false}) async {
    var users = await getCacheUsers();
    users = users.map((e) {
      e.isActive = false;
      return e;
    }).toList();

    if (users.contains(this)) {
      var index = users.indexOf(this);
      users[index].isActive = true;
      users[index].passwd = passwd;
      users[index].userProFileModle = userProFileModle;
      if (updateCreateTime) {
        users[index].cacheTime = cacheTime;
      }
    } else {
      users.insert(0, this);
    }

    users = users.take(maxInstances).toList();

    var flag = await Storage.setData<List<String>>(
        cacheKey, users.map((e) => e.toJson()).toList());
    return flag;
  }

  static UserCacheModel fromJson(String jsonData) {
    var data = jsonDecode(jsonData) as Map<String, dynamic>;
    return UserCacheModel(
        userId: data['userId'],
        account: data['account']!,
        passwd: data['passwd']!,
        isActive: data['isActive']!,
        userProFileModle: UserProFileModle.fromJson(data['userProFileModle']!),
        cacheTime: data['cacheTime']);
  }

  static Future<List<UserCacheModel>> getCacheUsers() async {
    List<String>? caches = await Storage.getData<List<String>>(cacheKey);
    if (caches != null) {
      return List.generate(caches.length, (index) => fromJson(caches[index]));
    }
    return [];
  }

  static Future<UserCacheModel?> getActiveUser() async {
    var users = await getCacheUsers();
    if (users.isNotEmpty) {
      return users.firstWhere((element) => element.isActive == true);
    }
    return null;
  }
}
