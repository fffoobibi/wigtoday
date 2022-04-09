import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wigtoday_app/api/favorite.dart';
import 'package:wigtoday_app/app/home/models/product.dart';
import 'package:wigtoday_app/utils/color.dart';
import 'package:wigtoday_app/utils/font.dart';
import 'package:wigtoday_app/utils/size.dart';
import 'package:wigtoday_app/utils/theme.dart';
import 'package:wigtoday_app/widgets/button.dart';


class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final List<ProductModel> _favorites = ApiFavorite.getFavoriteList();
  List<bool> _selectedStates = [];
  bool _isEditing = false;
  bool _allSelected = false;
  int _selectedCount = 0;

  @override
  void initState() {
    _selectedStates.addAll(List.filled(_favorites.length, false));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double kBottomHeight = 48 + BZSize.bottomBarHeight;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.favorites),
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
        shrinkWrap: true,
        itemCount: _favorites.length,
        padding: EdgeInsets.fromLTRB(8, 8, 8, _isEditing ? kBottomHeight + 8 : 8),
        itemBuilder: (context, index) => _listTile(index),
      ),
      bottomSheet: Visibility(
        visible: _isEditing,
        maintainState: true,
        child: _bottomSheet(kBottomHeight),
      ),
    );
  }


  Widget _listTile(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Row(
        children: [
          Visibility(
            visible: _isEditing,
            maintainState: true,
            child: _checkbox(index),
          ),
          const SizedBox(width: 5),
          _imageBox(index),
          Expanded(child: _contentBox(index),),
        ],
      ),
    );
  }


  Widget _checkbox(int index) {
    Color lightColor = BZTheme.isDark(context) ? BZColor.darkLight : BZColor.light;
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      child: Checkbox(
        value: _selectedStates[index],
        activeColor: Theme.of(context).primaryColor,
        side: BorderSide(color: lightColor),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        onChanged: (val) => _checkOne(val, index),
      ),
    );
  }


  Widget _imageBox(int index) {
    ProductModel product = _favorites[index];
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(product.imageUrl, fit: BoxFit.cover, width: 70, height: 70),
    );
  }


  Widget _contentBox(int index) {
    ProductModel product = _favorites[index];
    Color titleColor = BZTheme.isDark(context) ? BZColor.darkTitle : BZColor.title;
    Color greyColor = BZTheme.isDark(context) ? BZColor.darkGrey : BZColor.grey;
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
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
          _prices(product),
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

  // 底部操作栏
  Widget _bottomSheet(double kBottomHeight) {
    return Ink(
      height: kBottomHeight,
      padding: EdgeInsets.fromLTRB(8, 8, 12, BZSize.bottomBarHeight),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(top: BorderSide(width: 0.5, color: Theme.of(context).dividerColor)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _allCheckbox(),
          _deleteButton(),
        ],
      ),
    );
  }


  Widget _allCheckbox() {
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
      _selectedStates = List.filled(_favorites.length, true);
      _selectedCount = _favorites.length;
    } else {
      _selectedStates = List.filled(_favorites.length, false);
      _selectedCount = 0;
    }
    setState(() {
      _selectedStates = _selectedStates;
      _selectedCount = _selectedCount;
      _allSelected = val ?? false;
    });
  }


  void _checkOne(bool? val, int index) {
    _selectedStates[index] = val ?? false;
    _selectedCount += (val ?? false) ? 1 : -1;
    if (_selectedCount == _favorites.length) {
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
