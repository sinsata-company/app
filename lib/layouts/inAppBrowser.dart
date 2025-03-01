import 'package:flutter/material.dart';

class InAppBrowser extends StatefulWidget {
  final String url;
  final String? title;
  const InAppBrowser({super.key, required this.url, this.title});

  @override
  State<InAppBrowser> createState() => _InAppBrowserState();
}

class _InAppBrowserState extends State<InAppBrowser> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
