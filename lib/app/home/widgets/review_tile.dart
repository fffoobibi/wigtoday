import 'package:flutter/material.dart';

import 'package:wigtoday_app/utils/font.dart';
import 'package:wigtoday_app/utils/color.dart';
import 'package:wigtoday_app/utils/theme.dart';
import 'package:wigtoday_app/app/home/models/review.dart';
import 'package:wigtoday_app/widgets/button.dart';


class ReviewTile extends StatelessWidget {
  final ReviewModel review;
  const ReviewTile({
    Key? key,
    required this.review,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color titleColor = BZTheme.isDark(context) ? BZColor.darkTitle : BZColor.title;
    Color semiColor = BZTheme.isDark(context) ? BZColor.darkSemi : BZColor.semi;
    Color greyColor = BZTheme.isDark(context) ? BZColor.darkGrey : BZColor.grey;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipOval(child: Image.network(review.author.avatar, fit: BoxFit.cover, width: 40, height: 40)),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review.author.username,
                    style: TextStyle(fontSize: BZFontSize.title, fontWeight: FontWeight.w500, color: titleColor),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    review.createTimeFmt,
                    style: TextStyle(fontSize: BZFontSize.min, color: greyColor),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '★★★★★☆☆☆☆☆'.substring(5 - review.score, 10 - review.score),
                  style: TextStyle(fontSize: BZFontSize.title, color: Theme.of(context).primaryColor),
                ),
              ),
              BZTextButton(
                text: '${review.likeCount}',
                leftIcon: review.isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                foregroundColor: review.isLiked ? Theme.of(context).primaryColor : titleColor,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text.rich(
            TextSpan(
              children: List.generate(review.sizes.length, (index) => TextSpan(text: review.sizes[index] + '\t')),
            ),
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: BZFontSize.content, color: semiColor),
          ),
          const SizedBox(height: 5),
          Text(
            review.content,
            style: TextStyle(fontSize: BZFontSize.title, color: titleColor),
          ),
          if (review.imageUrls.isNotEmpty) const SizedBox(height: 5),
          if (review.imageUrls.isNotEmpty) Wrap(
            spacing: 8,
            children: List.generate(review.imageUrls.length, (index) => ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(review.imageUrls[index], fit: BoxFit.cover, width: 70, height: 70),
            )),
          ),
        ],
      ),
    );
  }
}