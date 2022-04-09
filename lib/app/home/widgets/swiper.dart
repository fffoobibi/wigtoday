import 'package:flutter/material.dart';

import 'package:wigtoday_app/utils/size.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';


class HomeSwiper extends StatelessWidget {
  final List<String> slides;
  final void Function(int) onTap;

  const HomeSwiper({
    Key? key,
    required this.slides,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double slideWidth = BZSize.pageWidth - 40;
    final double slideHeight = slideWidth * 0.5;
    return Container(
      width: BZSize.pageWidth,
      height: slideHeight,
      margin: const EdgeInsets.only(top: 8, bottom: 16),
      child: Swiper(
        itemCount: slides.length,
        layout: SwiperLayout.DEFAULT,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(slides[index], fit: BoxFit.cover, width: slideWidth, height: slideHeight,),
          );
        },
        pagination: const SwiperPagination(),
        autoplay: true,
        autoplayDelay: 5000,
        duration: 1000,
        viewportFraction: 0.85,
        scale: 0.92,
        onTap: (index) => onTap(index),
      ),
    );
  }
}
