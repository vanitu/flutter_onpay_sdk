// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:developer';

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
  OnPayWebViewFormState createState() => OnPayWebViewFormState();
}

class OnPayWebViewFormState extends State<OnPayWebViewForm> {
  // final Completer<WebViewController> _controller = Completer<WebViewController>();

  late WebViewController _controller;

  OnPayPaymentApi onpay = OnPayPaymentApi();
  OnPayResultCode result = OnPayResultCode.notCompleted;

  @override
  void initState() {
    super.initState();
    _controller = _buildWebViewController();
    _loadStartingPage();
    // if (Platform.isAndroid) {
    //   WebView.platform = SurfaceAndroidWebView();
    // }
  }

  WebViewController _buildWebViewController() {
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
                controller: _controller,
              );
            }),
          ),
        ),
      ),
    );
  }

  NavigationDecision _onNavigationRequest(NavigationRequest request) {
    if (request.url.startsWith(widget.order.urlSuccessEnc)) {
      // log('blocking navigation to $request}');
      result = OnPayResultCode.success;
      _popWithResult();
      return NavigationDecision.prevent;
    }

    if (request.url.startsWith(widget.order.urlFailEnc)) {
      // log('blocking navigation to $request}');
      result = OnPayResultCode.fail;
      _popWithResult();
      return NavigationDecision.prevent;
    }

    // log('allowing navigation to $request');
    return NavigationDecision.navigate;
  }

  Future<void> _loadStartingPage() async {
    try {
      await _controller.loadHtmlString(loadingPage);
      // await _controller.loadHtmlString('data:text/html;base64,$contentBase64');
      await _redirectToPayment();
    } catch (e) {
      result = OnPayResultCode.fail;
      log("WebView error $e");
      _popWithResult("$e");
    }
  }

  Future<void> _redirectToPayment() async {
    DataModelsPayResponse postData = await onpay.pay(widget.order);
    Uri pathUrl = Uri.parse(postData.postUrl);
    Uri outgoingUri = Uri(scheme: pathUrl.scheme, host: pathUrl.host, port: pathUrl.port, path: pathUrl.path, queryParameters: postData.postData);
    return _controller.loadRequest(outgoingUri, method: LoadRequestMethod.post, headers: <String, String>{'Content-Type': 'text/html'});
  }

  Future<bool> _popWithResult([String? message]) {
    // log("_popWithResult fired ${result.toString()}");
    Navigator.pop(context, OnPayResult(widget.order, result, message: message));
    return Future.value(false);
  }
}
