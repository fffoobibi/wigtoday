import 'package:flutter/material.dart';
import 'package:wigtoday_app/api/cart.dart';

import 'package:wigtoday_app/utils/font.dart';
import 'package:wigtoday_app/utils/color.dart';
import 'package:wigtoday_app/utils/theme.dart';
import 'package:wigtoday_app/widgets/button.dart';
import 'package:wigtoday_app/utils/formatter.dart';
import 'package:wigtoday_app/app/cart/models/cart_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wigtoday_app/app/cart/widgets/cart_tile.dart';
import 'package:wigtoday_app/app/cart/pages/ordering_page.dart';


class CartPage extends StatefulWidget {
  const CartPage({ Key? key }) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final List<CartItemModel> _items = ApiCart.getCartList();
  List<bool> _selectedStates = [];
  bool _isEditing = false;
  bool _allSelected = false;
  int _selectedCount = 0;
  double _totalAmount = 0;
  String _currency = 'USD';

  @override
  void initState() {
    _selectedStates = List.filled(_items.length, false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const double kBottomHeight = 54;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.tabCartLabel),
        actions: [
          BZTextButton(
            text: _isEditing ? AppLocalizations.of(context)!.complete : AppLocalizations.of(context)!.edit,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            onTap: () {
              setState(() {
                _isEditing = !_isEditing;
              });
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, kBottomHeight + 8),
        shrinkWrap: true,
        itemCount: _items.length,
        itemBuilder: (context, index) => CartTile(
          item: _items[index],
          isSelected: _selectedStates[index],
          onSelected: (val) => _checkOne(val, index),
          onChanged: (val) {},
        ),
      ),
      bottomSheet: _bottomSheet(kBottomHeight),
    );
  }


  // 底部操作栏
  Widget _bottomSheet(double kBottomHeight) {
    return Ink(
      height: kBottomHeight,
      padding: const EdgeInsets.fromLTRB(8, 8, 12, 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(top: BorderSide(width: 0.5, color: Theme.of(context).dividerColor)),
      ),
      child: Row(
        children: [
          _checkbox(),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!_isEditing) _amountBox(),
                if (!_isEditing) _buyButton(),
                if (_isEditing) _deleteButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _checkbox() {
    Color lightColor = BZTheme.isDark(context) ? BZColor.darkLight : BZColor.light;
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => _checkAll(!_allSelected),
      child: Row(
        children: [
          Checkbox(
            value: _allSelected,
            activeColor: Theme.of(context).primaryColor,
            side: BorderSide(color: lightColor),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            onChanged: (val) => _checkAll(val),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Text(
              AppLocalizations.of(context)!.checkAll,
              style: TextStyle(
                fontSize: BZFontSize.subTitle,
                color: BZTheme.isDark(context) ? BZColor.darkTitle : BZColor.title,
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _amountBox() {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            AppLocalizations.of(context)!.totalAmount,
            style: TextStyle(
              fontSize: BZFontSize.content,
              color: BZTheme.isDark(context) ? BZColor.darkTitle : BZColor.title,
            ),
          ),
          Text(
            _currency + ' ' + amountFormat(_totalAmount),
            style: TextStyle(
              fontSize: BZFontSize.navTitle,
              color: BZTheme.isDark(context) ? BZColor.darkAmount : BZColor.amount,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buyButton() {
    return BZTextButton(
      text: AppLocalizations.of(context)!.buyNow + ' ($_selectedCount)',
      style: const TextStyle(
        fontSize: BZFontSize.title,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      height: 36,
      radius: 18,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      gradient: const LinearGradient(colors: [BZColor.gradStart, BZColor.gradEnd]),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderingPage()));
      },
    );
  }


  Widget _deleteButton() {
    Color dangerColor = BZTheme.isDark(context) ? BZColor.darkDanger : BZColor.danger;
    return BZTextButton(
      text: AppLocalizations.of(context)!.delete,
      style: TextStyle(
        fontSize: BZFontSize.title,
        fontWeight: FontWeight.bold,
        color: dangerColor,
      ),
      width: 90,
      height: 32,
      radius: 16,
      backgroundColor: Theme.of(context).cardColor,
      border: Border.all(color: dangerColor),
      onTap: () {},
    );
  }


  void _checkAll(bool? val) {
    if (val == true) {
      _selectedStates = List.filled(_items.length, true);
      _selectedCount = _items.length;
    } else {
      _selectedStates = List.filled(_items.length, false);
      _selectedCount = 0;
    }
    setState(() {
      _selectedStates = _selectedStates;
      _selectedCount = _selectedCount;
      _allSelected = val ?? false;
    });
  }


  void _checkOne(bool val, int index) {
    _selectedStates[index] = val;
    _selectedCount += val ? 1 : -1;
    if (_selectedCount == _items.length) {
      _allSelected = true;
    } else {
      _allSelected = false;
    }
    setState(() {
      _selectedCount = _selectedCount;
      _allSelected = _allSelected;
    });
  }
}