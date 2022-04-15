import 'package:wigtoday_app/app/user/models/user_cache.dart';
import 'package:wigtoday_app/app/user/models/user_profile.dart';
import 'package:wigtoday_app/utils/http.dart';
import 'package:wigtoday_app/utils/storage.dart';

class AccountManager {
  // 最大缓存账号数量
  static int get maxAccounts => UserCacheModel.maxInstances;

  // 账号缓存key
  static String get cacheKey => UserCacheModel.cacheKey;

  // 获取当前缓存账号
  static Future<UserCacheModel?> getActiveUser() async {
    return await UserCacheModel.getActiveUser();
  }

  // 储存当前活动账号
  static Future<bool> saveActiveUser({bool updateKeepTime = false}) async {
    var active = await UserCacheModel.getActiveUser();
    if (active != null) {
      return await active.save(updateCreateTime: updateKeepTime);
    }
    return false;
  }

  // 储存账号
  static Future<bool> saveUser(
      {required UserCacheModel user, bool updateKeepTime = false}) async {
    return await user.save(updateCreateTime: updateKeepTime);
  }

  // 清空所有缓存账号
  static Future<bool> clearAllAccounts() async {
    return await Storage.remove(UserCacheModel.cacheKey);
  }

  // 获取所有缓存账号
  static Future<List<UserCacheModel>> getCacheUsers() async {
    return await UserCacheModel.getCacheUsers();
  }

  // 更新当前用户账号
  static Future<bool> updateActiveUser({required String newPwd}) async {
    var user = await getActiveUser();
    if (user != null) {
      String token = 'Beaer ${user.userProFileModle.token}';
      try {
        var resp = await HttpUtil.post('/user/profile',
            headers: {'Authorization': token});
        if (resp['code'] == 0) {
          var profileModel = UserProFileModle.fromResponse(resp);
          user.passwd = newPwd;
          user.userProFileModle = profileModel;
          return await user.save(updateCreateTime: true);
        }
      } catch (e) {
        user.passwd = newPwd;
        return await user.save(updateCreateTime: true);
      }
    }
    return false;
  }

  // 请求用户信息
  static Future<UserProFileModle?> fetchUserProfileModel(
      {required UserProFileModle currentProfileModel}) async {
    try {
      var userResp = await HttpUtil.post('/user/profile',
          headers: {'Authorization': "Beaer ${currentProfileModel.token}"});
      if (userResp['code'] == 0) {
        userResp['data']['token'] = currentProfileModel.token;
        var userProfileModel = UserProFileModle.fromResponse(userResp);
        return userProfileModel;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
