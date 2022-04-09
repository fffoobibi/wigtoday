class UserModel {
  final int userId;
  final String username;
  final String avatar;

  UserModel({
    required this.userId,
    required this.username,
    required this.avatar,
  });

  static getTestUserModel() {
    return UserModel(
        userId: 1,
        username: 'test',
        avatar: 'https://p0.ssl.img.360kuai.com/t016e2f42c2f1145dc5.webp');
  }
}
