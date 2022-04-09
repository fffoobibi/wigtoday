import 'package:wigtoday_app/app/user/models/user.dart';
import 'package:wigtoday_app/utils/formatter.dart';

class ReviewModel {
  final int id;
  final String content;
  final int score;
  final int likeCount;
  final bool isLiked;
  final UserModel author;
  final List<String> sizes;
  final List<String> imageUrls;
  final int createTime;

  ReviewModel({
    required this.id,
    required this.content,
    required this.author,
    required this.createTime,
    this.score = 0,
    this.likeCount = 0,
    this.isLiked = false,
    this.sizes = const [],
    this.imageUrls = const [],
  });

  get createTimeFmt => timePeriod(createTime);
}