
import 'package:flutter/material.dart';

class UserCenterModel with ChangeNotifier {
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? messenger;
  String? address;
  int? gender;
  int? country;
  int? birthDate;

  UserCenterModel(
      {this.firstName,
      this.lastName,
      this.phoneNumber,
      this.gender,
      this.country,
      this.birthDate,
      this.messenger,
      this.address});

  bool validate() {
    return true;
  }

  static UserCenterModel testModel() {
    return UserCenterModel(
      firstName: 'Kyrie',
      lastName: 'irving',
      phoneNumber: '12344545454',
      address: 'test place',
      gender: 0,
      country: 0,
      messenger: 'messagerrrr',
      birthDate: DateTime.now().millisecondsSinceEpoch,
    );
  }

  void update(UserCenterModel other) {
    firstName = other.firstName;
    lastName = other.lastName;
    phoneNumber = other.phoneNumber;
    gender = other.gender;
    country = other.country;
    birthDate = other.birthDate;
    messenger = other.messenger;
    address = other.address;
    notifyListeners();
  }
}
