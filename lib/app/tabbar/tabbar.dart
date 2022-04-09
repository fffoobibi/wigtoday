import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:wigtoday_app/utils/font.dart';
import 'package:wigtoday_app/app/cart/pages/cart_page.dart';
import 'package:wigtoday_app/app/home/pages/home_page.dart';
import 'package:wigtoday_app/app/user/pages/user_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wigtoday_app/app/category/pages/category_page.dart';


class BZTabBar extends StatefulWidget {
  const BZTabBar({ Key? key }) : super(key: key);

  @override
  State<BZTabBar> createState() => _BZTabBarState();
}


class _BZTabBarState extends State<BZTabBar> {
  // 页面数组
  final List<Widget> _pages = const [
    HomePage(),
    CategoryPage(),
    CartPage(),
    UserPage(),
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.bag),
            activeIcon: const Icon(CupertinoIcons.bag_fill),
            label: AppLocalizations.of(context)!.tabHomeLabel,
          ),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.square_grid_2x2),
            activeIcon: const Icon(CupertinoIcons.square_grid_2x2_fill),
            label: AppLocalizations.of(context)!.tabCategoryLabel,
          ),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.cart),
            activeIcon: const Icon(CupertinoIcons.cart_fill),
            label: AppLocalizations.of(context)!.tabCartLabel,
          ),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.person),
            activeIcon: const Icon(CupertinoIcons.person_fill),
            label: AppLocalizations.of(context)!.tabUserLabel,
          ),
        ],
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: BZFontSize.min,
        unselectedFontSize: BZFontSize.min,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
      ),
    );
  }
}