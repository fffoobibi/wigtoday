import 'package:flutter/material.dart';

import 'package:wigtoday_app/utils/font.dart';
import 'package:wigtoday_app/utils/color.dart';
import 'package:wigtoday_app/utils/theme.dart';
import 'package:wigtoday_app/widgets/button.dart';
import 'package:wigtoday_app/app/user/models/order.dart';
import 'package:wigtoday_app/app/home/models/product.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class OrderTile extends StatelessWidget {
  final OrderModel order;
  final VoidCallback? onTap;
  const OrderTile({
    Key? key,
    required this.order,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Ink(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    _imageBox(),
                    Expanded(
                      child: _contentBox(context),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _optionBox(context),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _imageBox() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(order.product.imageUrl, fit: BoxFit.cover, width: 70, height: 70),
    );
  }


  Widget _contentBox(BuildContext context) {
    Color titleColor = BZTheme.isDark(context) ? BZColor.darkTitle : BZColor.title;
    Color greyColor = BZTheme.isDark(context) ? BZColor.darkGrey : BZColor.grey;
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            order.product.title,
            maxLines: 2,
            style: TextStyle(
              fontSize: BZFontSize.subTitle,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Hair Length: 24  Lace design: 4*4 Lce',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: BZFontSize.content,
              color: greyColor,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _prices(context, order.product),
              ),
              Text(
                'x ${order.quantity}',
                style: TextStyle(
                  fontSize: BZFontSize.title,
                  color: BZTheme.isDark(context) ? BZColor.darkSemi : BZColor.semi,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _prices(BuildContext context, ProductModel product) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: product.currency + ' ' + product.rawPriceFmt,
            style: TextStyle(
              fontSize: BZFontSize.content,
              color: BZTheme.isDark(context) ? BZColor.darkGrey : BZColor.grey,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          const WidgetSpan(child: SizedBox(width: 8)),
          TextSpan(
            text: product.currency + ' ' + product.realPriceFmt,
            style: TextStyle(
              fontSize: BZFontSize.title,
              fontWeight: FontWeight.bold,
              color: BZTheme.isDark(context) ? BZColor.darkTitle : BZColor.title,
            ),
          ),
        ],
      ),
    );
  }


  Widget _optionBox(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        BZTextButton(
          text: AppLocalizations.of(context)!.checkTheLogistics,
          fontSize: BZFontSize.content,
          foregroundColor: BZTheme.isDark(context) ? BZColor.darkTitle : BZColor.title,
          height: 30,
          radius: 15,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          border: Border.all(color: Theme.of(context).dividerColor),
          onTap: () {},
        ),
      ],
    );
  }
}
