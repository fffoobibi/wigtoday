import 'dart:convert';

class LoginModel {
  final int id;
  final String avatar;
  final String account;
  final String authPhone;
  final int status;
  final String oauthEmail;
  final int isEmail;
  final String createOs;
  final String lastIp;
  final String score;
  final String token;

  @override
  String toString() {
    return jsonEncode({
      'id': id,
      'avatar': avatar,
      'account': account,
      'authPhone': authPhone,
      'status': status,
      'oauthEmail': oauthEmail,
      'isEmail': isEmail,
      'createOs': createOs,
      'lastIp': lastIp,
      'score': score,
      'token': token,
    });
  }

  const LoginModel(
      {required this.id,
      required this.avatar,
      required this.account,
      required this.authPhone,
      required this.status,
      required this.oauthEmail,
      required this.isEmail,
      required this.createOs,
      required this.lastIp,
      required this.score,
      required this.token});

  static LoginModel fromResponse(Map<String, dynamic> data) {
    Map info = data['info'];
    return LoginModel(
        id: info['id'],
        avatar: info['avatar'],
        account: info['account'],
        authPhone: info['auth_phone'],
        status: info['status'],
        oauthEmail: info['auth_email'],
        isEmail: info['is_email'],
        createOs: info['create_os'],
        lastIp: info['last_ip'],
        score: info['score'],
        token: data['token']);
  }
}
