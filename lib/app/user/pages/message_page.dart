import 'package:flutter/material.dart';
import 'package:wigtoday_app/app/user/models/message.dart';
import 'package:wigtoday_app/utils/color.dart';
import 'package:wigtoday_app/utils/formatter.dart';
import 'package:wigtoday_app/widgets/components.dart';

class MessageListPage extends StatefulWidget {
  MessageListPage({Key? key}) : super(key: key);

  @override
  State<MessageListPage> createState() => _MessageListPageState();
}

class _MessageListPageState extends State<MessageListPage> with Components {
  List<MessageModel> messageList = MessageModel.testMessages();
  final double padding = 12;

  Widget createMessageItem(MessageModel data) {
    return Container(
        padding: const EdgeInsets.all(10),
        height: 80,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), 
            color: isDark(context) ? BZColor.darkCard: BZColor.card),
        width: double.infinity,
        child: Row(
          children: [
            ClipOval(
                child: Image.network(data.avtarUrl,
                    height: 60, width: 60, fit: BoxFit.cover)),
            const SizedBox(
              width: 5,
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(data.userName,
                          style: createTextStyle(
                              size: 20, weight: FontWeight.bold, ctx: context, dark: BZColor.darkSemi)),
                      Text(timeFormat(data.time, 'yyyy/MM/dd').substring(2),
                          style: createTextStyle(
                              size: 14, dark:BZColor.darkGrey, light: BZColor.grey, ctx: context)),
                    ]),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Text(data.message,
                            style: createTextStyle(
                                size: 12, dark:BZColor.darkGrey, light: BZColor.grey, ctx: context),
                            maxLines: 2)),
                    ClipOval(
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.red,
                        height: 20,
                        width: 20,
                        child: Text("${data.count}"),
                      ),
                    )
                  ],
                )
              ],
            ))
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    var radius = 10.0;
    var spacing = 10.0;
    var padding = 12.0;
    return Scaffold(
        backgroundColor: isDark(context)? BZColor.darkBackground: const Color(0xffECECEC),
        appBar: createAppBar(
            child: Container(
              child: Row(
                children: [BackButton(onPressed: () => Navigator.pop(context))],
              ),
            ),
            backgroundAssetName:isDark(context)? null: 'assets/images/security.png',
            height: 60),
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                    visible: messageList.length > 0 ? true : false,
                    child: Column(
                      children: [
                        Text(
                          textLocation(context).titleMesage,
                          style: createTextStyle(
                              size: 30, weight: FontWeight.bold, ctx: context),
                        ),
                        SizedBox(
                          height: spacing * 3,
                        ),
                      ],
                    )),
                Expanded(
                  child: Column(
                    mainAxisAlignment: messageList.length > 0
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Visibility(
                          visible: messageList.length > 0 ? true : false,
                          child: Expanded (child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: messageList.length,
                            itemBuilder: (ctx, index) =>
                                createMessageItem(messageList[index]),
                            separatorBuilder: (ctx, index) =>
                                const SizedBox(height: 12),
                          ))),
                      Visibility(
                          visible: messageList.length == 0 ? true : false,
                          child: Container(
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/images/message_empty.jpg',
                                    height: 200,
                                    width: 200,
                                    fit: BoxFit.cover,
                                  ),
                                  Text(
                                    textLocation(context).feedBackEmptyMessage,
                                    style: createTextStyle(
                                        size: 14, dark: BZColor.darkGrey, ctx: context, light: BZColor.grey),
                                  )
                                ],
                              )))
                    ],
                  ),
                ),
              ],
            )));
  }
}
