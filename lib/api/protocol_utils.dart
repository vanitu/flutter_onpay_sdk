import 'package:flutter_onpay_sdk/data_models/pay_order.dart';

class OnPayProtocolUtils {
  static Map<String, dynamic> toPayApi(OnPayOrder order) {
    final data = <String, String?>{};
    data['user_email'] = order.userEmail;
    data['pay_for'] = order.payFor;
    data['receive_amount'] = order.amount.toString();
    data['ticker'] = order.ticker;
    data['interface_ticker'] = order.interfaceTicker;
    data['recipient'] = order.recipient;
    data['pay_mode'] = order.payMode;
    data['pay_amount'] = order.amount.toString();
    data['url_success_enc'] = order.urlSuccessEnc;
    data['url_fail_enc'] = order.urlFailEnc;
    order.additionalParams.forEach((key, value) => data["onpay_ap_$key"] = value);
    return data;
  }

  static Map<String, dynamic> toSbpApi(OnPayOrder order) {
    final data = <String, dynamic>{
      "receive_amount": order.amount,
      "ticker": order.ticker,
      "interface_ticker": 'QRW',
      "pay_for": order.payFor,
      "user_email": order.userEmail,
      "recipient": order.recipient,
      "is_mobile": true,
      "price_final": false,
      "pay_mode": order.payMode,
      "fast": false,
      "convert": "yes",
      "form_version": "1",
      "ln": "ru",
      "url_success_enc": order.urlSuccessEnc,
      "url_fail_enc": order.urlFailEnc,
    };

    order.additionalParams.forEach((key, value) => data["onpay_ap_$key"] = value);
    return data;
  }
}
