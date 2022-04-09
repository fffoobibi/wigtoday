import 'dart:math';

import 'package:wigtoday_app/app/home/models/product.dart';


class CartItemModel {
  final ProductModel product;
  late int maxQuantity;
  late int minQuantity;
  late int initQuantity;
  late int _quantity;

  CartItemModel({
    required this.product,
    int minQuantity = 1,
    int maxQuantity = 9999,
    int initQuantity = 1,
  }) {
    // 处理非正整数情况
    minQuantity = max(minQuantity, 1);
    maxQuantity = max(maxQuantity, 1);

    // 处理极值颠倒情况
    this.minQuantity = min(minQuantity, maxQuantity);
    this.maxQuantity = max(minQuantity, maxQuantity);

    // 处理初始值越界情况
    if (initQuantity < minQuantity) {
      this.initQuantity = minQuantity;
    } else if (initQuantity > maxQuantity) {
      this.initQuantity = maxQuantity;
    } {
      this.initQuantity = initQuantity;
    }

    _quantity = this.initQuantity;
  }

  int get quantity => _quantity;

  void add() {
    if (_quantity < maxQuantity) _quantity ++;
  }

  void reduce() {
    if (_quantity > minQuantity) _quantity --;
  }
}