import 'package:flutter/material.dart';

class BZLoadingWidget extends StatefulWidget {
  BZLoadingWidget(
      {Key? key,
      required this.child,
      this.futureFunc,
      this.loadingBuilder,
      this.errorBuilder})
      : super(key: key);

  Widget child;
  bool _isLoading = false;
  Future<dynamic> Function()? futureFunc;
  Widget Function(BuildContext)? loadingBuilder;
  Widget Function(BuildContext)? errorBuilder;

  @override
  // ignore: no_logic_in_create_state
  State<BZLoadingWidget> createState() => _BZLoadingWidgetState(
      child: child,
      futureFunc: futureFunc,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder);
}

class _BZLoadingWidgetState extends State<BZLoadingWidget> {
  Widget child;
  bool _isLoading = false;
  Future<dynamic> Function()? futureFunc;
  Widget Function(BuildContext)? loadingBuilder;
  Widget Function(BuildContext)? errorBuilder;

  _BZLoadingWidgetState(
      {required this.child,
      this.futureFunc,
      this.loadingBuilder,
      this.errorBuilder});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _isLoading ? loadingBuilder!(context) : child,
    );
  }
}
