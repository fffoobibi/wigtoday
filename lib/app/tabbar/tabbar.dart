import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:wigtoday_app/app/user/models/user_cache.dart';
import 'package:wigtoday_app/utils/event_bus.dart';

import 'package:wigtoday_app/utils/font.dart';
import 'package:wigtoday_app/app/cart/pages/cart_page.dart';
import 'package:wigtoday_app/app/home/pages/home_page.dart';
import 'package:wigtoday_app/app/user/pages/user_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wigtoday_app/app/category/pages/category_page.dart';

// ignore: must_be_immutable
class BZTabBar extends StatefulWidget {
  UserCacheModel? cacheModel;
  BZTabBar({Key? key, required this.cacheModel}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<BZTabBar> createState() => _BZTabBarState(cacheModel: cacheModel);
}

class _BZTabBarState extends State<BZTabBar>
    with AutomaticKeepAliveClientMixin {
  UserCacheModel? cacheModel;


  _BZTabBarState({required this.cacheModel});

  late int _currentIndex;
  late List<Widget> _pages;
  late PageController _controller;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomePage(),
      const CategoryPage(),
      const CartPage(),
      UserPage(userCache: cacheModel),
    ];
    _currentIndex = 0;
    _controller = PageController(initialPage: 0);
  }

  void onPageChanged(int index) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: PageView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _pages.length,
          controller: _controller,
          itemBuilder: (context, index) {
            return _pages[index];
          },
          onPageChanged: onPageChanged),
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
          _controller.jumpToPage(index);
        },
      ),
    );
  }
}
