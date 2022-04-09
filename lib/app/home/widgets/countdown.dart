import 'package:flutter/material.dart';

import 'package:wigtoday_app/utils/font.dart';
import 'package:wigtoday_app/utils/color.dart';
import 'package:wigtoday_app/utils/theme.dart';


class BZCountdown extends StatefulWidget {
  final DateTime endTime;
  const BZCountdown({
    Key? key,
    required this.endTime,
  }) : super(key: key);

  @override
  State<BZCountdown> createState() => _BZCountdownState();
}

class _BZCountdownState extends State<BZCountdown> {
  // 倒计时
  int _timeDay = 1;
  int _timeHour = 12;
  int _timeMinute = 34;
  int _timeSecond = 20;


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _square('$_timeDay'),
        // const SizedBox(width: 5,),
        _split(),
        _square('$_timeHour'),
        // const SizedBox(width: 5,),
        _split(),
        _square('$_timeMinute'),
        // const SizedBox(width: 5,),
        _split(),
        _square('$_timeSecond'),
      ],
    );
  }


  // 数字方块
  Widget _square(String text) {
    return Container(
      width: 22,
      height: 22,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Color(0xff000000),
        borderRadius: BorderRadius.all(Radius.circular(4))
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: BZFontSize.content,
          color: Colors.white,
        ),
      ),
    );
  }


  // 冒号
  Widget _split() {
    return Text(
      ' : ',
      style: TextStyle(
        fontSize: BZFontSize.content,
        fontWeight: FontWeight.bold,
        color: BZTheme.isDark(context) ? BZColor.darkTitle : BZColor.title,
      ),
    );
  }
}