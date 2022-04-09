import 'package:flutter/material.dart';
import 'package:wigtoday_app/utils/size.dart';
import 'package:wigtoday_app/widgets/components.dart';

class NewPassWord extends StatefulWidget {
  NewPassWord({Key? key}) : super(key: key);

  @override
  State<NewPassWord> createState() => _NewPassWordState();
}

class _NewPassWordState extends State<NewPassWord> with Components {
  @override
  Widget build(BuildContext context) {
    var height = 10.0;
    var url = 'https://p0.ssl.img.360kuai.com/t016e2f42c2f1145dc5.webp';

    return Scaffold(
      body: SingleChildScrollView(
          child: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Stack(children: [
            Column(
              children: [
                const SizedBox(height: 20),
                ClipOval(
                    child: Image.network(
                  url,
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                )),
                SizedBox(height: height),
                const Text(
                  '15565465456@qq.com',
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                SizedBox(height: height),
                const Text('A verification code has been sent to your E-mail!',
                    style: TextStyle(
                        color: Color(0xff444444),
                        fontFamily: 'SF Pro',
                        fontSize: 14)),
                SizedBox(height: height * 3),
                Form(
                    child: Column(
                  children: [
                    createInputField('Password', width: double.infinity),
                    SizedBox(height: height * 2),
                    createInputField('Confirm Password', width: double.infinity)
                  ],
                )),
                SizedBox(height: height * 4),
                createButton('SUBMIT')
              ],
            ),
            Positioned(
                right: 0,
                child: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.close), iconSize: 50,))
          ]),
        ),
      )),
    );
  }
}
