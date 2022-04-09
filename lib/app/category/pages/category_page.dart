import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:wigtoday_app/utils/font.dart';
import 'package:wigtoday_app/utils/size.dart';
import 'package:wigtoday_app/utils/theme.dart';
import 'package:wigtoday_app/utils/color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wigtoday_app/app/home/pages/search_page.dart';
import 'package:wigtoday_app/app/category/models/category.dart';


class CategoryPage extends StatefulWidget {
  const CategoryPage({ Key? key }) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final List<CategoryModel> _categories = const [
    CategoryModel(
      id: 1,
      name: 'Human Hair Wigs',
      subcategories: [
        CategoryModel(id: 101, name: 'Texture & Style', parentId: 1),
        CategoryModel(id: 102, name: 'Lace design & Cap construction', parentId: 1),
        CategoryModel(id: 103, name: 'Hair density', parentId: 1),
        CategoryModel(id: 104, name: 'Hair color', parentId: 1),
      ],
    ),
    CategoryModel(
      id: 2,
      name: 'Human Hair Weave',
      subcategories: [
        CategoryModel(id: 201, name: 'Texture & Style', parentId: 2),
        CategoryModel(id: 202, name: 'Color', parentId: 2),
        CategoryModel(id: 203, name: 'Bundle packages', parentId: 2),
      ],
    ),
    CategoryModel(
      id: 3,
      name: 'Human Hair Lace Closure',
      subcategories: [
        CategoryModel(id: 301, name: 'Texture', parentId: 3),
        CategoryModel(id: 302, name: 'Color', parentId: 3),
      ],
    ),
    CategoryModel(
      id: 4,
      name: 'Synthetic Hair Wigs',
      subcategories: [
        CategoryModel(id: 401, name: 'Cosplay Wigs', parentId: 4),
        CategoryModel(id: 402, name: 'Fashion Wigs', parentId: 4),
      ],
    ),
    CategoryModel(
      id: 5,
      name: 'Cosplay',
      subcategories: [
        CategoryModel(id: 501, name: 'Cosplay Wigs', parentId: 5),
        CategoryModel(id: 502, name: 'Cosplay Costumes', parentId: 5),
        CategoryModel(id: 503, name: 'Sexy Costumes', parentId: 5),
        CategoryModel(id: 504, name: 'Colored Contacts', parentId: 5),
        CategoryModel(id: 505, name: 'Contact Lens Case', parentId: 5),
        CategoryModel(id: 506, name: 'Boots', parentId: 5),
        CategoryModel(id: 507, name: 'Cosplay Socks', parentId: 5),
      ],
    ),
    CategoryModel(
      id: 6,
      name: 'Beauty & Health',
      subcategories: [
        CategoryModel(id: 601, name: 'Makeup Tools', parentId: 6),
      ],
    ),
    CategoryModel(id: 7, name: 'Hot Deals'),
    CategoryModel(id: 8, name: 'New In'),
    CategoryModel(
      id: 9,
      name: 'Accessories',
      subcategories: [
        CategoryModel(id: 901, name: 'Wig Accessories', parentId: 9),
        CategoryModel(id: 902, name: 'Hair Clips and Hair Bands', parentId: 9),
        CategoryModel(id: 903, name: 'Necklace', parentId: 9),
        CategoryModel(id: 904, name: 'Earring', parentId: 9),
      ],
    ),
    CategoryModel(
      id: 10,
      name: 'Festive Products',
      subcategories: [
        CategoryModel(id: 1001, name: 'Halloween', parentId: 10),
        CategoryModel(id: 1002, name: 'Christmas', parentId: 10),
      ],
    ),
  ];

  final double _sideWidth = 120;

  int _selectedIndex = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.search, size: 20,),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchPage()));
          },
        ),
        title: Text(AppLocalizations.of(context)!.tabCategoryLabel),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: _sideWidth,
            height: BZSize.pageHeight - BZSize.statusBarHeight - kToolbarHeight - BZSize.bottomBarHeight - kBottomNavigationBarHeight,
            child: _sideMenu(),
          ),
          Expanded(
            child: _contentBox(),
          ),
        ],
      ),
    );
  }


  Widget _sideMenu() {
    Color semiColor = BZTheme.isDark(context) ? BZColor.darkSemi : BZColor.semi;

    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        return ListTile(
          dense: true,
          selected: index == _selectedIndex,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          title: Text(
            _categories[index].name,
            style: TextStyle(
              fontSize: BZFontSize.subTitle,
              fontWeight: FontWeight.w500,
              color: index == _selectedIndex ? Theme.of(context).primaryColor : semiColor,
            ),
          ),
          onTap: () {
            setState(() {
              _selectedIndex = index;
            });
          },
        );
      },
    );
  }


  Widget _contentBox() {
    CategoryModel item = _categories[_selectedIndex];
    int subCount = item.subcategories == null ? 1 : item.subcategories!.length;
    const double padding = 12;
    const double spacing = 8;

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(0, 0, padding, padding),
      shrinkWrap: true,
      itemCount: subCount,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(top: padding),
          child: Ink(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _contentItemHeader(item, index, padding),
                _contentItemList(item, index, padding, spacing),
              ],
            ),
          ),
        );
      },
    );
  }


  Widget _contentItemHeader(CategoryModel item, int index, double padding) {
    Color titleColor = BZTheme.isDark(context) ? BZColor.darkTitle : BZColor.title;
    Color arrowColor = BZTheme.isDark(context) ? BZColor.darkArrow : BZColor.arrow;

    return InkWell(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              item.subcategories == null ? item.name : item.subcategories![index].name,
              style: TextStyle(fontSize: BZFontSize.subTitle, fontWeight: FontWeight.w500, color: titleColor),
            ),
            Icon(Icons.chevron_right, size: 20, color: arrowColor),
          ],
        ),
      ),
      onTap: () {},
    );
  }


  Widget _contentItemList(CategoryModel item, int index, double padding, double spacing) {
    final double width = (BZSize.pageWidth - _sideWidth - padding * 3 - spacing * 2) / 3;

    return Padding(
      padding: EdgeInsets.fromLTRB(padding, 5, padding, 12),
      child: Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: List.generate(10, (index) => Container(
          width: width,
          height: width,
          decoration: BoxDecoration(
            color: Theme.of(context).dividerColor,
            borderRadius: const BorderRadius.all(Radius.circular(8))
          ),
        )),
      ),
    );
  }
}