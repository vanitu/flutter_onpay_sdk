import 'dart:convert';
import 'package:flutter_onpay_sdk/data_models/pay_order.dart';
import 'package:flutter_onpay_sdk/data_models/pay_response.dart';
import 'package:http/http.dart' as http;
import '../data_models/qr_pay_response.dart';
import 'protocol_utils.dart';

class OnPayPaymentApi {
  final String baseUrl;

  OnPayPaymentApi({this.baseUrl = "secure.onpay.ru"});

  Future<DataModelsPayResponse> pay(OnPayOrder order) async {
    Map<String, dynamic> json = await _firePayRequest(OnPayProtocolUtils.toPayApi(order));
    return DataModelsPayResponse.fromJson(json);
  }

  Future<DataModelsQrPayResponse> sbpPay(OnPayOrder order) async {
    Map<String, dynamic> json = await _firePayRequest(OnPayProtocolUtils.toSbpApi(order));
    return DataModelsQrPayResponse.fromJson(json);
  }

  Uri qrCodeUrl(OnPayOrder order) {
    Map<String, dynamic> params = {
      "f": "1",
      "price": order.amount.toString(),
      "pay_for": order.payFor,
      "pay_mode": order.payMode,
      "url_success_enc": order.urlSuccessEnc,
      "url_fail_enc": order.urlFailEnc,
      "user_email": order.userEmail,
    };
    return Uri.https(baseUrl, "pay/${order.recipient}", params);
  }

  Future<Map<String, dynamic>> _firePayRequest(Map<String, dynamic>? body) async {
    http.Client client = http.Client();
    try {
      var response = await client.post(
        Uri.https(baseUrl, 'pay'),
        headers: {"Content-Type": "application/json"},
        body: body != null ? jsonEncode(body) : null,
      );

      Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      if (json["order_key"] == null) {
        throw Exception("${json["errors"]}");
      }
      return json;
    } finally {
      client.close();
    }
  }
}
