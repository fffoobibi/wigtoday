import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wigtoday_app/app/home/models/product.dart';
import 'package:wigtoday_app/app/login/login_widget.dart';
import 'package:wigtoday_app/app/user/models/order.dart';
import 'package:wigtoday_app/app/user/models/use_country.dart';
import 'package:wigtoday_app/app/user/models/user_cache.dart';
import 'package:wigtoday_app/app/user/models/user_collection.dart';
import 'package:wigtoday_app/app/user/models/user_profile.dart';
import 'package:wigtoday_app/app/user/pages/message_page.dart';
import 'package:wigtoday_app/app/user/pages/settings_page.dart';
import 'package:wigtoday_app/utils/accounts.dart';
import 'package:wigtoday_app/utils/color.dart';
import 'package:wigtoday_app/utils/event_bus.dart';
import 'package:wigtoday_app/utils/font.dart';
import 'package:wigtoday_app/utils/formatter.dart';
import 'package:wigtoday_app/utils/shared.dart';
import 'package:wigtoday_app/utils/size.dart';
import 'package:wigtoday_app/utils/value_change.dart';
import 'package:wigtoday_app/widgets/components.dart';
// import 'package:provider/provider.dart';

// ignore: must_be_immutable
class UserPage extends StatefulWidget {
  UserCacheModel? userCache;

  UserPage({Key? key, required, this.userCache}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<UserPage> createState() => _UserPageState(userCache: userCache);
}

class _UserPageState extends State<UserPage>
    with Components, AutomaticKeepAliveClientMixin {
  _UserPageState({required this.userCache});

  UserCacheModel? userCache;

  final _floatHasShow = ValueNotifier<bool>(false); // floatActionButton
  final _collectionList = ValueNotifierList<UserCollectionModel>([]); // 收藏列表

  final _scrollController = ScrollController(); // 滚动控制

  bool isLoading = false;
  int collectionIndex = 0;
  bool hasMore = true;
  bool floatHasShow = false;

  final double padding = 5;

  bool isLogin = false;
  UserProFileModle? _userProFileModle;
  OrderModel? _userOrder;
  List<UserCountryModel>? _countryList;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  late StreamSubscription _stream;

  void logout() {
    login(WigTodayEvent(false, WigtodayEventType.logut));
  }

  void login(WigTodayEvent event) {
    _collectionList.clear();
    _floatHasShow.value = false;

    _userProFileModle = event.profileModel;
    isLogin = event.isLogin;
    isLoading = false;
    hasMore = true;
    floatHasShow = false;
    collectionIndex = 0;
    _userOrder = null;

    fetchOneOrder();
    fetchCollections();
    setState(() {});
  }

  void switchUser(WigTodayEvent event) {
    event.cacheModel?.save(updateCreateTime: true);
    login(event);
  }

  void modifyUser(WigTodayEvent event) {
    print('modify ===> ${event.profileModel!.phone}');
    _userProFileModle = event.profileModel;
    isLogin = event.isLogin;
    setState(() {});
  }

  void tryLoginWithLocalCache() {
    if (userCache != null) {
      eventBus.fire(WigTodayEvent(
        true,
        WigtodayEventType.login,
        null,
        userCache!.userProFileModle,
      ));
    }
  }

  Future<void> fetchCountrys() async {
    try {
      var resp = await get('/cart/country');
      if (resp['code'] == 0) {
        _countryList = UserCountryModel.fromResponse(resp);
      }
    } catch (e) {
      // print('fetch country error, $e');
    }
  }

  Future<void> fetchMoreCollections() async {
    try {
      if (isLogin && !isLoading && hasMore) {
        if (_scrollController.hasClients) {
          if (_scrollController.offset ==
              _scrollController.position.maxScrollExtent) {
            collectionIndex += 1;
            isLoading = true;
            await fetchCollections(page: collectionIndex);
          }
        }
      } else {
        if (_scrollController.offset ==
            _scrollController.position.maxScrollExtent) {
          showToast(msg: '到底了!', ctx: context, gravity: ToastGravity.BOTTOM);
        }
      }
    } finally {
      isLoading = false;
    }
  }

  Future<void> fetchCollections({int? page}) async {
    if (_scrollController.hasClients) {
      try {
        var res = await post('/user/collection',
            data: page != null ? {'page': page} : null,
            headers: {'Authorization': 'Beaer ${_userProFileModle!.token}'});
        if (res['code'] == 0) {
          var list = UserCollectionModel.fromList(res['data']['list']);
          _collectionList.addAll(list);
          hasMore = res['data']['has_more'];
        } else {
          Fluttertoast.showToast(msg: res['msg'], gravity: ToastGravity.TOP);
        }
      } catch (e) {}
    }
  }

  Future<void> fetchOneOrder() async {
    try {
      var resp = await post('/user/oneOrder',
          headers: getTokenHeaders(_userProFileModle!));
      if (resp['code'] == 0) {
        var data = resp['data'] as Map<String, dynamic>;
        var product = ProductModel(
            id: data['id'],
            title: data['product_name'],
            imageUrl: data['image'],
            realPrice: -1,
            rawPrice: -1);
        _userOrder = OrderModel(
            product: product,
            createTime: data['create_time'],
            state: OrderState.unpaid,
            quantity: -1,
            totalAmount: -1,
            currency: '');
        setState(() {});
      }
      // ignore: empty_catches
    } catch (e) {}
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    fetchCountrys();
    _scrollController.addListener(() {
      // if (_scrollController.offset <= 0) {}
      fetchMoreCollections();
      floatButtonShowPolicy();
    });

    _stream = eventBus.on<WigTodayEvent>().listen((event) {
      switch (event.type) {
        case WigtodayEventType.login:
          if (!isLogin) {
            login(event);
          }
          break;
        case WigtodayEventType.logut:
          logout();
          break;
        case WigtodayEventType.switchUser:
          switchUser(event);
          break;
        case WigtodayEventType.modify:
          modifyUser(event);
          break;
        default:
          return;
      }
    });

    tryLoginWithLocalCache();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();

    _stream.cancel();
  }

  void onTitleBarPress(int index) {
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

  // 状态栏
  Widget _createTitle(BuildContext context,
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

    return Stack(children: [
      Image.asset(
          isDark(context)
              ? 'assets/icons/personalbg1_dark.png'
              : 'assets/icons/personalbg1.png',
          fit: BoxFit.cover),
      SafeArea(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => SettingsPage(
                          isLogin: isLogin,
                          userProFileModle: _userProFileModle,
                          countrList: _countryList,
                        )));
              } else {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => MessageListPage()));
              }
            },
          ),
        ]),
        Padding(
          padding: EdgeInsets.all(padding),
          child: Row(
            children: [
              InkWell(
                onTap: () {},
                child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color:
                            isDark(context) ? BZColor.darkCard : Colors.white),
                    child: ClipOval(
                      child: isLogin
                          ? getAvatar(
                              model: _userProFileModle!,
                              context: context,
                              height: 40,
                              width: 40)
                          // Image.network(_userProFileModle!.avatar,
                          //     height: 40, width: 40, fit: BoxFit.cover)
                          : const Icon(
                              Icons.person_rounded,
                              size: 40,
                              color: Color(0xffECECEC),
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
                                  size: BZFontSize.title,
                                  color: Colors.black,
                                  ctx: context)),
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
                        child: Text(
                            isLogin
                                ? _userProFileModle!.authEmail
                                : '', //'Diefered@gmail.com',
                            style: createTextStyle(
                                size: BZFontSize.title, ctx: context))),
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
                                size: BZFontSize.title,
                                color: const Color(0xff0099BA))),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: spacing),
      ])),
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
                      wrapItemTexts.length,
                      (index) => _createTitleItem(
                          context,
                          wrapItemTexts[index][0],
                          wrapItemTexts[index][1],
                          index))))),
    ]);
  }

  InkWell _createTitleItem(
      BuildContext context, String title, String image, int index) {
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

  Widget _createGoodCardItem(BuildContext context,
      {required UserCollectionModel data, required double padding}) {
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
              Image.network(
                data.image,
                width: double.infinity,
                fit: BoxFit.cover,
                height: 150,
                loadingBuilder: (ctx, _, __) => Image.asset(
                  'assets/images/loaderror.png',
                  fit: BoxFit.cover,
                  height: 150,
                ),
                errorBuilder: (ctx, obj, st) => const Text('fail'),
              ),
              Container(
                  padding: EdgeInsets.all(padding),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: spacing),
                        Text(data.product_name, // 'Lolita Alicegarden Bonnie',
                            maxLines: 2,
                            style: createTextStyle(
                                ctx: context, size: BZFontSize.title)),
                        SizedBox(height: spacing),
                        Text(
                          data.net_price,
                          style: createTextStyle(
                              ctx: context,
                              light: BZColor.grey,
                              dark: BZColor.darkGrey,
                              size: BZFontSize.title,
                              decoration: TextDecoration.lineThrough),
                        ),
                        SizedBox(height: spacing),
                        Text(data.price,
                            style: const TextStyle(
                                color: Color(0xffFB3F61),
                                fontSize: BZFontSize.title)),
                      ]))
            ])));
  }

  // 创建收藏列表
  Widget _createGoodsViewLocal(BuildContext context,
      {required double padding, required double radius}) {
    // var datas = _getGoodDatas();
    double hSpacing = 20;
    double vSpacing = 10;
    return ValueListenableBuilder(
        valueListenable: _collectionList,
        builder: (ctx, List<UserCollectionModel> value, _) {
          return Container(
              width: double.infinity,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(radius)),
              padding: const EdgeInsets.all(0),
              child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(0),
                  shrinkWrap: true,
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return _createGoodCardItem(context,
                        data: value[index], padding: padding);
                  },
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 3 / 4.5,
                      crossAxisCount: 2,
                      crossAxisSpacing: hSpacing,
                      mainAxisSpacing: vSpacing)));
        });
  }

  Widget _createOrderCard(double radius) {
    return Container(
        decoration: BoxDecoration(
            color: isDark(context) ? BZColor.darkCard : BZColor.card,
            borderRadius: BorderRadius.circular(radius)),
        padding: EdgeInsets.all(padding),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          _userOrder != null
              ? Image.network(_userOrder!.product.imageUrl,
                  fit: BoxFit.cover, height: 50, width: 50)
              : Image.asset('assets/images/loaderror.png',
                  fit: BoxFit.cover, height: 50, width: 50),
          const SizedBox(width: 10),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(textLocation(context).titleUnpaid,
                    style: createTextStyle(size: 13, ctx: context)),
                const SizedBox(height: 10),
                Text(_userOrder != null ? _userOrder!.product.title : '---',
                    maxLines: 1,
                    style: createTextStyle(
                        size: BZFontSize.content,
                        ctx: context,
                        dark: BZColor.darkGrey,
                        light: BZColor.grey))
              ])),
          Text(
              _userOrder != null
                  ? timeFormat(_userOrder!.createTime, 'yyyy/MM/dd')
                  : 'On January 13',
              style: const TextStyle(color: Colors.grey)),
        ]));
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
                  visible: false,
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
      Visibility(visible: isLogin, child: _createOrderCard(radius)),
      SizedBox(height: isLogin ? spacing : 0),

      _createSettingsBar(context, radius: radius, padding: padding),

      SizedBox(height: spacing),

      // 收藏
      _createGoodsViewLocal(context, padding: padding, radius: radius)
    ]);
  }

  Widget? floatButton() {
    return ValueListenableBuilder(
        valueListenable: _floatHasShow,
        builder: (ctx, bool value, _) {
          if (value) {
            return FloatingActionButton(
                mini: true,
                child: const Icon(Icons.arrow_upward),
                onPressed: () {
                  _scrollController
                      .animateTo(0,
                          duration: const Duration(seconds: 1),
                          curve: Curves.easeIn)
                      .then((value) {
                    _floatHasShow.value = false;
                  });
                });
          }
          return Text('');
        });
  }

  void floatButtonShowPolicy() {
    if (isLogin && _scrollController.offset > BZSize.pageHeight/2) {
      _floatHasShow.value = true;
    } else {
      _floatHasShow.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    const double padding = 10;
    const double radius = 5;
    const double spacing = 10;
    super.build(context);
    print('build ====  user page =====');
    print('sharedata ===> ${SharedWidget.of(context).userName}');
    SharedWidget.of(context).userName = 'changed===> ';
    return Scaffold(
        floatingActionButton: floatButton(),
        body: RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(Duration(seconds: 2));
            },
            child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.all(0),
                child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    decoration: BoxDecoration(
                        color: isDark(context)
                            ? BZColor.darkBackground
                            : BZColor.background),

                    // Color(0xffECECEC)),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 0),
                              child: _createTitle(context,
                                  spacing: spacing, padding: padding)),
                          Container(
                              padding: const EdgeInsets.all(10),
                              child: _createContent(context,
                                  padding: padding,
                                  spacing: spacing,
                                  radius: radius)),
                        ])))));
  }
}
