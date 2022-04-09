import 'dart:math' show min;
import 'package:flutter/material.dart';

import 'package:wigtoday_app/utils/font.dart';
import 'package:wigtoday_app/utils/size.dart';
import 'package:wigtoday_app/utils/color.dart';
import 'package:wigtoday_app/utils/theme.dart';
import 'package:wigtoday_app/widgets/button.dart';
import 'package:wigtoday_app/app/cart/models/pay.dart';
import 'package:wigtoday_app/app/home/models/product.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class OrderingPage extends StatefulWidget {
  const OrderingPage({ Key? key }) : super(key: key);

  @override
  State<OrderingPage> createState() => _OrderingPageState();
}


class _OrderingPageState extends State<OrderingPage> {
  final TextEditingController _codeController = TextEditingController();
  final List<PayChannelModel> _payChannels = [];
  final List<ProductModel> _items = [];
  final GlobalKey<FormState> _formKey = GlobalKey();
  String _itemsTotal = 'USD 474.25';
  String _subTotal = 'USD 92.31';
  String _shipping = '+USD 0.00';
  String _totalAmount = 'USD 930.50';
  bool _isLogin = false;
  bool _willCreateAccount = false;
  late int _payChannelId;

  @override
  void initState() {
    _items.addAll([
      ProductModel(
        id: 1,
        title: 'Harleen Quinzel Cosplay Wigs Synthetic Wigs',
        imageUrl: 'https://placeimg.com/140/140/any123',
        realPrice: 514.62,
        rawPrice: 584.56,
      ),
      ProductModel(
        id: 2,
        title: 'Lolita Alicegarden Bonnie Pink/Purple',
        imageUrl: 'https://placeimg.com/140/140/65465',
        realPrice: 213.42,
        rawPrice: 234.56,
      ),
      ProductModel(
        id: 3,
        title: 'Buns Wig Wm1018 Bonnie Pink/Purple Buns Wig Wm1018',
        imageUrl: 'https://placeimg.com/140/140/any123',
        realPrice: 34.65,
        rawPrice: 41.43,
      ),
      ProductModel(
        id: 4,
        title: 'Cosplay Wigs Synthetic Wigs Harleen Quinzel Cosplay Wigs Synthetic Wigs',
        imageUrl: 'https://placeimg.com/140/140/any123',
        realPrice: 54.88,
        rawPrice: 67.33,
      ),
    ]);
    _payChannels.addAll(const [
      PayChannelModel(id: 1, name: 'Paypal', imageUrl: 'paypal.png'),
      PayChannelModel(id: 2, name: 'Paymentwall', imageUrl: 'paymentwall.png'),
      PayChannelModel(id: 3, name: 'Airwallex', imageUrl: 'airwallex.png'),
    ]);
    _payChannelId = _payChannels.first.id;

    super.initState();
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.confirmOrder)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Column(
          children: [
            _itemsBox(),
            const SizedBox(height: 16),
            _subTotalBox(),
            const SizedBox(height: 16),
            _addressBox(),
            SizedBox(height: 50 + BZSize.bottomBarHeight),
          ],
        ),
      ),
      bottomSheet: _bottomBar(),
    );
  }

  // 商品信息
  Widget _itemsBox() {
    Color titleColor = BZTheme.isDark(context) ? BZColor.darkTitle : BZColor.title;
    Color amountColor = BZTheme.isDark(context) ? BZColor.darkAmount : BZColor.amount;
    return Ink(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ...List.generate(min(_items.length, 3), (index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(_items[index].imageUrl, fit: BoxFit.cover, width: 60, height: 60),
            );
          }),
          if (_items.length > 3) Text(
            '${_items.length} ' + AppLocalizations.of(context)!.items,
            style: TextStyle(fontSize: BZFontSize.content, color: titleColor),
          ),
          BZTextButton(
            text: _itemsTotal,
            style: TextStyle(
              fontSize: BZFontSize.title,
              fontWeight: FontWeight.bold,
              color: amountColor,
            ),
            rightIcon: Icons.expand_more,
            foregroundColor: amountColor,
            padding: const EdgeInsets.fromLTRB(5, 12, 0, 12),
            onTap: _showItemListModal,
          ),
        ],
      ),
    );
  }

  // 小结部分
  Widget _subTotalBox() {
    return Ink(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _exchangeCodeBox(),
          const SizedBox(height: 12),
          _subTotalItem(AppLocalizations.of(context)!.subtotal, _subTotal),
          _subTotalItem(AppLocalizations.of(context)!.shipping, _shipping),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.payChannel,
            style: TextStyle(
              fontSize: BZFontSize.title,
              color: BZTheme.isDark(context) ? BZColor.darkTitle : BZColor.title,
            ),
          ),
          const SizedBox(height: 5),
          ..._payChannels.map((e) => _payChannel(e)),
        ],
      ),
    );
  }

  // 兑换码部分
  Widget _exchangeCodeBox() {
    Color amountColor = Theme.of(context).primaryColor;
    return Ink(
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: amountColor),
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: _textField(),
            ),
          ),
          BZTextButton(
            text: AppLocalizations.of(context)!.apply,
            fontSize: BZFontSize.title,
            foregroundColor: Colors.white,
            backgroundColor: amountColor,
            width: 100,
            height: 38,
            borderRadius: const BorderRadius.horizontal(right: Radius.circular(3)),
            padding: const EdgeInsets.all(0),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  // 兑换码输入框
  Widget _textField() {
    Color titleColor = BZTheme.isDark(context) ? BZColor.darkTitle : BZColor.title;
    Color greyColor = BZTheme.isDark(context) ? BZColor.darkGrey : BZColor.grey;
    return TextField(
      controller: _codeController,
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context)!.exchangeCode,
        hintStyle: TextStyle(fontSize: BZFontSize.title, color: greyColor),
        border: InputBorder.none,
        isCollapsed: true,
      ),
      style: TextStyle(
        fontSize: BZFontSize.title,
        color: titleColor,
      ),
    );
  }


  Widget _subTotalItem(String label, String value) {
    Color titleColor = BZTheme.isDark(context) ? BZColor.darkTitle : BZColor.title;
    Color amountColor = BZTheme.isDark(context) ? BZColor.darkAmount : BZColor.amount;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 0.5, color: Theme.of(context).dividerColor)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: BZFontSize.title, color: titleColor)),
          Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: BZFontSize.subTitle,
              color: amountColor,
            ),
          ),
        ],
      ),
    );
  }


  Widget _payChannel(PayChannelModel channel) {
    return RadioListTile(
      value: channel.id,
      groupValue: _payChannelId,
      activeColor: Theme.of(context).primaryColor,
      contentPadding: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      dense: true,
      title: Row(
        children: [
          Image.asset('assets/images/' + channel.imageUrl, fit: BoxFit.cover, width: 30, height: 30),
          const SizedBox(width: 8),
          Text(
            channel.name,
            style: TextStyle(
              fontSize: BZFontSize.title,
              fontWeight: FontWeight.bold,
              color: BZTheme.isDark(context) ? BZColor.darkSemi : BZColor.semi,
            ),
          ),
        ],
      ),
      onChanged: (int? val) {
        setState(() => _payChannelId = val ?? _payChannels.first.id);
      },
    );
  }


  Widget _addressBox() {
    Color titleColor = BZTheme.isDark(context) ? BZColor.darkTitle : BZColor.title;
    return Ink(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.addressInformation,
                style: TextStyle(
                  fontSize: BZFontSize.title,
                  color: titleColor,
                ),
              ),
              if (!_isLogin) BZTextButton(
                text: AppLocalizations.of(context)!.signIn,
                fontSize: BZFontSize.title,
                foregroundColor: titleColor,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 12),
          _addressForm(),
        ],
      ),
    );
  }


  Widget _addressForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _formField(hintText: AppLocalizations.of(context)!.firstName, validator: (val) {
                  return null;
                }),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _formField(hintText: AppLocalizations.of(context)!.lastName, validator: (val) {
                  return null;
                }),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _formField(
            hintText: AppLocalizations.of(context)!.emailAddress,
            keyboardType: TextInputType.emailAddress,
            validator: (val) {
              return null;
            },
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _formField(
                  hintText: AppLocalizations.of(context)!.telephone,
                  keyboardType: TextInputType.phone,
                  validator: (val) {
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _formField(hintText: AppLocalizations.of(context)!.zip, validator: (val) {
                  return null;
                }),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _formField(hintText: AppLocalizations.of(context)!.country, validator: (val) {
            return null;
          }),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _formField(hintText: AppLocalizations.of(context)!.stateOrProvince, validator: (val) {
                  return null;
                }),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _formField(hintText: AppLocalizations.of(context)!.city, validator: (val) {
                  return null;
                }),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _formField(
            hintText: AppLocalizations.of(context)!.address,
            maxLines: 3,
            validator: (val) {
              return null;
            },
          ),
          if (!_isLogin) const SizedBox(height: 5),
          if (!_isLogin) CheckboxListTile(
            value: _willCreateAccount,
            activeColor: Theme.of(context).primaryColor,
            contentPadding: const EdgeInsets.all(0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            controlAffinity: ListTileControlAffinity.leading,
            dense: true,
            title: Text(
              AppLocalizations.of(context)!.createAccountForLaterUse,
              style: TextStyle(
                fontSize: BZFontSize.content,
                color: BZTheme.isDark(context) ? BZColor.darkTitle : BZColor.title,
              ),
            ),
            onChanged: (bool? val) {
              setState(() => _willCreateAccount = val ?? false);
            },
          ),
        ],
      ),
    );
  }


  Widget _formField({
    required String hintText,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    Color titleColor = BZTheme.isDark(context) ? BZColor.darkTitle : BZColor.title;
    Color greyColor = BZTheme.isDark(context) ? BZColor.darkGrey : BZColor.grey;
    Color backgroudColor = BZTheme.isDark(context) ? BZColor.darkNav : BZColor.nav;
    return TextFormField(
      maxLines: maxLines,
      style: TextStyle(fontSize: BZFontSize.subTitle, color: titleColor),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontSize: BZFontSize.subTitle, color: greyColor),
        isCollapsed: true,
        isDense: true,
        filled: true,
        fillColor: backgroudColor,
        border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).dividerColor)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor)),
        contentPadding: const EdgeInsets.all(8),
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }


  Widget _bottomBar() {
    final Color titleColor = BZTheme.isDark(context) ? BZColor.darkTitle : BZColor.title;
    final Color amountColor = BZTheme.isDark(context) ? BZColor.darkAmount : BZColor.amount;
    return Material(
      child: Ink(
        width: double.infinity,
        height: 50 + BZSize.bottomBarHeight,
        padding: EdgeInsets.fromLTRB(12, 0, 12, BZSize.bottomBarHeight),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border(top: BorderSide(color: Theme.of(context).dividerColor, width: 0.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: AppLocalizations.of(context)!.totalAmount,
                    style: TextStyle(
                      fontSize: BZFontSize.title,
                      color: titleColor,
                    ),
                  ),
                  TextSpan(
                    text: _totalAmount,
                    style: TextStyle(
                      fontSize: BZFontSize.navTitle,
                      fontWeight: FontWeight.bold,
                      color: amountColor,
                    ),
                  ),
                ],
              ),
            ),
            BZTextButton(
              text: AppLocalizations.of(context)!.pay,
              style: const TextStyle(
                fontSize: BZFontSize.title,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
              width: 100,
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              gradient: const LinearGradient(colors: [BZColor.gradStart, BZColor.gradEnd]),
              radius: 18,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }


  Future _showItemListModal() {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      builder: (context) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _indicator(),
              const SizedBox(height: 12),
              _modalHeader(),
              const SizedBox(height: 12),
              ListView.separated(
                itemCount: _items.length,
                shrinkWrap: true,
                itemBuilder: (context, index) => _commodityTile(_items[index]),
                separatorBuilder: (context, index) => const Divider(height: 0, thickness: 0.5),
              ),
            ],
          ),
        );
      },
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


  Widget _modalHeader() {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: AppLocalizations.of(context)!.commodityList,
            style: TextStyle(
              fontSize: BZFontSize.title,
              fontWeight: FontWeight.bold,
              color: BZTheme.isDark(context) ? BZColor.darkTitle : BZColor.title,
            ),
          ),
          const WidgetSpan(child: SizedBox(width: 8)),
          TextSpan(
            text: '(${_items.length} ${AppLocalizations.of(context)!.items})',
            style: TextStyle(
              fontSize: BZFontSize.title,
              color: BZTheme.isDark(context) ? BZColor.darkGrey : BZColor.grey,
            ),
          ),
        ],
      ),
    );
  }


  Widget _commodityTile(ProductModel product) {
    Color titleColor = BZTheme.isDark(context) ? BZColor.darkTitle : BZColor.title;
    Color greyColor = BZTheme.isDark(context) ? BZColor.darkGrey : BZColor.grey;
    Color amountColor = BZTheme.isDark(context) ? BZColor.darkAmount : BZColor.amount;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            child: Image.network(product.imageUrl, fit: BoxFit.cover, width: 70, height: 70),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.title, maxLines: 2, style: TextStyle(fontSize: BZFontSize.title, color: titleColor)),
                const SizedBox(height: 4),
                Text(
                  'Hair Length: 24  4*4Lace Closeure Wig',
                  style: TextStyle(fontSize: BZFontSize.content, color: greyColor),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.currency + ' ' + product.realPriceFmt,
                      style: TextStyle(fontSize: BZFontSize.title, color: amountColor),
                    ),
                    Text('x1', style: TextStyle(fontSize: BZFontSize.title, color: titleColor)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}