import 'package:flutter/material.dart';

import 'package:wigtoday_app/api/user.dart';
import 'package:wigtoday_app/app/user/pages/address_edit_page.dart';
import 'package:wigtoday_app/utils/color.dart';
import 'package:wigtoday_app/utils/font.dart';
import 'package:wigtoday_app/utils/size.dart';
import 'package:wigtoday_app/utils/theme.dart';
import 'package:wigtoday_app/widgets/button.dart';
import 'package:wigtoday_app/app/user/models/address.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class AddressListPage extends StatefulWidget {
  const AddressListPage({Key? key}) : super(key: key);

  @override
  State<AddressListPage> createState() => _AddressListPageState();
}

class _AddressListPageState extends State<AddressListPage> {
  final List<AddressModel> _addresses = ApiUser.getAddressList();

  @override
  Widget build(BuildContext context) {
    double _kBottomHeight = 40;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.addressList),
      ),
      body: ListView.builder(
        padding: EdgeInsets.fromLTRB(8, 8, 8, _kBottomHeight + BZSize.bottomBarHeight + 8),
        shrinkWrap: true,
        itemCount: _addresses.length,
        itemBuilder: (context, index) => _listTile(index),
      ),
      bottomSheet: _addButton(_kBottomHeight),
    );
  }


  Widget _listTile(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Ink(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: Row(
          children: [
            Image.asset('assets/icons/order-address.png', fit: BoxFit.cover, width: 24, height: 24,),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _title(_addresses[index]),
                  const SizedBox(height: 5),
                  _subTitle(_addresses[index]),
                ],
              ),
            ),
            _editButton(),
          ],
        ),
      ),
    );
  }


  Widget _title(AddressModel address) {
    Color titleColor = BZTheme.isDark(context) ? BZColor.darkTitle : BZColor.title;
    Color semiColor = BZTheme.isDark(context) ? BZColor.darkSemi : BZColor.semi;
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: address.contact,
            style: TextStyle(
              fontSize: BZFontSize.title,
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
          ),
          const WidgetSpan(child: SizedBox(width: 12)),
          TextSpan(
            text: address.phone,
            style: TextStyle(
              fontSize: BZFontSize.subTitle,
              color: semiColor,
            ),
          ),
        ],
      ),
    );
  }


  Widget _subTitle(AddressModel address) {
    return Text(
      address.address,
      maxLines: 2,
      style: TextStyle(
        fontSize: BZFontSize.subTitle,
        color: BZTheme.isDark(context) ? BZColor.darkTitle : BZColor.title,
      ),
    );
  }


  Widget _editButton() {
    return IconButton(
      icon: Icon(Icons.edit, size: 20, color: BZTheme.isDark(context) ? BZColor.darkSemi : BZColor.semi,),
      onPressed: () {},
    );
  }


  Widget _addButton(double height) {
    return Container(
      alignment: Alignment.center,
      height: height + BZSize.bottomBarHeight,
      padding: EdgeInsets.only(bottom: BZSize.bottomBarHeight),
      color: Colors.transparent,
      child: BZTextButton(
        text: AppLocalizations.of(context)!.addAddress,
        fontWeight: FontWeight.bold,
        fontSize: BZFontSize.title,
        height: height,
        width: BZSize.pageWidth - 24,
        radius: 8,
        foregroundColor: Colors.white,
        gradient: const LinearGradient(colors: [BZColor.gradStart, BZColor.gradEnd]),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddressEditPage()),
          );
        },
      ),
    );
  }
}
