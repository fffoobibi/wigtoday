import 'package:flutter/material.dart';
import 'package:wigtoday_app/app/home/models/product.dart';
import 'package:wigtoday_app/utils/color.dart';
import 'package:wigtoday_app/utils/font.dart';
import 'package:wigtoday_app/utils/theme.dart';

class ProductTile extends StatelessWidget {
  final ProductModel product;
  final void Function()? onTap;

  const ProductTile({
    Key? key,
    required this.product,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(product.imageUrl, width: 100, height: 100, fit: BoxFit.cover,),
            ),
            const SizedBox(width: 8),
            Expanded(child: _mainContent(context)),
          ],
        ),
      ),
    );
  }


  Widget _mainContent(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.title,
            maxLines: 2,
            style: TextStyle(
              fontSize: BZFontSize.title,
              color: BZTheme.isDark(context) ? BZColor.darkTitle : BZColor.title,
            ),
          ),
          Text(
            '★★★★★☆☆☆☆☆'.substring(5 - product.score, 10 - product.score),
            style: TextStyle(
              fontSize: BZFontSize.content,
              color: BZTheme.isDark(context) ? BZColor.darkAmount : BZColor.amount,
            ),
          ),
          const SizedBox(height: 2,),
          Expanded(
            child: product.tags.isNotEmpty ? Wrap(
              spacing: 3,
              runSpacing: 2,
              runAlignment: WrapAlignment.start,
              children: List.generate(product.tags.length, (index) => _tag(context, index)),
            ) :
            const SizedBox.shrink(),
          ),
          _prices(context),
        ],
      ),
    );
  }


  Widget _tag(BuildContext context, int index) {
    const double height = 16;
    return UnconstrainedBox(
      child: Container(
        height: height,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: BZTheme.isDark(context) ? BZColor.darkDivider : BZColor.divider,
          borderRadius: const BorderRadius.all(Radius.circular(height / 2)),
        ),
        child: Text(
          product.tags[index],
          style: TextStyle(
            fontSize: BZFontSize.min,
            color: BZTheme.isDark(context) ? BZColor.darkGrey : BZColor.grey,
          ),
        ),
      ),
    );
  }


  Widget _prices(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          product.currency + ' ' + product.rawPriceFmt,
          style: TextStyle(
            fontSize: BZFontSize.min,
            color: BZTheme.isDark(context) ? BZColor.darkGrey : BZColor.grey,
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
                text: product.currency,
                style: const TextStyle(
                  fontSize: BZFontSize.content,
                ),
              ),
              const WidgetSpan(child: SizedBox(width: 3)),
              TextSpan(
                text: product.realPriceFmt,
                style: const TextStyle(
                  fontSize: BZFontSize.title,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}