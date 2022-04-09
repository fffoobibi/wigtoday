import 'package:flutter/material.dart';


class BuyerShowPage extends StatefulWidget {
  const BuyerShowPage({ Key? key }) : super(key: key);

  @override
  State<BuyerShowPage> createState() => _BuyerShowPageState();
}

class _BuyerShowPageState extends State<BuyerShowPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buyer show'),
      ),
      body: Container(),
    );
  }
}