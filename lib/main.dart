import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:sinsata_app/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sinsata_app/service/UpdateChecker.dart';
import 'firebase_options.dart';
import 'package:url_launcher/url_launcher.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("백그라운드에서 메시지 수신: ${message.messageId}");
}

Future<void> requestNotificationPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('사용자가 알림을 허용함');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('사용자가 임시 알림을 허용함');
  } else {
    print('사용자가 알림을 거부함');
  }
}
Future<void> getFCMToken() async {
  String? token = await FirebaseMessaging.instance.getToken();
  print("FCM Token: $token");
}

void main()async  {
  WidgetsFlutterBinding.ensureInitialized();

  // runApp() 호출 전 Flutter SDK 초기화


    // Firebase 중복 초기화 방지
    if (Firebase.apps.isEmpty) {

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
    }
  bool updateRequired = await UpdateChecker.isUpdateRequired();

  requestNotificationPermission();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp(updateRequired: updateRequired));
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
              exit(9);
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

// ...


