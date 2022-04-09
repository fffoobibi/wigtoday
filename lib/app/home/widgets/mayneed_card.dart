import 'package:flutter/material.dart';
import 'package:wigtoday_app/utils/color.dart';
import 'package:wigtoday_app/utils/font.dart';
import 'package:wigtoday_app/utils/theme.dart';
import 'package:wigtoday_app/app/home/models/product.dart';


class MayNeedCard extends StatefulWidget {
  final ProductModel product;
  final void Function(bool)? onSelected;
  final void Function()? onTap;
  const MayNeedCard({
    Key? key,
    required this.product,
    this.onSelected,
    this.onTap,
  }) : super(key: key);

  @override
  State<MayNeedCard> createState() => _MayNeedCardState();
}

class _MayNeedCardState extends State<MayNeedCard> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    const double width = 110;
    final Color bgColor = BZTheme.isDark(context) ? BZColor.darkCard : BZColor.card;
    return Stack(
      children: [
        Container(
          width: width,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(color: bgColor),
          child: InkWell(
            onTap: widget.onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(widget.product.imageUrl, width: width, height: width, fit: BoxFit.cover,),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: _cardTitle(context),
                ),
                _cardBottom(context),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
        Positioned(
          right: 8,
          top: 0,
          child: _checkBox(),
        ),
      ],
    );
  }


  Widget _checkBox() {
    return Stack(
      children: [
        Positioned(
          right: 0,
          top: 0,
          width: 18,
          height: 18,
          child: Checkbox(
            value: _isSelected,
            activeColor: Theme.of(context).primaryColor,
            side: BorderSide(color: Theme.of(context).primaryColor, width: 2),
            onChanged: (val) {
              setState(() => _isSelected = val ?? false);
            },
          ),
        ),
        Ink(
          width: 40,
          height: 40,
          child: InkWell(
            onTap: () {
              setState(() => _isSelected = !_isSelected);
            },
          ),
        ),
      ],
    );
  }


  Widget _cardTitle(BuildContext context) {
    return Text(
      widget.product.title,
      maxLines: 2,
      style: TextStyle(
        fontSize: BZFontSize.min,
        color: BZTheme.isDark(context) ? BZColor.darkTitle : BZColor.title,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }


  Widget _cardBottom(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.product.currency + ' ' + widget.product.rawPriceFmt,
          style: TextStyle(
            fontSize: BZFontSize.min,
            color: BZTheme.isDark(context) ? BZColor.darkSemi : BZColor.semi,
            decoration: TextDecoration.lineThrough,
          ),
        ),
        Text.rich(
          TextSpan(
            style: TextStyle(
              color: BZTheme.isDark(context) ? BZColor.darkAmount : BZColor.amount,
            ),
            children: [
              TextSpan(
                text: widget.product.currency,
                style: const TextStyle(
                  fontSize: BZFontSize.min,
                ),
              ),
              const WidgetSpan(child: SizedBox(width: 3)),
              TextSpan(
                text: widget.product.realPriceFmt,
                style: const TextStyle(
                  fontSize: BZFontSize.content,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}