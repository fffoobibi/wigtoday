// ignore_for_file: unnecessary_this
import 'package:flutter/material.dart';
import 'package:wigtoday_app/app/login/login_widget.dart';
import 'package:wigtoday_app/app/login/models/login.dart';
import 'package:wigtoday_app/app/user/pages/message_page.dart';
import 'package:wigtoday_app/app/user/pages/settings_page.dart';
import 'package:wigtoday_app/utils/color.dart';
import 'package:wigtoday_app/utils/size.dart';
import 'package:wigtoday_app/app/user/widgets/user_profile.dart';
import 'package:wigtoday_app/widgets/components.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({Key? key, this.isLogin = false}) : super(key: key);
  final bool isLogin;

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> with Components {
  bool isLogin = false;
  final double padding = 5;

  LoginModel? loginState;

  final _titleBarList = <String>[
      'Unpaid',
      'Suspending',
      'Paid',
      'Processing',
      'Completed',
    ];


  void onTitleBarPress(int index){
    switch (index) {
      case 0:
        break;
      case 1:
        break;
      case 2:
        break;
      case 3:
        break;
      case 4:
        break;
      default:
        return;
    }
  }

  // 标题栏
  Container _createTitle(BuildContext context,
      {required double spacing, required double padding}) {
    final wrapItemTexts = <List<String>>[
      [textLocation(context).titleUnpaid, 'Unpaid'],
      [textLocation(context).titleSuspending, 'Suspending'],
      [textLocation(context).titlePaid, 'Paid'],
      [textLocation(context).titleProcessing, 'Processing'],
      [textLocation(context).titleCompleted, 'Completed'],
    ];
    final dropDownTexts = <String>[
      textLocation(context).titleSettings,
      textLocation(context).titleMesage
    ];

    return Container(
        child: Stack(children: [
      Image.asset(
          isDark(context)
              ? 'assets/icons/personalbg1_dark.png'
              : 'assets/icons/personalbg1.png',
          fit: BoxFit.cover),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SafeArea(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              BackButton(onPressed: () {}),
              PopupMenuButton(
                icon: const Icon(Icons.more_horiz),
                itemBuilder: (ctx) => List.generate(2, (index) {
                  return PopupMenuItem(
                    child: Text(dropDownTexts[index]),
                    value: index,
                  );
                }),
                onSelected: (value) {
                  if (value == 0) {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => SettingsPage()));
                  } else {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => MessageListPage()));
                  }
                },
              ),
            ])),
        Padding(
          padding: EdgeInsets.all(padding),
          child: Row(
            children: [
              InkWell(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UserProfile())),
                child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color:
                            isDark(context) ? BZColor.darkCard : Colors.white),
                    child: const ClipOval(
                      child: Icon(
                        Icons.person_rounded,
                        size: 40,
                        // color: Color(0xffECECEC),
                      ),
                    )),
              ),
              const SizedBox(width: 8),
              Visibility(
                  visible: !isLogin,
                  child: Row(
                    children: [
                      InkWell(
                          child: Text(
                              textLocation(context).titleRegister +
                                  ' / ' +
                                  textLocation(context).titleSign,
                              style: createTextStyle(
                                  size: 14, color: Colors.black, ctx: context)),
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => const LoginWidget()))),
                    ],
                  )),
              Visibility(
                visible: isLogin,
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text('Diefered@gmail.com',
                            style: createTextStyle(size: 14, ctx: context))),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: const LinearGradient(
                              colors: [Color(0xffC2F7FF), Color(0xffC3F8FF)])),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: () {},
                        child: Text('Data management',
                            style: createTextStyle(
                                size: 14, color: const Color(0xff0099BA))),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        SizedBox(height: spacing),
      ]),
      Positioned(
          left: padding,
          bottom: 0,
          child: Container(
              width: BZSize.pageWidth - padding * 2,
              padding: EdgeInsets.all(padding),
              decoration: BoxDecoration(
                  color: isDark(context) ? BZColor.darkCard : BZColor.card,
                  borderRadius: BorderRadius.circular(5)),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                          wrapItemTexts.length, (index)=>_createTitleItem(context, wrapItemTexts[index][0], wrapItemTexts[index][1], index))
                      ))),
    ]));
  }

  InkWell _createTitleItem(BuildContext context, String title, String image, int index) {
    return InkWell(
        child: Ink(
            child: Column(
          children: [
            Image.asset(
              isDark(context)
                  ? 'assets/icons/${image.toLowerCase()}_dark.png'
                  : 'assets/icons/${image.toLowerCase()}.png',
              fit: BoxFit.fitWidth,
              width: 25,
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: createTextStyle(ctx: context, size: 12),
            ),
          ],
        )),
        onTap: () {
          onTitleBarPress(index);
        });
  }

  InkWell _createEarnedItem({required String title, required double value}) {
    // double width = (BZSize.pageWidth - 20) / 3;
    return InkWell(
      child: Ink(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: createTextStyle(ctx: context, size: 12)),
          const SizedBox(height: 5),
          Text('$value',
              style: createTextStyle(
                  size: 20, ctx: context, weight: FontWeight.bold))
        ],
      )),
    );
  }

  Widget _createGoodCardItem(BuildContext context,
      {required Map data, required double padding}) {
    double spacing = 5;
    double radius = 5;
    return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Container(
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius),
                color: isDark(context) ? BZColor.darkCard : BZColor.card),
            child: Column(children: [
              Image.network(data['src'] as String,
                  width: double.infinity, fit: BoxFit.cover, height: 150),
              Container(
                  padding: EdgeInsets.all(padding),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: spacing),
                        Text('Lolita Alicegarden Bonnie',
                            style: createTextStyle(ctx: context, size: 14)),
                        SizedBox(height: spacing),
                        Text('Pink/purple Buns Wig',
                            style: createTextStyle(ctx: context, size: 14)),
                        SizedBox(height: spacing),
                        const Text('EUR 15.9',
                            style: TextStyle(
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                                decorationColor: Colors.grey)),
                        SizedBox(height: spacing),
                        const Text('EUR 30.56',
                            style: TextStyle(color: Color(0xffFB3F61))),
                      ]))
            ])));
  }

  List<Map> _getGoodDatas() {
    var url = 'https://p0.ssl.img.360kuai.com/t016e2f42c2f1145dc5.webp';
    return List.generate(10, (index) => {'src': url});
  }

  // 创建earn Card
  Widget _createEarnCard(BuildContext context,
      {required double padding,
      required double radius,
      required double spacing}) {
    List<String> earnedTitles = [
      textLocation(context).titleToBeConfirm,
      textLocation(context).titleConfimed,
      textLocation(context).titleBalance
    ];
    return Container(
      decoration: BoxDecoration(
          color: isDark(context) ? BZColor.darkCard : BZColor.card,
          borderRadius: BorderRadius.circular(radius)),
      padding: const EdgeInsets.all(0),
      child: Column(children: [
        Container(
            padding: EdgeInsets.all(padding),
            child: Row(children: [
              Image.asset(
                'assets/icons/earn.png',
                fit: BoxFit.cover,
                height: 20,
                width: 20,
              ),
              const SizedBox(width: 5),
              Text('Cumulative eamed',
                  style: createTextStyle(
                      color: Colors.black, ctx: context, size: 12))
            ])),
        SizedBox(height: spacing),
        Container(
            padding: EdgeInsets.fromLTRB(padding, padding, 0, padding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: 'USD ',
                      style: createTextStyle(ctx: context, size: 14)),
                  TextSpan(
                    text: '86.03',
                    style: createTextStyle(
                        size: 23, weight: FontWeight.bold, ctx: context),
                  )
                ])),
                SizedBox(height: spacing),
                Container(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    alignment: Alignment.centerRight,
                    height: 22,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Color(0xFFff7b59), Color(0xFFff0f47)]),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10))),
                    child: const Text(
                      'Withdrawal',
                      style: TextStyle(color: Colors.white),
                    )),
              ],
            )),
        SizedBox(height: spacing * 1.5),
        Container(
            decoration: BoxDecoration(
                color: isDark(context)
                    ? BZColor.darkShadow
                    : const Color(0xffF9F9F9),
                borderRadius: BorderRadius.circular(radius)),
            padding: EdgeInsets.all(padding),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(3, (index) {
                  var title = earnedTitles[index];
                  var value = 86.03;
                  return _createEarnedItem(title: title, value: value);
                }))),
      ]),
    );
  }

  // 创建展示列表
  Widget _createGoodsView(BuildContext context,
      {required double padding, required double radius}) {
    var datas = _getGoodDatas();
    double hSpacing = 20;
    double vSpacing = 10;
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(radius)),
        padding: const EdgeInsets.all(0),
        child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(0),
            shrinkWrap: true,
            itemCount: datas.length,
            itemBuilder: (context, index) {
              return _createGoodCardItem(context,
                  data: datas[index], padding: padding);
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 3 / 4.5,
                crossAxisCount: 2,
                crossAxisSpacing: hSpacing,
                mainAxisSpacing: vSpacing)));
  }

  // 创建设置栏
  Widget _createSettingsBar(BuildContext context,
      {int? id, required double radius, required double padding}) {
    final itemTexts = <List<String>>[
      ['selling_feed.png', textLocation(context).titleSellingFeed],
      ['campaign.png', textLocation(context).titleCampaign],
      ['payouts.png', textLocation(context).titlePayouts],
      ['password.png', textLocation(context).titlePassword],
    ];
    // const double radius = 15;
    const double spacing = 10;
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            color: isDark(context) ? BZColor.darkCard : BZColor.card),
        padding: EdgeInsets.all(padding),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Visibility(
                  visible: isLogin,
                  child: Row(children: [
                    Container(
                      // height: 22,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color(0xffECECEC)),
                      alignment: Alignment.centerLeft,
                      child: RichText(
                          text: TextSpan(children: [
                        const TextSpan(
                            text: ' Affiliate ID ',
                            style:
                                TextStyle(color: Colors.black, fontSize: 14)),
                        TextSpan(
                            text: '${id ?? 30016}',
                            style: const TextStyle(
                                color: Colors.red, fontSize: 14)),
                      ])),
                    ),
                    const Expanded(child: Text(''), flex: 20)
                  ])),
              const SizedBox(height: 8),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(4, (index) {
                    String name = itemTexts[index][0];
                    return InkWell(
                        child: Column(
                      children: [
                        Image.asset('assets/icons/$name',
                            width: 40, height: 40, fit: BoxFit.cover),
                        const SizedBox(height: spacing),
                        Text(itemTexts[index][1],
                            style: createTextStyle(ctx: context, size: 12))
                      ],
                    ));
                  })),
            ]));
  }

  Widget _createContent(BuildContext context,
      {required double padding,
      required double spacing,
      required double radius}) {
    return Column(children: [
      Visibility(
          visible: !isLogin,
          child:
              Image.asset('assets/icons/personalbg2.png', fit: BoxFit.cover)),
      // image
      Visibility(
          visible: isLogin,
          child: Container(
              decoration: BoxDecoration(
                  color: isDark(context) ? BZColor.darkCard : BZColor.card,
                  borderRadius: BorderRadius.circular(radius)),
              padding: EdgeInsets.all(padding),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset('assets/icons/demo.jpg',
                        fit: BoxFit.cover, height: 50, width: 50),
                    const SizedBox(width: 10),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text(textLocation(context).titleUnpaid,
                              style: createTextStyle(size: 13, ctx: context)),
                          const SizedBox(height: 10),
                          Text('Lace Closure Human Hair Hw1124',
                              style: createTextStyle(
                                  size: 12,
                                  ctx: context,
                                  dark: BZColor.darkGrey,
                                  light: BZColor.grey))
                        ])),
                    const Text('On January 13',
                        style: TextStyle(color: Colors.grey)),
                  ]))),
      SizedBox(height: isLogin ? spacing : 0),
      Visibility(
          visible: isLogin,
          child: _createEarnCard(context,
              padding: padding, radius: radius, spacing: spacing)),
      SizedBox(height: spacing),

      _createSettingsBar(context, radius: radius, padding: padding),

      SizedBox(height: spacing),
      // 产品展示栏
      _createGoodsView(context, padding: padding, radius: radius)
    ]);
  }

  @override
  Widget build(BuildContext context) {
    const double padding = 10;
    const double radius = 5;
    const double spacing = 10;
    return SingleChildScrollView(
        padding: const EdgeInsets.all(0),
        child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 0),
            decoration: BoxDecoration(
                color: isDark(context)
                    ? BZColor.darkBackground
                    : BZColor.background),

            // Color(0xffECECEC)),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: _createTitle(context,
                      spacing: spacing, padding: padding)),
              Container(
                  padding: const EdgeInsets.all(10),
                  child: _createContent(context,
                      padding: padding, spacing: spacing, radius: radius)),
            ])));
  }
}
