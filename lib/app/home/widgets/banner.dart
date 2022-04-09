import 'package:flutter/material.dart';
import 'package:wigtoday_app/utils/font.dart';


class HomeBanner extends StatelessWidget {
  final double width;
  final double height;
  final String imageUrl;
  final void Function() onTap;
  const HomeBanner({
    Key? key,
    required this.width,
    required this.height,
    required this.imageUrl,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const List<Color> colors = [
      Color(0xffff7b59),
      Color(0xffff0f47),
    ];
    const double btnWidth = 60;
    const double btnHeight = 26;

    return InkWell(
      onTap: onTap,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              width: width,
              height: height,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            left: 10,
            top: width == height ? (width - btnHeight) / 2 : height / 2,
            child: Container(
              width: btnWidth,
              height: btnHeight,
              child: const Center(
                child: Text(
                  'GO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: BZFontSize.title,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: colors),
                borderRadius: BorderRadius.all(Radius.circular(btnHeight / 2)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}