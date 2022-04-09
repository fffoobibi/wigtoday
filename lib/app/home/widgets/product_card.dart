import 'package:flutter/material.dart';
import 'package:wigtoday_app/utils/color.dart';
import 'package:wigtoday_app/utils/font.dart';
import 'package:wigtoday_app/utils/theme.dart';
import 'package:wigtoday_app/app/home/models/product.dart';


class ProductCard extends StatelessWidget {
  final ProductModel product;
  final double width;
  final bool hasShadow;
  final bool hasCartBtn;
  final void Function()? onTap;
  const ProductCard({
    Key? key,
    required this.product,
    this.width = 160,
    this.hasShadow = false,
    this.hasCartBtn = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color bgDarkColor = hasShadow ? BZColor.darkTab : BZColor.darkCard;
    final Color bgLightColor = hasShadow ? BZColor.tab : BZColor.card;
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        clipBehavior: Clip.antiAlias,
        margin: hasShadow ? const EdgeInsets.symmetric(horizontal: 8,) : null,
        decoration: BoxDecoration(
          color: BZTheme.isDark(context) ? bgDarkColor : bgLightColor,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          boxShadow: hasShadow ? [BoxShadow(
            offset: const Offset(0, 3),
            color: BZTheme.isDark(context) ? BZColor.darkShadow : BZColor.shadow,
            blurRadius: 8,
            spreadRadius: 2,
          )] : null,
        ),
        child: Column(
          children: [
            Image.network(product.imageUrl, width: width, height: width, fit: BoxFit.cover,),
            _cardTitle(context),
            _cardBottom(context),
          ],
        ),
      ),
    );
  }


  Widget _cardTitle(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      alignment: Alignment.centerLeft,
      child: Text(
        product.title,
        maxLines: 2,
        style: TextStyle(
          fontSize: BZFontSize.title,
          color: BZTheme.isDark(context) ? BZColor.darkTitle : BZColor.title,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }


  Widget _cardBottom(BuildContext context) {
    const double width = 36;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: _priceBox(context),
          ),
          if (hasCartBtn) InkWell(
            onTap: () {},
            child: Container(
              width: width,
              height: width,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(width / 2)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[BZColor.gradEnd, BZColor.gradStart],
                ),
              ),
              child: const Icon(Icons.shopping_cart_outlined, size: 20, color: Colors.white,),
            ),
          ),
        ],
      ),
    );
  }


  Widget _priceBox(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.currency + product.rawPriceFmt,
          style: TextStyle(
            fontSize: BZFontSize.content,
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
        ),
      ],
    );
  }
}