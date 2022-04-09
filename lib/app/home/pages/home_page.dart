import 'dart:math' show sqrt, pi;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:wigtoday_app/utils/font.dart';
import 'package:wigtoday_app/utils/size.dart';
import 'package:wigtoday_app/utils/color.dart';
import 'package:wigtoday_app/utils/theme.dart';
import 'package:wigtoday_app/api/product.dart';
import 'package:wigtoday_app/widgets/button.dart';
import 'package:wigtoday_app/app/home/models/product.dart';
import 'package:wigtoday_app/app/home/widgets/swiper.dart';
import 'package:wigtoday_app/app/home/widgets/banner.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wigtoday_app/app/home/pages/search_page.dart';
import 'package:wigtoday_app/app/home/widgets/countdown.dart';
import 'package:wigtoday_app/app/user/pages/favorites_page.dart';
import 'package:wigtoday_app/app/home/widgets/product_card.dart';
import 'package:wigtoday_app/app/home/widgets/product_tile.dart';
import 'package:wigtoday_app/app/home/pages/product_list_page.dart';
import 'package:wigtoday_app/app/home/pages/product_detail_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  final List<String> _slides = [
    'https://placeimg.com/600/300/any1',
    'https://placeimg.com/600/300/any5',
    'https://placeimg.com/600/300/any10',
    'https://placeimg.com/600/300/any50',
  ];
  final List<ProductModel> _offProducts = ApiProduct.getFlashSaleProducts();
  final List<ProductModel> _yourSelections = ApiProduct.getYourSelectionProducts();

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
        title: Image.asset('assets/images/logo_title.png', height: 40, fit: BoxFit.fill,),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.ellipses_bubble, size: 20,),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const FavoritesPage()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            HomeSwiper(
              slides: _slides,
              onTap: (index) {},
            ),
            _categoriesGrid(),
            const SizedBox(height: 16,),
            _moduleBanners(),
            const SizedBox(height: 16,),
            _activity(),
            const SizedBox(height: 16,),
            _offSection(),
            const SizedBox(height: 16,),
            _yourSelection(),
            const SizedBox(height: 16,),
            _buyerShow(),
            const SizedBox(height: 16,),
          ],
        ),
      ),
    );
  }

  // 分类
  Widget _categoriesGrid() {
    final List<String> gridImages = [
      'Hot-sale.png',
      'New.png',
      'Show.png',
      'Partner.png',
      'Hair-Weave.png',
      'Beauty-&-Health.png',
      'Accessories.png',
      'All.png',
    ];
    final List<String> gridLabels = [
      AppLocalizations.of(context)!.hotSale,
      AppLocalizations.of(context)!.news,
      AppLocalizations.of(context)!.show,
      AppLocalizations.of(context)!.partner,
      AppLocalizations.of(context)!.hairWeave,
      AppLocalizations.of(context)!.beautyAndHealth,
      AppLocalizations.of(context)!.accessories,
      AppLocalizations.of(context)!.all,
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Ink(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: Wrap(
          children: List.generate(8, (index) => _gridItem(
            image: gridImages[index],
            label: gridLabels[index]),
          ),
        ),
      ),
    );
  }


  Widget _gridItem({required String image, required String label}) {
    final double width = (BZSize.pageWidth - 32) / 4;
    const double radius = 12;
    return Ink(
      width: width,
      height: width / 1.1,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(radius))
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductListPage()));
        },
        borderRadius: BorderRadius.circular(radius),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icons/$image', width: 40, height: 40, fit: BoxFit.cover,),
            const SizedBox(height: 5,),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: BZFontSize.content,
                color: BZTheme.isDark(context) ? BZColor.darkTitle : BZColor.title,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 模块
  Widget _moduleBanners() {
    const double margin = 8;
    const double padding = 12;
    final double width = (BZSize.pageWidth - padding * 3 - margin * 2) / 2;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: margin,),
      padding: const EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Row(
        children: [
          HomeBanner(
            width: width,
            height: width,
            imageUrl: 'https://placeimg.com/300/300/f',
            onTap: () {},
          ),
          const SizedBox(width: padding,),
          Column(
            children: [
              HomeBanner(
                width: width,
                height: (width - padding) / 2,
                imageUrl: 'https://placeimg.com/300/146/d',
                onTap: () {},
              ),
              const SizedBox(height: padding,),
              HomeBanner(
                width: width,
                height: (width - padding) / 2,
                imageUrl: 'https://placeimg.com/300/146/h',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 活动区
  Widget _activity() {
    const double margin = 8;
    return Ink(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: InkWell(
        onTap: () {},
        child: Image.asset('assets/images/banner.png', width: BZSize.pageWidth - 2 * margin, fit: BoxFit.cover,),
      ),
    );
  }

  // 优惠限购商品列表
  Widget _offSection() {
    const double bannerWidth = 100; // 斜条幅宽度
    const double bannerHeight = 20; // 斜条幅高度
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Stack(
        children: [
          Ink(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            child: Column(
              children: [
                _offSectionHeader(bannerWidth / 2),
                _cardList(),
              ],
            ),
          ),
          _offSkewPiece(bannerWidth, bannerHeight),
        ],
      ),
    );
  }

  // 斜角横幅
  Widget _offSkewPiece(double width, double height) {
    const double bannerAngle = -pi / 6; // 旋转角度 -30°，调整后要重新计算定位偏移量
    return Positioned(
      left: -height / 2,
      top: width / 2 - height * sqrt(3) / 2,
      child: Transform.rotate(
        angle: bannerAngle,
        alignment: Alignment.topLeft,
        child: Container(
          width: width,
          height: height,
          padding: EdgeInsets.only(left: height / sqrt(3), right: height * sqrt(3)),
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: <Color>[BZColor.gradStart, BZColor.gradEnd]),
          ),
          child: const Text(
            '70% OFF',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: BZFontSize.content,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }


  Widget _offSectionHeader(double height) {
    final Color titleColor = BZTheme.isDark(context) ? BZColor.darkTitle : BZColor.title;
    return SizedBox(
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.flashSale,
            style: TextStyle(
              fontSize: BZFontSize.navTitle,
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
          ),
          const SizedBox(width: 8,),
          Text(
            AppLocalizations.of(context)!.endIn,
            style: TextStyle(
              fontSize: BZFontSize.navTitle,
              color: titleColor,
            ),
          ),
          const SizedBox(width: 8,),
          BZCountdown(endTime: DateTime.now().add(const Duration(days: 1)),),
        ],
      ),
    );
  }


  Widget _cardList() {
    return Scrollbar(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 16),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            _offProducts.length,
            (index) => ProductCard(
              product: _offProducts[index],
              hasShadow: true,
              hasCartBtn: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductDetailPage(product: _offProducts[index])),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // 推荐的商品列表
  Widget _yourSelection() {
    return ClipRRect(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Ink(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          child: Column(
            children: [
              _yourSelectionHeader(),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _yourSelections.length,
                itemBuilder: (context, index) {
                  return ProductTile(
                    product: _yourSelections[index],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProductDetailPage(product: _yourSelections[index])),
                      );
                    },
                  );
                },
                separatorBuilder: (context, index) => const Divider(height: 0, indent: 12, endIndent: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _yourSelectionHeader() {
    final Color titleColor = BZTheme.isDark(context) ? BZColor.darkTitle : BZColor.title;
    return Container(
      height: 50,
      padding: const EdgeInsets.only(left: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(CupertinoIcons.checkmark_seal, size: 18, color: Theme.of(context).primaryColor,),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.forYourSelection,
              style: TextStyle(
                fontSize: BZFontSize.navTitle,
                fontWeight: FontWeight.bold,
                color: titleColor,
              ),
            ),
          ),
          BZTextButton(
            text: AppLocalizations.of(context)!.viewMore,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            radius: 4,
            fontSize: BZFontSize.content,
            foregroundColor: titleColor,
            rightIcon: Icons.chevron_right,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProductListPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  // 买家秀
  Widget _buyerShow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Ink(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: Column(
          children: [
            _buyerShowHeader(),
            _buyShowGrids(),
          ],
        ),
      ),
    );
  }


  Widget _buyerShowHeader() {
    final Color titleColor = BZTheme.isDark(context) ? BZColor.darkTitle : BZColor.title;
    return Ink(
      height: 50,
      padding: const EdgeInsets.only(left: 12),
      child: Row(
        children: [
          Icon(CupertinoIcons.camera, size: 18, color: Theme.of(context).primaryColor,),
          const SizedBox(width: 8),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: AppLocalizations.of(context)!.buyersShow,
                    style: TextStyle(
                      fontSize: BZFontSize.navTitle,
                      fontWeight: FontWeight.bold,
                      color: titleColor,
                    ),
                  ),
                  const WidgetSpan(child: SizedBox(width: 5,)),
                  TextSpan(
                    text: AppLocalizations.of(context)!.comeAndShare,
                    style: TextStyle(
                      fontSize: BZFontSize.min,
                      color: titleColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          BZTextButton(
            text: AppLocalizations.of(context)!.viewMore,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            radius: 4,
            fontSize: BZFontSize.content,
            foregroundColor: titleColor,
            rightIcon: Icons.chevron_right,
            onTap: () {},
          ),
        ],
      ),
    );
  }


  Widget _buyShowGrids() {
    const double margin = 8;
    const double padding = 12;
    final double width = (BZSize.pageWidth - padding * 3 - margin * 2);
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Column(
        children: [
          Row(
            children: [
              _buyerShowItem(width * 0.6, width * 0.6, 'https://placeimg.com/400/400/any23'),
              const SizedBox(width: 12),
              Column(
                children: [
                  _buyerShowItem(width * 0.4, width * 0.3 - 6, 'https://placeimg.com/300/200/any55'),
                  const SizedBox(height: 12),
                  _buyerShowItem(width * 0.4, width * 0.3 - 6, 'https://placeimg.com/300/200/any67'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buyerShowItem(width * 0.5, width * 0.5, 'https://placeimg.com/300/300/any12'),
              const SizedBox(width: 12),
              _buyerShowItem(width * 0.5, width * 0.5, 'https://placeimg.com/300/300/any45'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buyerShowItem(width * 0.5, width * 0.5, 'https://placeimg.com/300/300/any54'),
              const SizedBox(width: 12),
              _buyerShowAction(width * 0.5, width * 0.5, 'https://placeimg.com/300/300/any78'),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buyerShowItem(double width, double height, String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(imageUrl, width: width, height: height, fit: BoxFit.cover,),
    );
  }


  Widget _buyerShowAction(double width, double height, String imageUrl) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(imageUrl, width: width, height: height, fit: BoxFit.cover,),
        ),
        InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          child: Container(
            width: width,
            height: height,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: Color(0x99000000),
            ),
            alignment: Alignment.center,
            child: const Icon(CupertinoIcons.camera, size: 36, color: Colors.white,),
          ),
          onTap: () {},
        ),
      ],
    );
  }
}