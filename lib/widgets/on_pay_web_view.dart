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

abstract class OnPayWebView extends StatefulWidget {
  const OnPayWebView({Key? key}) : super(key: key);

  OnPayOrder get order;
}

abstract class OnPayWebViewState<T extends OnPayWebView> extends State<OnPayWebView> {
  late WebViewController controller;

  OnPayPaymentApi onpay = OnPayPaymentApi();
  OnPayResultCode result = OnPayResultCode.notCompleted;

  @override
  void initState() {
    super.initState();
    controller = buildWebViewController();
    loadStartingPage();
  }

  WebViewController buildWebViewController() {
    return WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(_navigationDelegate);
  }

  NavigationDelegate get _navigationDelegate {
    return NavigationDelegate(
        onProgress: (int progress) {
          log('WebView is loading (progress : $progress%)');
        },
        onPageStarted: (String url) {
          log('WebView Page started loading: $url');
        },
        onPageFinished: (String url) {
          log('WebView Page finished loading: $url');
        },
        onNavigationRequest: _onNavigationRequest);
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
              return WebViewWidget(
                controller: controller,
              );
            }),
          ),
        ),
      ),
    );
  }

  NavigationDecision _onNavigationRequest(NavigationRequest request) {
    if (request.url.startsWith(widget.order.urlSuccessEnc)) {
      result = OnPayResultCode.success;
      _popWithResult();
      return NavigationDecision.prevent;
    }

    if (request.url.startsWith(widget.order.urlFailEnc)) {
      result = OnPayResultCode.fail;
      _popWithResult();
      return NavigationDecision.prevent;
    }

    return NavigationDecision.navigate;
  }

  Future<void> loadStartingPage() async {
    try {
      await controller.loadHtmlString(loadingPage);
      await redirectToPayment();
    } catch (e) {
      result = OnPayResultCode.fail;
      log("WebView error $e");
      _popWithResult("$e");
    }
  }

  Future<void> redirectToPayment();

  Future<bool> _popWithResult([String? message]) {
    Navigator.pop(context, OnPayResult(widget.order, result, message: message));
    return Future.value(false);
  }
}
