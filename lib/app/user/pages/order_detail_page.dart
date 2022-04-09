import 'package:flutter/material.dart';

import 'package:wigtoday_app/utils/color.dart';
import 'package:wigtoday_app/utils/font.dart';
import 'package:wigtoday_app/utils/theme.dart';
import 'package:wigtoday_app/widgets/button.dart';
import 'package:wigtoday_app/app/user/models/order.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wigtoday_app/app/user/widgets/order_detail_tile.dart';


class OrderDetailPage extends StatefulWidget {
  final OrderModel order;
  const OrderDetailPage({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.orderDetails),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            _addressBox(),
            OrderDetailTile(order: widget.order),
            _orderInfo(),
            _logisticList(),
          ],
        ),
      ),
    );
  }


  Widget _addressBox() {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Row(
        children: [
          Image.asset('assets/icons/order-address.png', fit: BoxFit.cover, width: 24, height: 24,),
          const SizedBox(width: 12),
          Expanded(child: _addressInfo()),
        ],
      ),
    );
  }


  Widget _addressInfo() {
    Color titleColor = BZTheme.isDark(context) ? BZColor.darkTitle : BZColor.title;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Miss Wang',
                style: TextStyle(
                  fontSize: BZFontSize.title,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
              ),
              const WidgetSpan(child: SizedBox(width: 8)),
              TextSpan(
                text: '15834985677',
                style: TextStyle(
                  fontSize: BZFontSize.title,
                  color: titleColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        Text(
          '501, building A, Xinzhuang Town, Minhang District, Shanghai, China',
          maxLines: 2,
          style: TextStyle(
            fontSize: BZFontSize.subTitle,
            color: titleColor,
            height: 1.4,
          ),
        ),
      ],
    );
  }


  Widget _orderInfo() {
    Color titleColor = BZTheme.isDark(context) ? BZColor.darkTitle : BZColor.title;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Ink(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _orderNo(),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: AppLocalizations.of(context)!.payment,
                    style: TextStyle(
                      fontSize: BZFontSize.subTitle,
                      color: titleColor,
                    ),
                  ),
                  const WidgetSpan(child: SizedBox(width: 8)),
                  TextSpan(
                    text: 'Paypal',
                    style: TextStyle(
                      fontSize: BZFontSize.subTitle,
                      color: titleColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: AppLocalizations.of(context)!.orderTime,
                    style: TextStyle(
                      fontSize: BZFontSize.subTitle,
                      color: titleColor,
                    ),
                  ),
                  const WidgetSpan(child: SizedBox(width: 8)),
                  TextSpan(
                    text: '2022-01-22',
                    style: TextStyle(
                      fontSize: BZFontSize.subTitle,
                      color: titleColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _orderNo() {
    Color titleColor = BZTheme.isDark(context) ? BZColor.darkTitle : BZColor.title;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: AppLocalizations.of(context)!.orderNo,
                style: TextStyle(
                  fontSize: BZFontSize.subTitle,
                  color: titleColor,
                ),
              ),
              const WidgetSpan(child: SizedBox(width: 8)),
              TextSpan(
                text: 'P784932022574389y83',
                style: TextStyle(
                  fontSize: BZFontSize.subTitle,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
              ),
            ],
          ),
        ),
        BZTextButton(
          text: AppLocalizations.of(context)!.copy,
          fontSize: BZFontSize.content,
          foregroundColor: titleColor,
          border: Border.all(color: Theme.of(context).dividerColor),
          radius: 20,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          onTap: () {},
        ),
      ],
    );
  }


  Widget _logisticList() {
    Color titleColor = BZTheme.isDark(context) ? BZColor.darkTitle : BZColor.title;
    Color semiColor = BZTheme.isDark(context) ? BZColor.darkSemi : BZColor.semi;
    return Container(
      margin: const EdgeInsets.all(8),
      // padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Stepper(
        controlsBuilder: (context, controls) => const SizedBox.shrink(),
        steps: [
          Step(
            title: Text(
              'Miss Wang, 15834985677',
              style: TextStyle(
                fontSize: BZFontSize.subTitle,
                color: titleColor,
              ),
            ),
            subtitle: Text(
              '501, building A, Xinzhuang Town, Minhang District, Shanghai, China',
              maxLines: 2,
              style: TextStyle(
                fontSize: BZFontSize.content,
                color: semiColor,
              ),
            ),
            content: Container(),
            state: StepState.complete,
            isActive: true,
          ),
          Step(
            title: Text(
              '2022-04-05 AM 08:00',
              style: TextStyle(
                fontSize: BZFontSize.subTitle,
                color: titleColor,
              ),
            ),
            subtitle: Text(
              'ZhongTong Express, Caoxi North road, Xuhui District, Shanghai, China',
              maxLines: 2,
              style: TextStyle(
                fontSize: BZFontSize.content,
                color: semiColor,
              ),
            ),
            content: const SizedBox.shrink(),
            state: StepState.complete,
          ),
          Step(
            title: Text(
              '2022-04-04 PM 18:00',
              style: TextStyle(
                fontSize: BZFontSize.subTitle,
                color: titleColor,
              ),
            ),
            subtitle: Text(
              'Aoti North road, Jiangning District, Nanjing, JiangSu, China',
              maxLines: 2,
              style: TextStyle(
                fontSize: BZFontSize.content,
                color: semiColor,
              ),
            ),
            content: const SizedBox.shrink(),
            state: StepState.complete,
          ),
        ],
      ),
    );
  }
}
