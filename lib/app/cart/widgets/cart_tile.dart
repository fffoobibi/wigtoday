import 'package:flutter/material.dart';

import 'package:wigtoday_app/utils/font.dart';
import 'package:wigtoday_app/utils/color.dart';
import 'package:wigtoday_app/utils/theme.dart';
import 'package:wigtoday_app/widgets/counter.dart';
import 'package:wigtoday_app/app/home/models/product.dart';
import 'package:wigtoday_app/app/cart/models/cart_item.dart';


class CartTile extends StatefulWidget {
  final CartItemModel item;
  final bool isSelected;
  final void Function(bool) onSelected;
  final void Function(int) onChanged;
  const CartTile({
    Key? key,
    required this.item,
    required this.onSelected,
    required this.onChanged,
    this.isSelected = false,
  }) : super(key: key);

  @override
  State<CartTile> createState() => _CartTileState();
}

class _CartTileState extends State<CartTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Ink(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: Row(
          children: [
            _checkbox(),
            _imageBox(),
            Expanded(
              child: _contentBox(),
            ),
          ],
        ),
      ),
    );
  }


  Widget _checkbox() {
    Color lightColor = BZTheme.isDark(context) ? BZColor.darkLight : BZColor.light;
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      child: Checkbox(
        value: widget.isSelected,
        activeColor: Theme.of(context).primaryColor,
        side: BorderSide(color: lightColor),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        onChanged: (val) {
          widget.onSelected(val ?? false);
        },
      ),
    );
  }


  Widget _imageBox() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(widget.item.product.imageUrl, fit: BoxFit.cover, width: 70, height: 70),
    );
  }


  Widget _contentBox() {
    Color titleColor = BZTheme.isDark(context) ? BZColor.darkTitle : BZColor.title;
    Color greyColor = BZTheme.isDark(context) ? BZColor.darkGrey : BZColor.grey;
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.item.product.title,
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
                child: _prices(widget.item.product),
              ),
              BZCounter(
                width: 90,
                height: 26,
                initValue: widget.item.quantity,
                min: widget.item.minQuantity,
                max: widget.item.maxQuantity,
                onChanged: (val) {},
              ),
              const SizedBox(width: 5),
            ],
          ),
        ],
      ),
    );
  }


  Widget _prices(ProductModel product) {
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
              color: BZTheme.isDark(context) ? BZColor.darkAmount : BZColor.amount,
            ),
          ),
        ],
      ),
    );
  }
}
