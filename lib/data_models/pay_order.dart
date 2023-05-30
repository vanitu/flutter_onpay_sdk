class OnPayOrder {
  OnPayOrder({
    required this.recipient,
    required this.userEmail,
    required this.payFor,
    required this.amount,
    this.reference,
    this.payMode = "fix",
    this.ticker = "RUR",
    this.interfaceTicker = "CRD", // CreditCards Payment gateway
    this.note,
    this.additionalParams = const {},
  });
  late final String userEmail;
  late final String payFor;
  late final double amount;
  late final String ticker;
  late final String interfaceTicker;
  late final String recipient;
  late final String payMode;

  late final String? note;
  late final String? reference;

  late final Map<String, String> additionalParams;

  final String urlSuccessEnc = "https://onpay.ru/sdk_success";
  final String urlFailEnc = "https://onpay.ru/sdk_fail";

  Map<String, String?> toJson() {
    final _data = <String, String?>{};
    _data['user_email'] = userEmail;
    _data['pay_for'] = payFor;
    _data['receive_amount'] = amount.toString();
    _data['ticker'] = ticker;
    _data['interface_ticker'] = interfaceTicker;
    _data['recipient'] = recipient;
    _data['pay_mode'] = payMode;
    _data['pay_amount'] = amount.toString();
    _data['url_success_enc'] = urlSuccessEnc;
    _data['url_fail_enc'] = urlFailEnc;
    additionalParams.forEach((key, value) => _data["onpay_ap_$key"] = value);
    return _data;
  }
}
