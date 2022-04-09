import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:wigtoday_app/utils/color.dart';
import 'package:wigtoday_app/utils/size.dart';
import 'package:wigtoday_app/widgets/components.dart';

class AboutUsPage extends StatefulWidget {
  AboutUsPage({Key? key}) : super(key: key);

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> with Components {
  final double padding = 12;
  bool loading = true;
  int current = 0;
  final popItems = <String>['Cooperation', 'About us'];
  final apiNames = <String>['termsService', 'aboutUs'];
  final htmlResults = <String>['', ''];

  @override
  void initState() {
    super.initState();
    request_(0);
  }

  void request_(int index) {
    String url = '/page?name=${apiNames[index]}';
    if (htmlResults[index] == '') {
      post(url, callBack: (data) {
        setState(() {
          loading = false;
          current = index;
          htmlResults[current] = data['data'];
        });
      });
    } else {
      setState(() {
        loading = false;
        current = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: createAppBar(
            child: Container(
              child: Row(
                children: [BackButton(onPressed: () => Navigator.pop(context))],
              ),
            ),
            backgroundAssetName:
                isDark(context) ? null : 'assets/images/security.png',
            height: 60),
        body: SingleChildScrollView(
            child: IntrinsicHeight(
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(popItems[current],
                          style: createTextStyle(
                              size: 20, weight: FontWeight.bold, ctx: context)),
                      Container(
                          height: 30,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: isDark(context)
                                      ? BZColor.darkGrey
                                      : const Color.fromARGB(
                                          255, 243, 243, 243)),
                              color: isDark(context)
                                  ? BZColor.darkCard
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                  value: 0,
                                  onChanged: (value) {
                                    request_(value!);
                                  },
                                  items: List.generate(
                                      popItems.length,
                                      (index) => DropdownMenuItem(
                                          value: index,
                                          child: Text(popItems[index],
                                              style: createTextStyle(
                                                  ctx: context, size: 15)))))))
                    ],
                  ),
                  SizedBox(height: loading ? BZSize.pageHeight / 2 - 80 : 5),
                  Visibility(
                      visible: loading,
                      child: Expanded(
                          child: Container(
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(),
                      ))),
                  Visibility(
                      visible: !loading,
                      child: Html(
                        style: {
                          'p': Style(
                              color: isDark(context)
                                  ? BZColor.darkSemi
                                  : Colors.black)
                        },
                        data: htmlResults[current],
                        shrinkWrap: true,
                      )),
                ],
              )),
        )));
  }
}
