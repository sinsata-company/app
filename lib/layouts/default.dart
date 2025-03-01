import 'package:flutter/material.dart';

class DefaulLayout extends StatefulWidget {
  final String url;
  final String? title;
  const DefaulLayout({super.key, required this.url ,this.title});

  @override
  State<DefaulLayout> createState() => _DefaulLayoutState();
}

class _DefaulLayoutState extends State<DefaulLayout> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
