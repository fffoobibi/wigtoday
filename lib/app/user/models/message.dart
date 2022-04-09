class MessageModel {
  final String userName;
  final String avtarUrl;
  final String message;
  final int time;
  final int count;

  MessageModel(
      {required this.userName,
      required this.avtarUrl,
      required this.message,
      required this.time,
      required this.count});

  static List<MessageModel> testMessages() {
    var url = 'https://p0.ssl.img.360kuai.com/t016e2f42c2f1145dc5.webp';
    var count = 4;
    return List.generate(
        5,
        (index) => MessageModel(
            userName: 'zhangsan',
            avtarUrl: url,
            message:
                'an identifcation user by a person with access to a computer, net worl mor online service',
            time: DateTime.now().millisecondsSinceEpoch,
            count: count));
  }
}
