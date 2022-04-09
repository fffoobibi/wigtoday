import 'package:flutter/material.dart';

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
          Text(
            text,
            style: TextStyle(
              fontSize: style?.fontSize ?? fontSize,
              fontWeight: style?.fontWeight ?? fontWeight,
              color: style?.color ?? foregroundColor,
            ),
          ),
          if (rightIcon != null) Icon(rightIcon, size: iconSize ?? (fontSize + 4), color: foregroundColor),
        ],
      ),
    );
  }
}