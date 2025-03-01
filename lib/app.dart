
import 'package:flutter/material.dart';
import 'package:sinsata_app/layouts/blank.dart';
import 'package:url_launcher/url_launcher.dart';

class MyApp extends StatelessWidget {
  final bool updateRequired;

  const   MyApp({required this.updateRequired});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sinsata 선생님용',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: updateRequired ? ForceUpdatePage() : const BlankLayout(url: "/manage", title: "title"),
    );
  }
}

class ForceUpdatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AlertDialog(
        title: Text("업데이트 필요"),
        content: Text("새로운 버전이 출시되었습니다. 업데이트 후 사용해주세요."),
        actions: [
          TextButton(
            onPressed: () async {
              Uri url = Uri.parse("https://your-app-store-url");
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              }
            },
            child: Text("업데이트 하기"),
          ),
        ],
      ),
    );
  }
}