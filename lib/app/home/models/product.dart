import 'package:wigtoday_app/utils/formatter.dart';

class ProductModel {
  final int id;
  final String title;
  final String imageUrl;
  final double realPrice;
  final double rawPrice;
  final String currency;
  final int score;
  final List tags;
  bool isLiked;
  final List<ProductSizeModel> sizes;

  ProductModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.realPrice,
    required this.rawPrice,
    this.currency = 'USD',
    this.score = 0,
    this.tags = const [],
    this.isLiked = false,
    this.sizes = const []
  });

  String get realPriceFmt => amountFormat(realPrice);
  String get rawPriceFmt => amountFormat(rawPrice);
}


class ProductSizeModel {
  final String title;
  final List<Map<String, dynamic>> options;
  
  ProductSizeModel({
    required this.title,
    required this.options,
  });

  // ProductSizeModel.fromJson(Map<String, dynamic> json) : title=json['title'], options=json['options'];
}