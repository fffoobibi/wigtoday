import 'dart:math';
import 'package:flutter/material.dart';
import 'package:wigtoday_app/app/home/pages/review_list_page.dart';

import 'package:wigtoday_app/utils/size.dart';
import 'package:wigtoday_app/utils/font.dart';
import 'package:wigtoday_app/utils/color.dart';
import 'package:wigtoday_app/utils/theme.dart';
import 'package:wigtoday_app/api/product.dart';
import 'package:wigtoday_app/widgets/button.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wigtoday_app/app/user/models/user.dart';
import 'package:wigtoday_app/app/home/models/review.dart';
import 'package:wigtoday_app/app/home/models/product.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wigtoday_app/app/home/widgets/cart_modal.dart';
import 'package:wigtoday_app/app/cart/pages/ordering_page.dart';
import 'package:wigtoday_app/app/home/widgets/review_tile.dart';
import 'package:wigtoday_app/app/home/widgets/mayneed_card.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
 

class ProductDetailPage extends StatefulWidget {
  final ProductModel product;
  const ProductDetailPage({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}


class _ProductDetailPageState extends State<ProductDetailPage> {
  final List<String> _slides = [
    'https://placeimg.com/600/600/any1',
    'https://placeimg.com/600/600/any12',
    'https://placeimg.com/600/600/any34',
    'https://placeimg.com/600/600/any56',
  ];
  final List<ProductModel> _mayNeeds = ApiProduct.getFlashSaleProducts();
  final List<ReviewModel> _reviews = [
    ReviewModel(
      id: 1,
      content: 'gbruei gito kji giogt griogthh jhtrej buoipope re gtrio gtrwgjewhorewi sf kioiowqe rjkl fieowqngrbe yrewhrnmbngde hew',
      author: UserModel(userId: 12, username: 'Macale Jackson', avatar: 'https://placeimg.com/80/80/any343'),
      createTime: 1645678564,
      score: 3,
      likeCount: 20,
      sizes: ['Hair Length: 24', 'Lace design: 4*4Lace Closure Wig'],
      imageUrls: [
        'https://placeimg.com/140/140/any1',
        'https://placeimg.com/140/140/4532',
        'https://placeimg.com/140/140/543',
        'https://placeimg.com/140/140/213',
      ],
    ),
    ReviewModel(
      id: 2,
      content: '你说他不行你型你上啊，你说他不行你型你上啊，你说他不行你型你上啊，你说他不行你型你上啊，你说他不行你型你上啊，你说他不行你型你上啊',
      author: UserModel(userId: 12, username: 'Macale Jackson', avatar: 'https://placeimg.com/80/80/rhh'),
      createTime: 1648088564,
      score: 4,
      likeCount: 10,
      isLiked: true,
      sizes: ['Hair Length: 24', 'Lace design: 4*4Lace'],
    ),
  ];
  double _navOpacity = 0;
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    _controller.addListener(() {
      if (_controller.offset <= 270) {
        setState(() {
          _navOpacity = min(_controller.offset / 260, 1);
        });
      } else if (_controller.offset > 270 && _navOpacity < 1) {
        setState(() {
          _navOpacity = 1;
        });
      }
    });
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
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _controller,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _swiper(),
                const SizedBox(height: 16),
                _productInfoBox(),
                const SizedBox(height: 16),
                _formBox(),
                const SizedBox(height: 16),
                _yourMayNeed(),
                const SizedBox(height: 16),
                _reviewsBox(),
                const SizedBox(height: 16),
                _descriptionBox(),
                SizedBox(height: 16 + 50 + BZSize.bottomBarHeight),
              ],
            ),
          ),
          Positioned(top: 0, left: 0, child: _navigationBar()),
        ]
      ),
      bottomSheet: _bottomBar(),
    );
  }


  Widget _navigationBar() {
    Color titleColor = BZTheme.isDark(context) ? BZColor.darkTitle : BZColor.title;
    return Opacity(
      opacity: _navOpacity,
      child: Material(
        child: Ink(
          width: BZSize.pageWidth,
          height: kBottomNavigationBarHeight + BZSize.statusBarHeight,
          padding: EdgeInsets.fromLTRB(4, BZSize.statusBarHeight, 4, 0),
          decoration: BoxDecoration(
            color: Theme.of(context).appBarTheme.backgroundColor,
            border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BackButton(),
              Text(
                AppLocalizations.of(context)!.commodityDetail,
                style: TextStyle(fontSize: BZFontSize.navTitle, color: titleColor),
              ),
              IconButton(
                icon: Icon(Icons.share, size: 20, color: titleColor),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _swiper() {
    final double slideWidth = BZSize.pageWidth;
    return SizedBox(
      width: slideWidth,
      height: slideWidth,
      child: Stack(
        children: [
          Swiper(
            itemCount: _slides.length,
            layout: SwiperLayout.DEFAULT,
            itemBuilder: (context, index) {
              return ClipRRect(
                child: Image.network(_slides[index], fit: BoxFit.cover, width: slideWidth, height: slideWidth,),
              );
            },
            pagination: const SwiperPagination(margin: EdgeInsets.only(bottom: 50)),
            autoplay: true,
            autoplayDelay: 5000,
            duration: 1000,
            onTap: (index) {},
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: _countdownBox(),
          ),
        ],
      ),
    );
  }


  Widget _countdownBox() {
    return Container(
      width: BZSize.pageWidth,
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      color: const Color(0x55000000),
      child: Row(
        children: [
          const Icon(Icons.flash_on, size: 18, color: Colors.white),
          const SizedBox(width: 5),
          Text(
            AppLocalizations.of(context)!.flashSale,
            style: const TextStyle(
              fontSize: BZFontSize.title,
              color: Colors.white
            ),
          ),
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.endIn + ' 08:33:43',
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: BZFontSize.title,
                color: Colors.white
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _productInfoBox() {
    final double discount = (1 - widget.product.realPrice / widget.product.rawPrice) * 100;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.product.title,
            maxLines: 2,
            style: TextStyle(
              fontSize: BZFontSize.title,
              fontWeight: FontWeight.bold,
              color: BZTheme.isDark(context) ? BZColor.darkTitle : BZColor.title,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Text.rich(
                TextSpan(
                  style: TextStyle(
                    color: BZTheme.isDark(context) ? BZColor.darkAmount : BZColor.amount,
                  ),
                  children: [
                    TextSpan(
                      text: widget.product.currency,
                      style: const TextStyle(fontSize: BZFontSize.navTitle, fontWeight: FontWeight.bold),
                    ),
                    const WidgetSpan(child: SizedBox(width: 3)),
                    TextSpan(
                      text: widget.product.realPriceFmt,
                      style: const TextStyle(fontSize: BZFontSize.big, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                widget.product.currency + widget.product.rawPriceFmt,
                style: TextStyle(
                  fontSize: BZFontSize.title,
                  color: BZTheme.isDark(context) ? BZColor.darkGrey : BZColor.grey,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: Text(
                  '- ${discount.toInt()}%',
                  style: const TextStyle(
                    fontSize: BZFontSize.content,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  '★★★★★☆☆☆☆☆'.substring(5 - widget.product.score, 10 - widget.product.score),
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: BZFontSize.title,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _formBox() {
    final Color titleColor = BZTheme.isDark(context) ? BZColor.darkTitle : BZColor.title;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          _formItem(0, AppLocalizations.of(context)!.selected, 'Red · Long · 16cm · x1', titleColor, () {}),
          const Divider(height: 0, thickness: 0.5,),
          _formItem(1, AppLocalizations.of(context)!.sendTo, '安徽 铜陵 义安区', titleColor, () {}),
        ],
      ),
    );
  }


  Widget _formItem(int index, String title, String value, Color titleColor, void Function()? onTap) {
    const Radius radius = Radius.circular(12);
    return Ink(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.vertical(
          top: index == 0 ? radius : Radius.zero,
          bottom: index == 1 ? radius : Radius.zero,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.vertical(
          top: index == 0 ? radius : Radius.zero,
          bottom: index == 1 ? radius : Radius.zero,
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: BZFontSize.title,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  value,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: BZFontSize.content,
                    color: titleColor,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.more_vert,
                size: 20,
                color: BZTheme.isDark(context) ? BZColor.darkArrow : BZColor.arrow,
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _yourMayNeed() {
    final Color titleColor = BZTheme.isDark(context) ? BZColor.darkTitle : BZColor.title;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              AppLocalizations.of(context)!.youMayNeed,
              style: TextStyle(fontSize: BZFontSize.title, fontWeight: FontWeight.bold, color: titleColor),
            ),
          ),
          _mayNeedList(),
        ],
      ),
    );
  }


  Widget _mayNeedList() {
    return Scrollbar(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 5),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            _mayNeeds.length,
            (index) => MayNeedCard(
              product: _mayNeeds[index],
              onSelected: (val) {},
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailPage(product: _mayNeeds[index])));
              },
            ),
          ),
        ),
      ),
    );
  }


  Widget _reviewsBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Ink(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _reviewsHeader(),
            _reviewsBtns(),
            ListView.separated(
              padding: const EdgeInsets.all(0),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _reviews.length,
              itemBuilder: (context, index) => ReviewTile(
                review: _reviews[index],
                onLike: (val) {},
              ),
              separatorBuilder: (context, index) => const Divider(height: 0),
            ),
          ],
        ),
      ),
    );
  }


  Widget _reviewsHeader() {
    final Color titleColor = BZTheme.isDark(context) ? BZColor.darkTitle : BZColor.title;
    final Color semiColor = BZTheme.isDark(context) ? BZColor.darkSemi : BZColor.semi;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 5, 0, 5),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor, width: 0.5)),
      ),
      child: Row(
        children: [
          Text(
            AppLocalizations.of(context)!.reviews,
            style: TextStyle(fontSize: BZFontSize.title, fontWeight: FontWeight.bold, color: titleColor),
          ),
          Expanded(
            child: Text(
              '（2000+）',
              style: TextStyle(fontSize: BZFontSize.content, color: semiColor),
            ),
          ),
          BZTextButton(
            text: AppLocalizations.of(context)!.viewMore,
            fontSize: BZFontSize.content,
            foregroundColor: titleColor,
            rightIcon: Icons.arrow_right,
            padding: const EdgeInsets.all(8),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReviewListPage()),
              );
            },
          ),
        ],
      ),
    );
  }


  Widget _reviewsBtns() {
    final Color titleColor = BZTheme.isDark(context) ? BZColor.darkTitle : BZColor.title;
    final Color lightColor = BZTheme.isDark(context) ? BZColor.darkLight : BZColor.light;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          BZTextButton(
            text: AppLocalizations.of(context)!.all,
            fontSize: BZFontSize.content,
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            onTap: () {},
          ),
          const SizedBox(width: 15),
          BZTextButton(
            text: AppLocalizations.of(context)!.photoComments,
            fontSize: BZFontSize.content,
            backgroundColor: Theme.of(context).cardColor,
            foregroundColor: titleColor,
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            border: Border.all(color: lightColor),
            onTap: () {},
          ),
          const SizedBox(width: 15),
          BZTextButton(
            text: AppLocalizations.of(context)!.likes,
            fontSize: BZFontSize.content,
            backgroundColor: Theme.of(context).cardColor,
            foregroundColor: titleColor,
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            border: Border.all(color: lightColor),
            onTap: () {},
          ),
        ],
      ),
    );
  }


  Widget _descriptionBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Ink(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor, width: 0.5))
              ),
              child: Text(
                AppLocalizations.of(context)!.description,
                style: TextStyle(
                  fontSize: BZFontSize.title,
                  fontWeight: FontWeight.bold,
                  color: BZTheme.isDark(context) ? BZColor.darkTitle : BZColor.title,
                ),
              ),
            ),
            Container(
              constraints: const BoxConstraints(minHeight: 100, maxHeight: 800),
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: const ColorFiltered(
                colorFilter: ColorFilter.mode(Color(0xaa000000), BlendMode.colorBurn),
                child: WebView(
                  initialUrl: 'https://www.baidu.com',
                  javascriptMode: JavascriptMode.unrestricted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _bottomBar() {
    final Color titleColor = BZTheme.isDark(context) ? BZColor.darkTitle : BZColor.title;
    final Color warnColor = BZTheme.isDark(context) ? BZColor.darkWarn : BZColor.warn;
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
            IconButton(
              icon: Icon(
                widget.product.isLiked ? Icons.favorite : Icons.favorite_outline,
                size: 24,
                color: widget.product.isLiked ? Theme.of(context).primaryColor : titleColor,
              ),
              onPressed: () {
                setState(() => widget.product.isLiked = !widget.product.isLiked);
              },
            ),
            IconButton(
              icon: Icon(Icons.shopping_cart_outlined, size: 24, color: titleColor),
              onPressed: () {},
            ),
            BZTextButton(
              text: AppLocalizations.of(context)!.addToCart,
              style: const TextStyle(fontSize: BZFontSize.title, color: Colors.white),
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              backgroundColor: warnColor,
              radius: 18,
              onTap: () => _showCart(),
            ),
            BZTextButton(
              text: AppLocalizations.of(context)!.buyNow,
              style: const TextStyle(fontSize: BZFontSize.title, color: Colors.white),
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              gradient: const LinearGradient(colors: [BZColor.gradStart, BZColor.gradEnd]),
              radius: 18,
              onTap: () => _showCart(),
            ),
          ],
        ),
      ),
    );
  }


  Future _showCart() {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      builder: (context) => CartModal(
        product: widget.product,
        onAddCart: () {
          Navigator.pop(context);
        },
        onBuyNow: () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (ctx) => const OrderingPage()));
        },
      ),
    );
  }
}