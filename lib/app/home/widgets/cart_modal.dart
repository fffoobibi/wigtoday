import 'package:flutter/material.dart';

import 'package:wigtoday_app/utils/font.dart';
import 'package:wigtoday_app/utils/size.dart';
import 'package:wigtoday_app/utils/color.dart';
import 'package:wigtoday_app/utils/theme.dart';
import 'package:wigtoday_app/widgets/counter.dart';
import 'package:wigtoday_app/widgets/button.dart';
import 'package:wigtoday_app/app/home/models/product.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class CartModal extends StatefulWidget {
  final ProductModel product;
  final void Function() onAddCart;
  final void Function() onBuyNow;

  const CartModal({
    Key? key,
    required this.product,
    required this.onAddCart,
    required this.onBuyNow,
  }) : super(key: key);

  @override
  State<CartModal> createState() => _CartModalState();
}


class _CartModalState extends State<CartModal> {
  String _selectedText = '';
  List<int> _selectedIndex = [];

  @override
  void initState() {
    _selectedIndex = List.filled(widget.product.sizes.length, 0);
    for (int i=0; i<widget.product.sizes.length; i++) {
      _selectedText += widget.product.sizes[i].options[0]['value'] + ', ';
    }
    _selectedText += 'x1';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List sizes = widget.product.sizes;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _indicator(),
          const SizedBox(height: 12),
          _productInfo(),
          const SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...List.generate(sizes.length, (index) => _sizeBox(sizes[index], index)),
                  _countBox(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 5),
          _operationsBox(),
          SizedBox(height: BZSize.bottomBarHeight),
        ],
      ),
    );
  }


  Widget _indicator() {
    return Container(
      width: 40,
      height: 3,
      margin: EdgeInsets.symmetric(horizontal: BZSize.pageWidth / 2 - 32),
      decoration: BoxDecoration(
        color: BZTheme.isDark(context) ? BZColor.darkLight : BZColor.light,
        borderRadius: const BorderRadius.all(Radius.circular(1.5))
      ),
    );
  }


  Widget _productInfo() {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(widget.product.imageUrl, fit: BoxFit.cover, width: 70, height: 70),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _pricesBox(),
              const SizedBox(height: 8),
              _selectedInfo(),
            ],
          ),
        ),
      ],
    );
  }


  Widget _pricesBox() {
    Color amountColor = BZTheme.isDark(context) ? BZColor.darkAmount : BZColor.amount;
    Color greyColor = BZTheme.isDark(context) ? BZColor.darkGrey : BZColor.grey;
    String price = widget.product.realPriceFmt;
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: widget.product.currency,
            style: TextStyle(
              fontSize: BZFontSize.content,
              color: amountColor,
            ),
          ),
          const WidgetSpan(child: SizedBox(width: 3)),
          TextSpan(
            text: price.substring(0, price.length - 3),
            style: TextStyle(
              fontSize: BZFontSize.big,
              fontWeight: FontWeight.bold,
              color: amountColor,
            ),
          ),
          TextSpan(
            text: price.substring(price.length - 3),
            style: TextStyle(
              fontSize: BZFontSize.navTitle,
              fontWeight: FontWeight.bold,
              color: amountColor,
            ),
          ),
          const WidgetSpan(child: SizedBox(width: 10)),
          TextSpan(
            text: widget.product.currency + widget.product.rawPriceFmt,
            style: TextStyle(
              decoration: TextDecoration.lineThrough,
              fontSize: BZFontSize.content,
              color: greyColor,
            ),
          ),
        ],
      ),
    );
  }


  Widget _selectedInfo() {
    return Text.rich(
      TextSpan(
        style: TextStyle(
          fontSize: BZFontSize.content,
          color: BZTheme.isDark(context) ? BZColor.darkTitle : BZColor.title,
        ),
        children: [
          TextSpan(
            text: AppLocalizations.of(context)!.selected,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const WidgetSpan(child: SizedBox(width: 8)),
          TextSpan(text: _selectedText),
        ],
      ),
    );
  }


  Widget _sizeBox(ProductSizeModel item, int sizeIndex) {
    Color titleColor = BZTheme.isDark(context) ? BZColor.darkTitle : BZColor.title;
    Color semiColor = BZTheme.isDark(context) ? BZColor.darkSemi : BZColor.semi;
    Color groundColor = BZTheme.isDark(context) ? BZColor.darkPrimaryGround : BZColor.primaryGround;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.title,
          style: TextStyle(
            fontSize: BZFontSize.title,
            color: semiColor,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(item.options.length, (index) {
              var option = item.options[index];
              return ChoiceChip(
                label: Text(
                  option['value'],
                  style: TextStyle(
                    fontSize: BZFontSize.content,
                    color: _selectedIndex[sizeIndex] == index ? Theme.of(context).primaryColor : titleColor,
                  ),
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                backgroundColor: Theme.of(context).dividerColor,
                selectedColor: groundColor,
                selected: _selectedIndex[sizeIndex] == index,
                onSelected: (val) {
                  List<String> texts = _selectedText.split(', ');
                  texts[sizeIndex] = item.options[index]['value'];
                  setState(() {
                    _selectedIndex[sizeIndex] = index;
                    _selectedText = texts.join(', ');
                  });
                },
              );
            }),
          ),
        ),
      ],
    );
  }


  Widget _countBox() {
    Color semiColor = BZTheme.isDark(context) ? BZColor.darkSemi : BZColor.semi;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppLocalizations.of(context)!.quantity,
          style: TextStyle(
            fontSize: BZFontSize.title,
            color: semiColor,
          ),
        ),
        BZCounter(
          width: 100,
          height: 28,
          onChanged: (val) {
            List<String> texts = _selectedText.split(', ');
            texts.last = 'x$val';
            setState(() {
              _selectedText = texts.join(', ');
            });
          },
        ),
      ],
    );
  }


  Widget _operationsBox() {
    final Color warnColor = BZTheme.isDark(context) ? BZColor.darkWarn : BZColor.warn;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        BZTextButton(
          text: AppLocalizations.of(context)!.addToCart,
          style: const TextStyle(fontSize: BZFontSize.title, color: Colors.white),
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          backgroundColor: warnColor,
          radius: 18,
          onTap: widget.onAddCart,
        ),
        BZTextButton(
          text: AppLocalizations.of(context)!.buyNow,
          style: const TextStyle(fontSize: BZFontSize.title, color: Colors.white),
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          gradient: const LinearGradient(colors: [BZColor.gradStart, BZColor.gradEnd]),
          radius: 18,
          onTap: widget.onBuyNow,
        ),
      ],
    );
  }
}