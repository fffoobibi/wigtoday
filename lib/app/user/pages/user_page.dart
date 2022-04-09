import 'package:flutter/material.dart';
import 'package:wigtoday_app/app/user/pages/userinfo_page.dart';
import 'package:wigtoday_app/utils/color.dart';
import 'package:wigtoday_app/widgets/components.dart';


class UserPage extends StatefulWidget {
  const UserPage({ Key? key }) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> with Components{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('User'),
      // ),
      // backgroundColor:isDark(context) ? BZColor.darkBackground: BZColor.background ,
      body: const UserInfoPage()
    );
  }
}