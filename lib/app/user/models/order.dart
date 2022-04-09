import 'package:wigtoday_app/app/home/models/product.dart';

enum OrderState {
  unpaid,       // 未付款
  suspending,   // 中止
  paid,         // 已付款
  processing,   // 处理中
  completed,    // 已完成
  chargeback,   // 退款申请
  refunded,     // 已退款
  refundless,   // 取消退款
  returned,     // 已退货
  returnless,   // 取消退货
  refund,       // 退款
}


class OrderModel {
  final ProductModel product;
  final int createTime;
  final OrderState state;
  final int quantity;
  final double totalAmount;
  final String currency;

  OrderModel({
    required this.product,
    required this.createTime,
    required this.state,
    required this.quantity,
    required this.totalAmount,
    required this.currency,
  });
}