import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wigtoday_app/utils/color.dart';
import 'package:wigtoday_app/utils/font.dart';
import 'package:wigtoday_app/utils/size.dart';
import 'package:wigtoday_app/utils/theme.dart';
import 'package:wigtoday_app/widgets/button.dart';


class AddressEditPage extends StatefulWidget {
  const AddressEditPage({Key? key}) : super(key: key);

  @override
  State<AddressEditPage> createState() => _AddressEditPageState();
}

class _AddressEditPageState extends State<AddressEditPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.editAddress),
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete_outlined,
              color: BZTheme.isDark(context) ? BZColor.darkTitle : BZColor.title,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: _formBox(),
      ),
    );
  }


  Widget _formBox() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _formField(
            hintText: AppLocalizations.of(context)!.firstName,
            validator: (val) {
              return null;
            },
          ),
          const SizedBox(height: 16),
          _formField(
            hintText: AppLocalizations.of(context)!.lastName,
            validator: (val) {
              return null;
            },
          ),
          const SizedBox(height: 16),
          _formField(
            hintText: AppLocalizations.of(context)!.telephone,
            keyboardType: TextInputType.phone,
            validator: (val) {
              return null;
            },
          ),
          const SizedBox(height: 16),
          _formField(
            hintText: AppLocalizations.of(context)!.address,
            keyboardType: TextInputType.multiline,
            maxLines: 5,
            validator: (val) {
              return null;
            },
          ),
          const SizedBox(height: 16),
          BZTextButton(
            width: BZSize.pageWidth - 32,
            height: 40,
            text: AppLocalizations.of(context)!.save,
            foregroundColor: Colors.white,
            fontSize: BZFontSize.title,
            fontWeight: FontWeight.bold,
            gradient: const LinearGradient(colors: [BZColor.gradStart, BZColor.gradEnd]),
            radius: 8,
            onTap: () {},
          ),
        ],
      ),
    );
  }


  Widget _formField({
    required String hintText,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    Color titleColor = BZTheme.isDark(context) ? BZColor.darkTitle : BZColor.title;
    Color greyColor = BZTheme.isDark(context) ? BZColor.darkGrey : BZColor.grey;
    Color backgroudColor = Theme.of(context).cardColor;
    return TextFormField(
      maxLines: maxLines,
      style: TextStyle(fontSize: BZFontSize.subTitle, color: titleColor),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontSize: BZFontSize.subTitle, color: greyColor),
        isCollapsed: true,
        isDense: true,
        filled: true,
        fillColor: backgroudColor,
        border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).dividerColor)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor)),
        contentPadding: const EdgeInsets.all(8),
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }
}
