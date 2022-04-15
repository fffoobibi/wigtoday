import 'package:event_bus/event_bus.dart';
import 'package:wigtoday_app/app/user/models/user_cache.dart';
import 'package:wigtoday_app/app/user/models/user_profile.dart';

EventBus eventBus = EventBus();

enum WigtodayEventType {
  login,
  logut,
  switchUser,
  modify,
}

class WigTodayEvent {
  bool isLogin;
  WigtodayEventType type;
  UserCacheModel? cacheModel;
  UserProFileModle? profileModel;

  WigTodayEvent(this.isLogin, this.type, [this.cacheModel, this.profileModel]);
}

