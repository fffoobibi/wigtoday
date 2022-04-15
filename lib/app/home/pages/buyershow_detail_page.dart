import 'package:flutter/material.dart';

import 'package:wigtoday_app/utils/size.dart';
import 'package:wigtoday_app/utils/font.dart';
import 'package:wigtoday_app/utils/theme.dart';
import 'package:wigtoday_app/utils/color.dart';
import 'package:wigtoday_app/widgets/button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';


class BuyerShowDetailPage extends StatelessWidget {
  final List<String> imageUrls;
  final String? description;
  final bool isLiked;
  final int score;

  const BuyerShowDetailPage({
    Key? key,
    required this.imageUrls,
    this.description,
    this.isLiked = false,
    this.score = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.buyerShowDetail),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _swiper(),
            if (description != null) _descriptionBox(context),
            _buttonBox(context),
          ],
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
            itemCount: imageUrls.length,
            layout: SwiperLayout.DEFAULT,
            itemBuilder: (context, index) {
              return ClipRRect(
                child: Image.network(
                  imageUrls[index],
                  fit: BoxFit.cover,
                  width: slideWidth,
                  height: slideWidth,
                ),
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
            child: _scoreBox(),
          ),
        ],
      ),
    );
  }


  Widget _scoreBox() {
    return Container(
      width: BZSize.pageWidth,
      height: 40,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      color: const Color(0x55000000),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            score > 0 ? '★' * score : '☆',
            style: const TextStyle(
              fontSize: BZFontSize.title,
              color: Colors.white,
            ),
          ),
          Icon(
            isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
            size: 18,
            color: isLiked ? Colors.red : Colors.white,
          ),
        ],
      ),
    );
  }


  Widget _descriptionBox(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        description!,
        style: TextStyle(
          height: 1.5,
          fontSize: BZFontSize.title,
          color: BZTheme.isDark(context) ? BZColor.darkTitle : BZColor.title,
        ),
      ),
    );
  }


  Widget _buttonBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.center,
      child: Column(
        children: [
          BZTextButton(
            width: BZSize.pageWidth - 26,
            height: 38,
            radius: 8,
            border: Border.all(color: Theme.of(context).primaryColor),
            foregroundColor: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
            text: AppLocalizations.of(context)!.socialAccount,
            leftIcon: Icons.share,
            onTap: () {},
          ),
          const SizedBox(height: 20),
          BZTextButton(
            width: BZSize.pageWidth - 24,
            height: 40,
            radius: 8,
            gradient: const LinearGradient(colors: [BZColor.gradStart, BZColor.gradEnd]),
            foregroundColor: Colors.white,
            fontWeight: FontWeight.bold,
            text: AppLocalizations.of(context)!.shopNow,
            leftIcon: Icons.shopping_bag_outlined,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}