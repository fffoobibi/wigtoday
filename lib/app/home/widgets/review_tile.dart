import 'package:flutter/material.dart';

import 'package:wigtoday_app/utils/font.dart';
import 'package:wigtoday_app/utils/color.dart';
import 'package:wigtoday_app/utils/theme.dart';
import 'package:wigtoday_app/app/home/models/review.dart';
import 'package:wigtoday_app/widgets/button.dart';


class ReviewTile extends StatefulWidget {
  final ReviewModel review;
  final void Function(bool)? onLike;
  const ReviewTile({
    Key? key,
    required this.review,
    this.onLike,
  }) : super(key: key);

  @override
  State<ReviewTile> createState() => _ReviewTileState();
}

class _ReviewTileState extends State<ReviewTile> {
  late bool _isLiked;

  @override
  void initState() {
    _isLiked = widget.review.isLiked;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color titleColor = BZTheme.isDark(context) ? BZColor.darkTitle : BZColor.title;
    Color semiColor = BZTheme.isDark(context) ? BZColor.darkSemi : BZColor.semi;
    Color greyColor = BZTheme.isDark(context) ? BZColor.darkGrey : BZColor.grey;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      color: Theme.of(context).cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipOval(child: Image.network(widget.review.author.avatar, fit: BoxFit.cover, width: 40, height: 40)),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.review.author.username,
                    style: TextStyle(fontSize: BZFontSize.title, fontWeight: FontWeight.w500, color: titleColor),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    widget.review.createTimeFmt,
                    style: TextStyle(fontSize: BZFontSize.min, color: greyColor),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '★★★★★☆☆☆☆☆'.substring(5 - widget.review.score, 10 - widget.review.score),
                  style: TextStyle(fontSize: BZFontSize.title, color: Theme.of(context).primaryColor),
                ),
              ),
              BZTextButton(
                text: '${widget.review.likeCount}',
                leftIcon: _isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                foregroundColor: _isLiked ? Theme.of(context).primaryColor : titleColor,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                onTap: () {
                  if (widget.onLike != null) widget.onLike!(!_isLiked);
                  setState(() => _isLiked = !_isLiked);
                },
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text.rich(
            TextSpan(
              children: List.generate(widget.review.sizes.length, (index) => TextSpan(text: widget.review.sizes[index] + '\t')),
            ),
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: BZFontSize.content, color: semiColor),
          ),
          const SizedBox(height: 5),
          Text(
            widget.review.content,
            style: TextStyle(fontSize: BZFontSize.title, color: titleColor),
          ),
          if (widget.review.imageUrls.isNotEmpty) const SizedBox(height: 5),
          if (widget.review.imageUrls.isNotEmpty) Wrap(
            spacing: 8,
            children: List.generate(widget.review.imageUrls.length, (index) => ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(widget.review.imageUrls[index], fit: BoxFit.cover, width: 70, height: 70),
            )),
          ),
        ],
      ),
    );
  }
}