import 'package:flutter/material.dart';

import 'package:wigtoday_app/api/review.dart';
import 'package:wigtoday_app/utils/font.dart';
import 'package:wigtoday_app/utils/color.dart';
import 'package:wigtoday_app/utils/size.dart';
import 'package:wigtoday_app/utils/theme.dart';
import 'package:wigtoday_app/widgets/button.dart';
import 'package:wigtoday_app/app/home/models/review.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wigtoday_app/app/home/widgets/review_tile.dart';


class ReviewListPage extends StatefulWidget {
  const ReviewListPage({ Key? key }) : super(key: key);

  @override
  State<ReviewListPage> createState() => _ReviewListPageState();
}


class _ReviewListPageState extends State<ReviewListPage> with SingleTickerProviderStateMixin {
  final List<ReviewModel> _reviews = ApiReview.getReviewList();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.reviews),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Text(AppLocalizations.of(context)!.all),
            Text(AppLocalizations.of(context)!.photoComments),
            Text(AppLocalizations.of(context)!.likes),
          ],
          labelStyle: const TextStyle(
            fontSize: BZFontSize.title,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelColor: BZTheme.isDark(context) ? BZColor.darkTitle : BZColor.title,
          labelPadding: const EdgeInsets.symmetric(vertical: 12),
          indicatorSize: TabBarIndicatorSize.tab,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.fromLTRB(0, 8, 0, BZSize.bottomBarHeight + 8),
            itemCount: _reviews.length,
            itemBuilder: (context, index) => ReviewTile(review: _reviews[index]),
            separatorBuilder: (context, index) => const Divider(height: 0),
          ),
          ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.fromLTRB(0, 8, 0, BZSize.bottomBarHeight + 8),
            itemCount: _reviews.length,
            itemBuilder: (context, index) => ReviewTile(review: _reviews[index]),
            separatorBuilder: (context, index) => const Divider(height: 0),
          ),
          ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.fromLTRB(0, 8, 0, BZSize.bottomBarHeight + 8),
            itemCount: _reviews.length,
            itemBuilder: (context, index) => ReviewTile(review: _reviews[index]),
            separatorBuilder: (context, index) => const Divider(height: 0),
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
}