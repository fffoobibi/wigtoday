import 'package:flutter/material.dart';
import 'package:wigtoday_app/api/product.dart';

import 'package:wigtoday_app/utils/font.dart';
import 'package:wigtoday_app/utils/color.dart';
import 'package:wigtoday_app/utils/size.dart';
import 'package:wigtoday_app/utils/theme.dart';
import 'package:wigtoday_app/widgets/button.dart';
import 'package:wigtoday_app/app/home/models/product.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wigtoday_app/app/home/widgets/product_card.dart';


class SearchPage extends StatefulWidget {
  const SearchPage({ Key? key }) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  final TextEditingController _controller = TextEditingController();
  final List<String> _recents = ['hair', 'wigs', 'grey', 'Himiko', 'Cosplay'];
  final List<ProductModel> _hots = ApiProduct.getYourSelectionProducts();
  final List<ProductModel> _results = ApiProduct.getYourSelectionProducts();
  bool _isSearching = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _searchBox(),
        centerTitle: false,
        titleSpacing: 0,
        actions: [_searchBtn(),],
      ),
      body: SingleChildScrollView(
        child: _isSearching ?
        _resultBox() :
        Column(children: List.generate(3, (index) => _section(index))),
      ),
    );
  }

  // 搜索框
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
      onTap: () {
        setState(() {
          _isSearching = !_isSearching;
        });
      },
    );
  }


  Widget _section(int index) {
    List<String> titles = [
      AppLocalizations.of(context)!.recentSearch,
      AppLocalizations.of(context)!.discovery,
      AppLocalizations.of(context)!.hotSearch,
    ];
    List<Widget> widgets = [_recently(), _discovery(), _hotSearch()];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          trailing: index == 0 ?
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {},
          ) : null,
          title: Text(titles[index], style: const TextStyle(fontSize: BZFontSize.title)),
        ),
        widgets[index],
      ],
    );
  }

  // 最近搜索
  Widget _recently() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Wrap(
        spacing: 8,
        children: _recents.map((e) {
          return ActionChip(
            label: Text(
              e,
              style: TextStyle(
                color: BZTheme.isDark(context) ? BZColor.darkTitle : BZColor.title,
              ),
            ),
            onPressed: () {},
            pressElevation: 4,
            shadowColor: Theme.of(context).shadowColor,
            padding: Theme.of(context).chipTheme.padding,
            backgroundColor: Theme.of(context).dividerColor,
          );
        }).toList(),
      ),
    );
  }

  // 发现
  Widget _discovery() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
    );
  }

  // 热搜
  Widget _hotSearch() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _hots.length,
      itemBuilder: (ctx, index) {
        return _productTile(index);
      },
    );
  }


  Widget _productTile(int index) {
    ProductModel model = _hots[index];
    List<Color> colors = const [
      Color(0xfff2b03f),
      Color(0xffbcbcbc),
      Color(0xffba8e62),
      Color(0xfff7923a),
    ];
    return ListTile(
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${index + 1}',
            style: TextStyle(
              fontSize: BZFontSize.navTitle,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              color: index < 3 ? colors[index] : colors[3],
            ),
          ),
          const SizedBox(width: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(model.imageUrl, fit: BoxFit.cover, width: 50, height: 50,),
          ),
        ],
      ),
      title: Text(
        model.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: BZFontSize.content,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        model.currency + ' ' + model.realPriceFmt,
        style: TextStyle(
          fontSize: BZFontSize.content,
          fontWeight: FontWeight.bold,
          color: BZTheme.isDark(context) ? BZColor.darkAmount : BZColor.amount,
        ),
      ),
      onTap: () {},
    );
  }


  Widget _resultBox() {
    const double padding = 12;
    final double cardWidth = (BZSize.pageWidth - padding * 3) / 2;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: padding),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.searchResults,
            style: TextStyle(
              fontSize: BZFontSize.title,
              color: BZTheme.isDark(context) ? BZColor.darkSemi : BZColor.semi,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: BZSize.pageWidth,
            child: Wrap(
              spacing: padding,
              runSpacing: padding,
              children: List.generate(_results.length, (index) => ProductCard(product: _results[index], width: cardWidth)),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}