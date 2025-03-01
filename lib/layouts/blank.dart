import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class BlankLayout extends StatefulWidget {
  final String url;
  final String? title;

  const BlankLayout({super.key, required this.url, required this.title});

  @override
  State<BlankLayout> createState() => _BlankLayoutState();
}

class _BlankLayoutState extends State<BlankLayout> {
  InAppWebViewSettings options = InAppWebViewSettings(
      useShouldOverrideUrlLoading: true,
      // URL 로딩 제어
      mediaPlaybackRequiresUserGesture: false,
      // 미디어 자동 재생
      javaScriptEnabled: true,
      // 자바스크립트 실행 여부
      javaScriptCanOpenWindowsAutomatically: true,

      // 팝업 여부
      useHybridComposition: true,
      // 하이브리드 사용을 위한 안드로이드 웹뷰 최적화
      supportMultipleWindows: true,
      // 멀티 윈도우 허용
      allowsInlineMediaPlayback: true,

      // 웹뷰 내 미디어 재생 허용
      //   ios 관련
      enableViewportScale: true,
      ignoresViewportScaleLimits: true);
  InAppWebViewController? controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
              child: InAppWebView(
            initialSettings: options,
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                  cacheEnabled: true,
                  javaScriptEnabled: true,
                  userAgent:
                      "Mozilla/5.0 (Linux; Android 9; LG-H870 Build/PKQ1.190522.001) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/83.0.4103.106 Mobile Safari/537.36"),
            ),
            onReceivedServerTrustAuthRequest: (controller, challenge) async {
              return ServerTrustAuthResponse(
                  action: ServerTrustAuthResponseAction.PROCEED);
            },
            onConsoleMessage: (controller, consoleMessage) {
              // 콘솔 메시지를 Flutter 디버그 콘솔에 출력
              print("Console Message: ${consoleMessage.message}");
            },
            initialUrlRequest:
                //
                // URLRequest(url: WebUri('http://localhost:3000${widget.url}')),
                URLRequest(
                    url: WebUri('https://www.sinsata.co.kr/${widget.url}')),
            // URLRequest(url: WebUri('https://naver.com')),
            // initialUrlRequest: URLRequest(
            //     url: WebUri(
            //         'http://3.37.179.36:3000/nice-form?token_version_id=2024071821330006-NCDACC933-DF9AC-B0EADE12C8&enc_data=ru6Y6WarqeThQzTDpzptG7S8sKha9oPPN3%2BeMCn8OSrQHUXb5Iwg7mjXOvil84i7noMkgFEanmNIdbbVt/rj9g19mDp7nuDjaD4t25TP7e6Xv4BkwdfqqepnGcownII%2B/fWip37G8SeFlwOEiiRoXgY6wD9GeinobEnHpLbwgXpxt8KhVMnApJuOp2IiNJFMj0659AuBcR/lSNxzf%2B62Q93Z9rUbxH%2BX2RE61XeXStrTzjVbXN1V78wVYZX0qFPeAU6L39TIxcnYOMt8LYdy1xxBzwpS93SvppjRnTsb3Z4sovdnyrk9l9pmrdDIG9InjCMVvZtSeE5ukpHHWQoqOto1c7FLUXI/VHEjzRfBBu/enmqOCFl/cz0QP0oOQv4k48obVHnZbGPDrjgSc85bDGUKfDHJEiLjksDURQ%2BUjjT7MHDd55qZsOTiCVPfWP4UxeQu00I%2BHFp44Y6T%2BitzPT7NpW/jkZlBevEKPSbK5TQ=&integrity_value=lAejFM8ebY5esR7IcwVBR1O2TCbNu59XA0KnOsFYKxY=')),
            onWebViewCreated: (controller) async {
              controller = controller;
              await controller.addWebMessageListener(WebMessageListener(
                  jsObjectName: 'bridge',
                  onPostMessage: (message, url, isPost, proxy) async {
                    Map<String, dynamic> data = json.decode(message?.data);
                    String? key = data['key'];
                    dynamic value = data['value'];
                    switch (key) {
                      case 'router:push':
                        String url = data['url'];
                        print(url);
                        // String? title = value['title'];
                        if (context.mounted) {
                          // 입력된 값에 따라 Flutter 페이지 전환
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BlankLayout(url: url, title: "" ?? ''),
                            ),
                          );
                        }
                        break;
                      case 'router:pop':
                        Navigator.pop(context);
                        // ...
                        break;
                      case 'router:replace':
                        String url = data['url'];
                        // String? title = value['title'];
                        if (context.mounted) {
                          // 입력된 값에 따라 Flutter 페이지 전환
                          print(url);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BlankLayout(url: url, title: "" ?? ''),
                            ),
                          );
                        }
                        break;

                      default:
                        break;
                    }
                  }));
            },
            onLoadStop: (controller, url) async {
              if (url?.path == "/web/register/login") {
                print(url?.queryParameters);
              }
            },
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              var uri = navigationAction.request.url!;
              print("Override URL: ${uri.toString()}");

              // 여기에서 필요한 로직을 구현하고 원하는 동작을 수행할 수 있어요.
              // 예를 들어 특정 URL로의 이동을 막을 수 있어요.
              return NavigationActionPolicy
                  .ALLOW; // 허용하거나 NavigationActionPolicy.CANCEL로 막을 수 있어요.
            },
          )),
        ));
  }
}
