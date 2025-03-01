import 'package:flutter/material.dart';

class TransparentLayout extends StatefulWidget {
  final String url;
  final String? title;
  const TransparentLayout({super.key, required this.url, this.title});

  @override
  State<TransparentLayout> createState() => _TransparentLayoutState();
}

class _TransparentLayoutState extends State<TransparentLayout> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
