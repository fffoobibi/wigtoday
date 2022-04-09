import 'package:wigtoday_app/app/user/models/user.dart';

class AddressModel {
  final int id;
  final String contact;
  final String phone;
  final String? country;
  final String? stateOrProvince;
  final String? city;
  final String? email;
  final String? zip;
  final String address;

  AddressModel({
    required this.id,
    required this.contact,
    required this.phone,
    this.country,
    this.stateOrProvince,
    this.city,
    this.email,
    this.zip,
    required this.address,
  });
}