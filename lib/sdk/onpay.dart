import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_onpay_sdk/data_models/pay_method.dart';
import 'package:flutter_onpay_sdk/data_models/pay_order.dart';
import 'package:flutter_onpay_sdk/data_models/pay_result.dart';
import 'package:flutter_onpay_sdk/widgets/pay_form_web_view.dart';

import '../widgets/qr_web_view.dart';
import '../widgets/sbp_web_view.dart';

class OnPaySdk {
  static Future<OnPayResult> openPaymentForm(BuildContext context, OnPayOrder order, {OnPayMethod method = OnPayMethod.api}) async {
    try {
      OnPayResult result = await Navigator.push(context, _buildRoute(context, order, method));
      return result;
    } catch (e) {
      log("EXCEPTION openPaymentForm: $e", level: 3);
      return OnPayResult(order, OnPayResultCode.fail);
    }
  }

  static MaterialPageRoute _buildRoute(BuildContext context, OnPayOrder order, OnPayMethod method) {
    switch (method) {
      case OnPayMethod.api:
        return MaterialPageRoute(builder: (context) => OnPayWebViewForm(order: order));
      case OnPayMethod.sbp:
        return MaterialPageRoute(builder: (context) => SbpWebView(order: order));
      case OnPayMethod.qrCode:
        return MaterialPageRoute(builder: (context) => QrCodeWebView(order: order));
    }
  }
}
