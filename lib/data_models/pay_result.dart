import 'package:flutter_onpay_sdk/data_models/pay_order.dart';

enum OnPayResultCode { success, fail, notCompleted }

class OnPayResult {
  final OnPayOrder order;
  final OnPayResultCode status;
  final String? message;

  OnPayResult(this.order, this.status, {this.message});
}
