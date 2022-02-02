// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_onpay_sdk/api/gateway.dart';
import 'package:flutter_onpay_sdk/data_models/pay_order.dart';
import 'package:flutter_onpay_sdk/data_models/pay_response.dart';
import 'package:flutter_onpay_sdk/data_models/pay_result.dart';
import 'package:webview_flutter/webview_flutter.dart';

//void main() => runApp(MaterialApp(home: WebViewExample()));

const String loadingPage = '''
<!DOCTYPE html><html>
<head><title>Payment form loading</title></head>
<body>
<p>
Please wait...
</p>
</body>
</html>
''';

class OnPayWebViewForm extends StatefulWidget {
  const OnPayWebViewForm({Key? key, required this.order}) : super(key: key);
  final OnPayOrder order;
  // final void Function(OnPayOrder order)? onSuccess;
  // final void Function(OnPayOrder order)? onFail;

  @override
  _OnPayWebViewFormState createState() => _OnPayWebViewFormState();
}

class _OnPayWebViewFormState extends State<OnPayWebViewForm> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();

  OnPayPaymentApi onpay = OnPayPaymentApi();
  OnPayResultCode result = OnPayResultCode.notCompleted;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _popWithResult,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Безопасный шлюз'),
        ),
        body: SafeArea(
          child: Center(
            child: Builder(builder: (BuildContext context) {
              return WebView(
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                  _loadStartingPage(webViewController, context);
                },
                onProgress: (int progress) {
                  log('WebView is loading (progress : $progress%)');
                },
                onPageStarted: (String url) {
                  log('Page started loading: $url');
                },
                onPageFinished: (String url) {
                  log('Page finished loading: $url');
                },
                navigationDelegate: _navigationDelegate,
                gestureNavigationEnabled: true,
              );
            }),
          ),
        ),
      ),
    );
  }

  NavigationDecision _navigationDelegate(NavigationRequest request) {
    if (request.url.startsWith(widget.order.urlSuccessEnc)) {
      log('blocking navigation to $request}');
      result = OnPayResultCode.success;
      _popWithResult();
      return NavigationDecision.prevent;
    }

    if (request.url.startsWith(widget.order.urlFailEnc)) {
      log('blocking navigation to $request}');
      result = OnPayResultCode.fail;
      _popWithResult();
      return NavigationDecision.prevent;
    }

    log('allowing navigation to $request');
    return NavigationDecision.navigate;
  }

  Future<void> _loadStartingPage(WebViewController controller, BuildContext context) async {
    try {
      final String contentBase64 = base64Encode(const Utf8Encoder().convert(loadingPage));
      await controller.loadUrl('data:text/html;base64,$contentBase64');
      await _redirectToPayment(controller, context);
    } catch (e) {
      result = OnPayResultCode.fail;
      _popWithResult("$e");
    }
  }

  Future<void> _redirectToPayment(WebViewController controller, BuildContext context) async {
    DataModelsPayResponse postData = await onpay.pay(widget.order);
    Uri pathUrl = Uri.parse(postData.postUrl);
    Uri outgoingUri = Uri(scheme: pathUrl.scheme, host: pathUrl.host, port: pathUrl.port, path: pathUrl.path, queryParameters: postData.postData);

    final WebViewRequest request = WebViewRequest(
      uri: outgoingUri,
      method: WebViewRequestMethod.post,
      headers: <String, String>{'Content-Type': 'text/html'},
    );
    await controller.loadRequest(request);
  }

  Future<bool> _popWithResult([String? message]) {
    log("_popWithResult fired ${result.toString()}");
    Navigator.pop(context, OnPayResult(widget.order, result, message: message));
    return Future.value(false);
  }
}
