import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wigtoday_app/app/home/pages/product_detail_page.dart';

import 'package:wigtoday_app/utils/font.dart';
import 'package:wigtoday_app/utils/color.dart';
import 'package:wigtoday_app/utils/size.dart';
import 'package:wigtoday_app/utils/theme.dart';
import 'package:wigtoday_app/api/product.dart';
import 'package:wigtoday_app/widgets/button.dart';
import 'package:wigtoday_app/app/home/models/product.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wigtoday_app/app/home/widgets/product_card.dart';
import 'package:wigtoday_app/app/home/widgets/product_tile.dart';


class ProductListPage extends StatefulWidget {
  const ProductListPage({ Key? key }) : super(key: key);

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}


class _ProductListPageState extends State<ProductListPage> {
  final TextEditingController _controller = TextEditingController();
  final List<ProductModel> _products = ApiProduct.getYourSelectionProducts();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<ProductSizeModel> _sizes = [
    ProductSizeModel(
      title: 'Category',
      options: [
        {'id': 213, 'value': 'Women Wedges & Flatfo'},
        {'id': 214, 'value': 'Short hair'},
        {'id': 215, 'value': 'Curls'},
        {'id': 216, 'value': 'Long hair'},
      ],
    ),
    ProductSizeModel(
      title: 'Hair Length',
      options: [
        {'id': 213, 'value': '14 inch'},
        {'id': 214, 'value': '16 inch'},
        {'id': 215, 'value': '18 inch'},
        {'id': 216, 'value': '20 inch'},
        {'id': 217, 'value': '22 inch'},
        {'id': 218, 'value': '24 inch'},
        {'id': 219, 'value': '26 inch'},
      ],
    ),
  ];
  List<int> _selectedIndex = [];
  bool _isCardType = true;   // 产品展示方式 card/list
  bool _sortAsc = false;
  bool _typeAsc = false;
  double _rangeValueMin = 200;
  double _rangeValueMax = 800;

  @override
  void initState() {
    _selectedIndex = List.filled(_sizes.length, 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: (ModalRoute.of(context)?.canPop ?? false) ? const BackButton() : null,
        title: _searchBox(),
        centerTitle: false,
        titleSpacing: 0,
        elevation: 0,
        actions: [
          _searchBtn(),
          IconButton(
            icon: Icon(_isCardType ? CupertinoIcons.list_bullet : CupertinoIcons.square_grid_2x2, size: 18),
            onPressed: () {
              setState(() => _isCardType = !_isCardType);
            },
          )
        ],
      ),
      endDrawer: _filterDrawer(),
      body: Column(
        children: [
          _operationsBox(),
          Expanded(
            child: _isCardType ? _productCards() : _productList(),
          ),
        ],
      ),
    );
  }


  Widget _searchBox() {
    return TextField(
      controller: _controller,
      textInputAction: TextInputAction.search,
      style: TextStyle(
        fontSize: BZFontSize.title,
        color: BZTheme.isDark(context) ? BZColor.darkTitle : BZColor.title,
      ),
      decoration: InputDecoration(
        filled: true,
        isDense: true,
        isCollapsed: true,
        hintText: AppLocalizations.of(context)!.searchKeywords,
        hintStyle: Theme.of(context).textTheme.bodyText1,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }


  Widget _searchBtn() {
    return BZButton(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      radius: 12,
      child: Text(
        AppLocalizations.of(context)!.search,
        style: TextStyle(
          fontSize: BZFontSize.title,
          color: BZTheme.isDark(context) ? BZColor.darkSemi : BZColor.semi,
        ),
      ),
      onTap: () {},
    );
  }


  Widget _operationsBox() {
    Color titleColor = BZTheme.isDark(context) ? BZColor.darkTitle: BZColor.title;
    return Material(
      child: Ink(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).appBarTheme.backgroundColor,
          border: const Border(bottom: BorderSide(color: Colors.black12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BZTextButton(
              text: AppLocalizations.of(context)!.sort,
              foregroundColor: titleColor,
              height: 34,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              rightIcon: _sortAsc ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              onTap: () {
                setState(() => _sortAsc = !_sortAsc);
              },
            ),
            BZTextButton(
              text: AppLocalizations.of(context)!.color,
              foregroundColor: titleColor,
              height: 34,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              onTap: () {},
            ),
            BZTextButton(
              text: AppLocalizations.of(context)!.type,
              foregroundColor: titleColor,
              height: 34,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              rightIcon: _typeAsc ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              onTap: () {
                setState(() => _typeAsc = !_typeAsc);
              },
            ),
            BZTextButton(
              text: AppLocalizations.of(context)!.filter,
              foregroundColor: titleColor,
              height: 34,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              iconSize: 16,
              leftIcon: Icons.filter_alt_outlined,
              onTap: () {
                _scaffoldKey.currentState!.openEndDrawer();
              },
            ),
          ],
        ),
      ),
    );
  }


  Widget _productList() {
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 8, bottom: BZSize.bottomBarHeight + 8),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        return Ink(
          color: Theme.of(context).cardColor,
          child: ProductTile(
            product: _products[index],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductDetailPage(product: _products[index])),
              );
            },
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(height: 0),
    );
  }


  Widget _productCards() {
    const double padding = 12;
    final double cardWidth = (BZSize.pageWidth - 3 * padding) / 2;
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(padding, padding, padding, BZSize.bottomBarHeight + padding),
      child: Wrap(
        spacing: padding,
        runSpacing: padding,
        children: List.generate(
          _products.length,
          (index) => ProductCard(
            width: cardWidth,
            product: _products[index],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductDetailPage(product: _products[index])),
              );
            },
          ),
        ),
      ),
    );
  }


  Widget _filterDrawer() {
    return Drawer(
      child: Container(
        padding: EdgeInsets.fromLTRB(12, BZSize.statusBarHeight + kBottomNavigationBarHeight, 12, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...List.generate(_sizes.length, (index) => _sizeBox(_sizes[index], index)),
            _priceRange(AppLocalizations.of(context)!.priceRange)
          ],
        ),
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
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Wrap(
            spacing: 8,
            runSpacing: 12,
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
                  setState(() {
                    _selectedIndex[sizeIndex] = index;
                  });
                },
              );
            }),
          ),
        ),
      ],
    );
  }


  Widget _priceRange(String title) {
    Color semiColor = BZTheme.isDark(context) ? BZColor.darkSemi : BZColor.semi;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: BZFontSize.title,
            color: semiColor,
          ),
        ),
        const SizedBox(height: 12),
        RangeSlider(
          values: RangeValues(_rangeValueMin, _rangeValueMax),
          min: 0,
          max: 1000,
          divisions: 10,
          labels: RangeLabels('\$ $_rangeValueMin', '\$ $_rangeValueMax'),
          onChanged: (val) {
            setState(() {
              _rangeValueMin = val.start;
              _rangeValueMax = val.end;
            });
          },
        ),
      ],
    );
  }
}