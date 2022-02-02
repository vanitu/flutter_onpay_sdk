import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_onpay_sdk/data_models/pay_order.dart';
import 'package:flutter_onpay_sdk/data_models/pay_result.dart';
import 'package:flutter_onpay_sdk/widgets/pay_form_web_view.dart';

class OnPaySdk {
  static Future<OnPayResult> openPaymentForm(BuildContext context, OnPayOrder order) async {
    try {
      OnPayResult result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OnPayWebViewForm(order: order)),
      );
      return result;
    } catch (e) {
      log("EXCEPTION openPaymentForm: $e", level: 3);
      return OnPayResult(order, OnPayResultCode.fail);
    }
  }
}
