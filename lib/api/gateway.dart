import 'dart:convert';
import 'dart:developer';
import 'package:flutter_onpay_sdk/data_models/pay_order.dart';
import 'package:flutter_onpay_sdk/data_models/pay_response.dart';
import 'package:http/http.dart' as http;

class OnPayPaymentApi {
  final String baseUrl;

  OnPayPaymentApi({this.baseUrl = "secure.onpay.ru"});

  Future<DataModelsPayResponse> pay(OnPayOrder order) async {
    http.Client client = http.Client();
    try {
      var response = await client.post(
        Uri.https(baseUrl, 'pay'),
        body: order.toJson(),
      );

      Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      log("#decoded $json}");
      if (json["order_key"] == null) {
        throw Exception("${json["errors"]}");
      }
      DataModelsPayResponse postData = DataModelsPayResponse.fromJson(json);
      return postData;
    } finally {
      client.close();
    }
  }
}
