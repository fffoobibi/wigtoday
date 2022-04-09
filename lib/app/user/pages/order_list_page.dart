import 'package:flutter/material.dart';

import 'package:wigtoday_app/utils/font.dart';
import 'package:wigtoday_app/utils/color.dart';
import 'package:wigtoday_app/utils/theme.dart';
import 'package:wigtoday_app/app/user/models/order.dart';
import 'package:wigtoday_app/app/home/models/product.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wigtoday_app/app/user/widgets/order_tile.dart';
import 'package:wigtoday_app/app/user/pages/order_detail_page.dart';


class OrderListPage extends StatefulWidget {
  const OrderListPage({Key? key}) : super(key: key);

  @override
  State<OrderListPage> createState() => _OrderListPageState();
}


class _OrderListPageState extends State<OrderListPage> {
  OrderState _state = OrderState.unpaid;
  final List<OrderModel> _orders = [
    OrderModel(
      product: ProductModel(
        id: 1,
        title: 'Lolita Alicegarden Bonnie Pink/Purple',
        imageUrl: 'https://placeimg.com/310/310/any1',
        realPrice: 11.0,
        rawPrice: 15.9,
        score: 5,
        sizes: [
          ProductSizeModel(
            title: 'Hair Length',
            options: [
              {'id': 213, 'value': '14'},
              {'id': 214, 'value': '16'},
              {'id': 215, 'value': '18'},
              {'id': 216, 'value': '20'},
              {'id': 217, 'value': '22'},
              {'id': 218, 'value': '24'},
              {'id': 219, 'value': '26'},
            ],
          ),
        ],
      ),
      createTime: 1654376453,
      state: OrderState.completed,
      quantity: 1,
      totalAmount: 123.90,
      currency: 'USD',
    ),
    OrderModel(
      product: ProductModel(
        id: 2,
        title: 'Short Pink Straight Wig Wm1104 Pink/Purple Buns Wig Wm1018 Bonnie Hgfid ReBuild List',
        imageUrl: 'https://placeimg.com/310/310/any2',
        realPrice: 124.0,
        rawPrice: 158.3,
        score: 3,
        sizes: [
          ProductSizeModel(
            title: 'Hair Length',
            options: [
              {'id': 213, 'value': '14'},
              {'id': 214, 'value': '16'},
              {'id': 215, 'value': '18'},
              {'id': 216, 'value': '20'},
              {'id': 217, 'value': '22'},
              {'id': 218, 'value': '24'},
              {'id': 219, 'value': '26'},
            ],
          ),
          ProductSizeModel(
            title: 'Lace Design',
            options: [
              {'id': 23, 'value': '4*4 LACE CLOSURE WIG'},
              {'id': 24, 'value': '3*4 HAIR WIG'},
              {'id': 25, 'value': '2*3 ASDRE HAIR'},
              {'id': 26, 'value': '5*5 JHGT LKJR'},
            ],
          ),
        ],
      ),
      createTime: 1654376453,
      state: OrderState.completed,
      quantity: 1,
      totalAmount: 123.90,
      currency: 'USD',
    ),
    OrderModel(
      product: ProductModel(
        id: 3,
        title: 'Kuytrhitg per Light Dintjhifd Finds a Tfrefbchd fhroioy Pink/Purple Buns Wig Wm1018 Bonnie',
        imageUrl: 'https://placeimg.com/310/310/any3',
        realPrice: 21.5,
        rawPrice: 35.9,
        score: 4,
        sizes: [
          ProductSizeModel(
            title: 'Hair Length',
            options: [
              {'id': 213, 'value': '14'},
              {'id': 214, 'value': '16'},
              {'id': 215, 'value': '18'},
              {'id': 216, 'value': '20'},
              {'id': 217, 'value': '22'},
              {'id': 218, 'value': '24'},
              {'id': 219, 'value': '26'},
            ],
          ),
          ProductSizeModel(
            title: 'Lace Design',
            options: [
              {'id': 23, 'value': '4*4 LACE CLOSURE WIG'},
              {'id': 24, 'value': '3*4 HAIR WIG'},
              {'id': 25, 'value': '2*3 ASDRE HAIR'},
              {'id': 26, 'value': '5*5 JHGT LKJR'},
            ],
          ),
        ],
      ),
      createTime: 1654376453,
      state: OrderState.completed,
      quantity: 1,
      totalAmount: 123.90,
      currency: 'USD',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.orderList),
        actions: [
          _dropdownMenu(),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        shrinkWrap: true,
        itemCount: _orders.length,
        itemBuilder: (context, index) {
          return OrderTile(
            order: _orders[index],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderDetailPage(order: _orders[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }


  Widget _dropdownMenu() {
    List<String> stateTexts = [
      'Unpaid',
      'Paid',
      'Processing',
      'Completed',
      'Refunded',
      'Refund',
    ];
    return UnconstrainedBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: DropdownButton(
          elevation: 1,
          isDense: true,
          underline: const SizedBox.shrink(),
          borderRadius: BorderRadius.circular(8),
          value: _state.index,
          icon: const Icon(Icons.keyboard_arrow_down, size: 20,),
          dropdownColor: Theme.of(context).cardColor,
          items: List.generate(
            stateTexts.length,
            (index) => DropdownMenuItem(child: Text(stateTexts[index]), value: index),
          ),
          alignment: AlignmentDirectional.centerEnd,
          style: TextStyle(
            fontSize: BZFontSize.title,
            color: BZTheme.isDark(context) ? BZColor.darkTitle : BZColor.title,
          ),
          onChanged: (int? val) {
            setState(() {
              _state = OrderState.values[val ?? 0];
            });
          },
        ),
      ),
    );
  }
}
