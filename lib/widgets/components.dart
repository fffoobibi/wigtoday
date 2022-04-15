import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:dio/dio.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:wigtoday_app/app/user/models/user_profile.dart';
import 'package:wigtoday_app/utils/color.dart';
import 'package:wigtoday_app/utils/font.dart';
import 'package:wigtoday_app/utils/http.dart';
import 'package:wigtoday_app/utils/size.dart';
import 'package:wigtoday_app/widgets/button.dart';
import 'package:wigtoday_app/utils/theme.dart';

mixin Components {
  Widget getAvatar(
      {required UserProFileModle model,
      required BuildContext context,
      required double height,
      required double width}) {
    if (model.avatar.isEmpty) {
      return Icon(
        Icons.person_rounded,
        size: width,
        color: const Color(0xffECECEC),
      );
    } else {
      return Image.network(model.avatar,
          fit: BoxFit.cover, height: height, width: width);
    }
  }

  void showToast(
      {required String msg,
      ToastGravity gravity = ToastGravity.TOP,
      BuildContext? ctx}) {
    Color? bkg;
    Color? fre;
    if (ctx != null) {
      bkg = isDark(ctx) ? BZColor.darkGrey : null;
      fre = isDark(ctx) ? Colors.white : null;
    }
    Fluttertoast.showToast(
        msg: msg, gravity: gravity, backgroundColor: bkg, textColor: fre);
  }

  AppLocalizations textLocation(BuildContext context) {
    return AppLocalizations.of(context)!;
  }

  Future<Map<String, dynamic>> get(String urlPath,
      {Map<String, dynamic>? headers, Options? options}) async {
    return HttpUtil.get(urlPath, headers: headers, options: options);
  }

  Future<Map<String, dynamic>> post(String urlPath,
      {Map<String, dynamic>? data,
      Map<String, dynamic>? headers,
      FormData? fdata,
      Options? options}) async {
    return HttpUtil.post(urlPath,
        data: data, fdata: fdata, headers: headers, options: options);
  }

  Widget netWorkImage(
    String url,
    Widget errWidget, {
    double? width,
    double? height,
    BoxFit? fit,
    Widget? loading,
  }) {
    return FutureBuilder(
        future: get(url),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return errWidget;
            }
            return CachedNetworkImage(
              imageUrl: url,
              width: width,
              height: height,
              fit: fit,
            );
          } else {
            return loading ??
                SizedBox(
                    child: const CircularProgressIndicator(),
                    width: width,
                    height: height);
          }
        }));
    // CachedNetworkImage(
    //     imageUrl: url,
    //     width: width,
    //     height: height,
    //     fit: fit,
    //     placeholder: (ctx, _) => Text('loading'),
    //     errorWidget: (_, __, ___) => const Icon(
    //           Icons.error,
    //           size: 40,
    //         ));
    // Image image = Image.network(url, width: width, height: height, fit: fit);
    // final ImageStream stream = image.image.resolve(ImageConfiguration.empty);
    // stream.addListener(
    //   ImageStreamListener((_,__){},
    //   onError: (excp, stace){
    //       print("error  im iamge ====>");
    //   }),
    // );
    // return image;
  }

  Map<String, dynamic> getTokenHeaders(UserProFileModle proFileModle) {
    return {'Authorization': 'Beaer ${proFileModle.token}'};
  }

  bool isDark(BuildContext context) {
    return BZTheme.isDark(context);
  }

  PreferredSize createAppBar(
      {required Widget child,
      double height = 120,
      String? backgroundAssetName}) {
    return PreferredSize(
        child: Container(
          child: SafeArea(child: child),
          decoration: BoxDecoration(
              image: backgroundAssetName != null
                  ? DecorationImage(
                      image: AssetImage(backgroundAssetName),
                      fit: BoxFit.cover,
                      repeat: ImageRepeat.noRepeat)
                  : null),
        ),
        preferredSize: Size.fromHeight(height));
  }

  TextStyle createTextStyle({
    FontWeight weight = FontWeight.normal,
    Color color = Colors.black,
    BuildContext? ctx,
    Color? light,
    Color? dark,
    TextDecoration? decoration,
    double size = 22,
  }) {
    Color c;
    if (ctx != null) {
      c = BZTheme.isDark(ctx)
          ? (dark ?? BZColor.darkTitle)
          : (light ?? BZColor.title);
    } else {
      c = color;
    }
    return TextStyle(
        fontWeight: weight, color: c, fontSize: size, decoration: decoration);
  }

  // 防抖
  void Function()? debounce(
    Function func, [
    Duration delay = const Duration(milliseconds: 500),
  ]) {
    Timer? timer;
    // ignore: prefer_function_declarations_over_variables
    void Function()? target = () {
      if (timer?.isActive ?? false) {
        timer?.cancel();
      }
      timer = Timer(delay, () {
        func.call();
      });
    };
    return target;
  }

  Widget createButton(String title,
      {double radius = 10,
      VoidCallback? onTap,
      double? width,
      double hPadding = 40,
      bool useDebounce = false}) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: hPadding),
        child: Container(
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [BZColor.gradStart, BZColor.gradEnd]),
                borderRadius: BorderRadius.circular(radius)),
            child: InkWell(
                borderRadius: BorderRadius.circular(radius),
                child: Container(
                  width: width ?? 500,
                  height: 45,
                  alignment: Alignment.center,
                  child: Text(title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'SF Pro',
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ),
                onTap: useDebounce
                    ? (onTap != null ? debounce(onTap) : null)
                    : onTap)));
  }

  Widget createLoadingButton(String title,
      {required Future<bool> Function() onTap,
      bool useDebounce = false, // not use
      double hPadding = 40,
      double? width,
      Color? loadingColor,
      double? loadingSize = 20,
      Widget Function(BuildContext)? loadingBuilder}) {
    return BZLoadingButton(
        loadingColor: loadingColor,
        loadingSize: loadingSize,
        loadingBuilder: loadingBuilder,
        isLoading: false,
        radius: 10,
        title: title,
        onTap: onTap,
        width: width,
        hPadding: hPadding,
        useDebounce: useDebounce);
  }

  Widget createButtonWithSplash(String title,
      {double radius = 10,
      VoidCallback? onTap,
      double? width,
      double hPadding = 40,
      double vPadding = 10}) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: hPadding),
        child: Container(
            child: Ink(
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [BZColor.gradStart, BZColor.gradEnd]),
                    borderRadius: BorderRadius.circular(radius)),
                child: InkWell(
                  borderRadius: BorderRadius.circular(radius),
                  child: Container(
                    width: width ?? 500,
                    height: 45,
                    alignment: Alignment.center,
                    child: Text(title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'SF Pro',
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ),
                  onTap: onTap,
                ))));
  }

  Widget createNormalButton(String title,
      {VoidCallback? onPress,
      Color background = Colors.white,
      double hPadding = 40,
      double vPadding = 10,
      double radius = 5,
      TextStyle? textStyle,
      BuildContext? ctx,
      Color? light,
      Color? dark}) {
    Color c;
    if (ctx != null) {
      c = BZTheme.isDark(ctx)
          ? (dark ?? BZColor.darkBackground)
          : (light ?? BZColor.background);
    } else {
      c = background;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding:
              EdgeInsets.symmetric(horizontal: hPadding, vertical: vPadding),
          decoration: BoxDecoration(
              color: c, borderRadius: BorderRadius.circular(radius)),
          child: InkWell(
              child: Text(
                title,
                style: textStyle ?? createTextStyle(),
              ),
              onTap: onPress),
        ),
      ],
    );
  }

  Widget createInputField(String title,
      {double spacing = 15,
      bool readOnly = false,
      bool obscureText = false,
      ValueChanged<String>? setter,
      FormFieldValidator<String>? validator,
      VoidCallback? onTap,
      Widget? restWidget,
      Widget? inputField,
      Widget? suffixIcon,
      double? width,
      String? hintText,
      TextStyle? hintStyle,
      String? initialValue,
      TextEditingController? controller,
      TextInputType? keyboardType,
      BuildContext? ctx,
      Color? light,
      Color? dark}) {
    Color borderColor;
    if (ctx != null) {
      borderColor = isDark(ctx) ? BZColor.darkGrey : BZColor.grey;
    } else {
      borderColor = BZColor.grey;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        restWidget != null
            ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                RichText(
                    text: TextSpan(children: [
                  const TextSpan(
                      text: '* ', style: TextStyle(color: Colors.red)),
                  TextSpan(
                      text: title,
                      style:
                          createTextStyle(size: BZFontSize.subTitle, ctx: ctx))
                ])),
                restWidget
              ])
            : RichText(
                text: TextSpan(children: [
                const TextSpan(text: '* ', style: TextStyle(color: Colors.red)),
                TextSpan(
                    text: title,
                    style: createTextStyle(size: BZFontSize.subTitle, ctx: ctx))
              ])),
        SizedBox(height: spacing),
        SizedBox(
            height: 36,
            width: width ?? BZSize.pageWidth / 3,
            child: inputField ??
                TextFormField(
                  obscureText: obscureText,
                  keyboardType: keyboardType,
                  controller: controller,
                  validator: validator,
                  initialValue: initialValue,
                  readOnly: readOnly,
                  textAlign: TextAlign.start,
                  style: createTextStyle(size: BZFontSize.title, ctx: ctx),
                  decoration: InputDecoration(
                      suffixIcon: suffixIcon,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 0),
                      hintText: hintText,
                      hintStyle: hintStyle,
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: borderColor)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4))),
                  onChanged: setter,
                  onTap: onTap,
                ))
      ],
    );
  }
}
