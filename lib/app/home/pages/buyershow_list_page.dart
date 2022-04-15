import 'package:flutter/material.dart';

import 'package:wigtoday_app/utils/size.dart';
import 'package:wigtoday_app/app/home/widgets/buyershow_card.dart';
import 'package:wigtoday_app/app/home/pages/buyershow_detail_page.dart';


class BuyerShowListPage extends StatefulWidget {
  const BuyerShowListPage({ Key? key }) : super(key: key);

  @override
  State<BuyerShowListPage> createState() => _BuyerShowListPageState();
}

class _BuyerShowListPageState extends State<BuyerShowListPage> {
  static const double gap = 12;
  final List<String?> _descriptions = [
    'Lolita Alicegarden Bonnie Pink/Purple Buns Wig Wm1018 Pink/Purple Buns Wig',
    'Short Pink Straight Wig Wm1104 Pink/Purple Buns Wig Wm1018 Bonnie Hgfid ReBuild List',
    'Kuytrhitg per Light Dintjhifd Finds a Tfrefbch',
    'Gtefgtreht Hgfid ReBuild List',
    null,
    'Frewgrte World Anduif',
    'Bonnie Hgfid ReBuild List',
    null,
    'Angelar as Goolr Pink/Purple Buns Wig',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buyer show'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(gap, gap, gap, gap + BZSize.bottomBarHeight),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: List.generate(
            _descriptions.length,
            (index) => BuyerShowCard(
              imageUrl: 'https://placeimg.com/300/300/any${index + 1}',
              description: _descriptions[index],
              isLiked: index % 2 == 0,
              score: index % 5,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BuyerShowDetailPage(
                    imageUrls: const [
                      'https://placeimg.com/300/300/any1',
                      'https://placeimg.com/300/300/any2',
                      'https://placeimg.com/300/300/any3',
                    ],
                    description: _descriptions[index],
                    isLiked: index % 2 == 0,
                    score: index % 5,
                  )),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}