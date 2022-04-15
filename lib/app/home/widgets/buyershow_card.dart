import 'package:flutter/material.dart';

import 'package:wigtoday_app/utils/font.dart';
import 'package:wigtoday_app/utils/size.dart';

const double gap = 12;
double width = (BZSize.pageWidth - gap * 3) / 2;


class BuyerShowCard extends StatelessWidget {
  final String imageUrl;
  final String? description;
  final int score;
  final bool isLiked;
  final VoidCallback? onTap;
  const BuyerShowCard({
    Key? key,
    required this.imageUrl,
    this.description,
    this.isLiked = false,
    this.score = 0,
    this.onTap,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Stack(
        children: [
          _card(),
          Positioned(
            left: 0,
            bottom: 0,
            width: width,
            child: Container(
              padding: const EdgeInsets.fromLTRB(8, 3, 8, 5),
              decoration: const BoxDecoration(
                color: Color(0x55000000),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
              ),
              child: _infoBox(context),
            ),
          ),
        ],
      ),
    );
  }


  Widget _card() {
    return Card(
      margin: const EdgeInsets.all(0),
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Image.network(imageUrl, fit: BoxFit.cover, width: width, height: width),
    );
  }


  Widget _infoBox(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
        const SizedBox(height: 2),
        Visibility(
          visible: description != null,
          child: Text(
            description ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: BZFontSize.subTitle,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
