
import 'package:flutter/material.dart';
import 'package:wigtoday_app/utils/color.dart';
import 'package:wigtoday_app/utils/font.dart';
import 'package:wigtoday_app/utils/size.dart';
import 'package:dio/dio.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wigtoday_app/utils/theme.dart';

typedef CallBack = Function(Map<String, dynamic> data);
typedef ErrBack = Function(DioError error);

mixin Components {
  static Dio _dio = _createDio();

  static Dio _createDio() {
    var _dio = Dio();
    // _dio.options.baseUrl = 'http://appapi.wigtoday.com/v1';
    _dio.options.baseUrl = 'http://192.168.0.160:5000';
    _dio.options.connectTimeout = 5000;
    _dio.options.receiveTimeout = 3000;
    _dio.options.responseType = ResponseType.json;
    return _dio;
  }

  AppLocalizations textLocation(BuildContext context) {
    print('context ==> $context');
    return AppLocalizations.of(context)!;
  }

  void get(String urlPath,
      {Options? options, CallBack? callBack, ErrBack? errBack}) async {
    try {
      final response = await _dio.get(urlPath, options: options);
      print(' =====>, ${response.data}, ${response.data.runtimeType}');
      // Map<String, dynamic> res = jsonDecode(response.data) as Map<String, dynamic>;
      if (callBack != null) {
        callBack(response.data);
      }
    } catch (e) {
      print('get error ===>: $e, $urlPath');
      if (errBack != null) {
        errBack(e as DioError);
      }
    }
  }

  void post(String urlPath,
      {Map<String, dynamic>? data,
      Options? options,
      CallBack? callBack,
      ErrBack? errBack}) async {
    try {
      final response = await _dio.post(urlPath,
          data: data != null ? FormData.fromMap(data) : null, options: options);
      // Map<String, dynamic> res = jsonDecode(response.data) as Map<String, dynamic>;
      if (callBack != null) {
        callBack(response.data);
      }
    } catch (e) {
      if (errBack != null) {
        errBack(e as DioError);
      }
    }
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
    String family = 'SF Pro',
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
        fontWeight: weight, color: c, fontFamily: family, fontSize: size);
  }

  Widget createButton(String title,
      {double radius = 10,
      VoidCallback? onTap,
      double? width,
      double hPadding = 40}) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: hPadding),
        child: Container(
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xffFE795A), Color(0xffFF1147)]),
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
            )));
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
                        colors: [Color(0xffFE795A), Color(0xffFF1147)]),
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
