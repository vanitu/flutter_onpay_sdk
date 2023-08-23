class OnPayOrder {
  OnPayOrder({
    required this.recipient,
    required this.userEmail,
    required this.payFor,
    required this.amount,
    this.reference,
    this.payMode = "fix",
    this.ticker = "RUR",
    this.interfaceTicker = "CRW", // CreditCards Payment gateway
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
    final data = <String, String?>{};
    data['user_email'] = userEmail;
    data['pay_for'] = payFor;
    data['receive_amount'] = amount.toString();
    data['ticker'] = ticker;
    data['interface_ticker'] = interfaceTicker;
    data['recipient'] = recipient;
    data['pay_mode'] = payMode;
    data['pay_amount'] = amount.toString();
    data['url_success_enc'] = urlSuccessEnc;
    data['url_fail_enc'] = urlFailEnc;
    additionalParams.forEach((key, value) => data["onpay_ap_$key"] = value);
    return data;
  }
}
