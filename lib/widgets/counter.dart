import 'package:flutter/material.dart';
import 'package:wigtoday_app/utils/color.dart';
import 'package:wigtoday_app/utils/theme.dart';

import 'package:wigtoday_app/widgets/button.dart';


class BZCounter extends StatefulWidget {
  final double width;
  final double height;
  final int min;
  final int max;
  final int step;
  final int initValue;
  final void Function(int) onChanged;
  const BZCounter({
    Key? key,
    required this.width,
    required this.height,
    required this.onChanged,
    this.step = 1,
    this.initValue = 1,
    this.min = 1,
    this.max = 99999,
  }) : super(key: key);

  @override
  State<BZCounter> createState() => _BZCounterState();
}


class _BZCounterState extends State<BZCounter> {
  late int _currentValue;

  @override
  void initState() {
    _currentValue = widget.initValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color titleColor = BZTheme.isDark(context) ? BZColor.darkTitle : BZColor.title;
    Color disabledColor = BZTheme.isDark(context) ? BZColor.darkLight : BZColor.light;
    Color disabledBackgroundColor = Theme.of(context).dividerColor;
    return SizedBox(
      width: widget.width - 2,
      child: Row(
        children: [
          BZTextButton(
            text: '',
            fontSize: 12,
            leftIcon: Icons.remove,
            width: widget.height - 2,
            height: widget.height - 2,
            radius: widget.height / 2,
            border: Border.all(color: Theme.of(context).dividerColor),
            padding: const EdgeInsets.all(0),
            foregroundColor: _currentValue <= widget.min ? disabledColor : titleColor,
            backgroundColor: _currentValue <= widget.min ? disabledBackgroundColor : const Color(0x00000000),
            onTap: () {
              if (_currentValue > widget.min) {
                setState(() => _currentValue -= widget.step);
                widget.onChanged(_currentValue);
              }
            },
          ),
          Expanded(
            child: Text(
              '$_currentValue',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ),
          BZTextButton(
            text: '',
            fontSize: 12,
            leftIcon: Icons.add,
            width: widget.height - 2,
            height: widget.height - 2,
            radius: widget.height / 2,
            border: Border.all(color: Theme.of(context).dividerColor),
            padding: const EdgeInsets.all(0),
            foregroundColor: _currentValue >= widget.max ? disabledColor : titleColor,
            backgroundColor: _currentValue >= widget.max ? disabledBackgroundColor : const Color(0x00000000),
            onTap: () {
              if (_currentValue < widget.max) {
                setState(() => _currentValue += widget.step);
                widget.onChanged(_currentValue);
              }
            },
          ),
        ],
      ),
    );
  }
}