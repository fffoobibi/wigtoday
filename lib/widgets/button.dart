import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wigtoday_app/utils/color.dart';

class BZButton extends StatelessWidget {
  final Widget child;
  final void Function() onTap;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final BoxBorder? border;
  final double? radius;
  final BorderRadiusGeometry? borderRadius;
  final List<BoxShadow>? boxShadow;
  final Gradient? gradient;
  final BoxShape shape;
  final EdgeInsetsGeometry? padding;

  const BZButton({  
    Key? key,
    required this.child,
    required this.onTap,
    this.width,
    this.height,
    this.padding,
    this.backgroundColor,
    this.border,
    this.radius,
    this.borderRadius,
    this.boxShadow,
    this.gradient,
    this.shape = BoxShape.rectangle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: Ink(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: border,
          boxShadow: boxShadow,
          shape: shape,
          borderRadius: borderRadius ?? BorderRadius.circular(radius ?? 4),
          gradient: gradient,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(radius ?? 4 - 1),
          child: Container(
            width: width,
            height: height,
            alignment: Alignment.center,
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 8),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}


class BZTextButton extends StatelessWidget {
  final String text;
  final void Function() onTap;
  final double fontSize;
  final FontWeight fontWeight;
  final double? iconSize;
  final TextStyle? style;
  final IconData? leftIcon;
  final IconData? rightIcon;
  final double? width;
  final double? height;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final BoxBorder? border;
  final double? radius;
  final BorderRadiusGeometry? borderRadius;
  final Gradient? gradient;
  final BoxShape shape;
  final EdgeInsetsGeometry? padding;

  const BZTextButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.fontSize = 14,
    this.fontWeight = FontWeight.normal,
    this.iconSize,
    this.style,
    this.leftIcon,
    this.rightIcon,
    this.width,
    this.height,
    this.padding,
    this.foregroundColor,
    this.backgroundColor,
    this.border,
    this.radius,
    this.borderRadius,
    this.gradient,
    this.shape = BoxShape.rectangle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BZButton(
      onTap: onTap,
      width: width,
      height: height,
      padding: padding,
      backgroundColor: backgroundColor,
      border: border,
      radius: radius,
      borderRadius: borderRadius,
      gradient: gradient,
      shape: shape,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (leftIcon != null) Icon(leftIcon, size: iconSize ?? (fontSize + 4), color: foregroundColor),
          if (leftIcon != null) const SizedBox(width: 3),
          Text(
            text,
            style: TextStyle(
              fontSize: style?.fontSize ?? fontSize,
              fontWeight: style?.fontWeight ?? fontWeight,
              color: style?.color ?? foregroundColor,
            ),
          ),
          if (rightIcon != null) const SizedBox(width: 3),
          if (rightIcon != null) Icon(rightIcon, size: iconSize ?? (fontSize + 4), color: foregroundColor),
        ],
      ),
    );
  }
}


// ignore: must_be_immutable
class BZLoadingButton extends StatefulWidget {
  BZLoadingButton(
      {Key? key,
      this.loadingColor,
      this.loadingSize,
      this.loadingBuilder,
      required this.title,
      required this.onTap,
      required this.isLoading,
      required this.radius,
      required this.width,
      required this.hPadding,
      required this.useDebounce})
      : super(key: key);

  String title;
  bool isLoading = false;
  double radius = 10;
  double? width;
  double hPadding = 40;
  bool useDebounce = false;

  Future<bool> Function() onTap;
  Widget Function(BuildContext context)? loadingBuilder;
  Color? loadingColor;
  double? loadingSize;

  @override
  // ignore: no_logic_in_create_state
  State<BZLoadingButton> createState() => _BZLoadingButtonState(
      loadingBuilder: loadingBuilder,
      loadingColor: loadingColor,
      loadingSize: loadingSize,
      onTap: onTap,
      title: title,
      isLoading: isLoading,
      radius: radius,
      width: width,
      hPadding: hPadding,
      useDebounce: useDebounce);
}

class _BZLoadingButtonState extends State<BZLoadingButton> {
  String title;
  bool isLoading = false;
  double radius = 10;
  double? width;
  double hPadding = 40;
  bool useDebounce = false;
  Future<bool> Function() onTap;

  Widget Function(BuildContext context)? loadingBuilder;
  Color? loadingColor;
  double? loadingSize;

  _BZLoadingButtonState(
      {this.loadingBuilder,
      this.loadingColor,
      this.loadingSize,
      required this.onTap,
      required this.title,
      required this.isLoading,
      required this.radius,
      required this.width,
      required this.hPadding,
      required this.useDebounce});

  @override
  Widget build(BuildContext context) {
    return _createButton();
  }

  Widget? _createLoading() {
    if (isLoading) {
      return loadingBuilder != null
          ? loadingBuilder!(context)
          : SpinKitDualRing(
              lineWidth: 4,
              color: loadingColor ?? Colors.grey, //Theme.of(context).primaryColor,
              size: loadingSize ?? 30,
            );
    }
    return null;
  }

  Widget _createButton() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: hPadding),
        child: Container(
            height: 45,
            width: width ?? 500,
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [BZColor.gradStart, BZColor.gradEnd]),
                borderRadius: BorderRadius.circular(radius)),
            child: Stack(
              children: [
                InkWell(
                    borderRadius: BorderRadius.circular(radius),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(isLoading? '': title,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ),
                    onTap: () {
                      if (isLoading == false) {
                        setState(() {
                          isLoading = true;
                        });
                        onTap().then((value) {
                          setState(() {
                            isLoading = false;
                          });
                        }).catchError((e) {
                          setState(() {
                            isLoading = false;
                          });
                        });
                      }
                    }),
                Align(alignment: Alignment.center, child: _createLoading())
              ],
            )));
  }
}