class DataModelsQrPayResponse {
  DataModelsQrPayResponse({
    required this.orderKey,
  });
  late final String orderKey;
  late final RedirectTo redirectTo;

  DataModelsQrPayResponse.fromJson(Map<String, dynamic> json) {
    orderKey = json["order_key"];
    redirectTo = RedirectTo.fromJson(json['redirect_to']);
  }

  String get qrCodeUrl => redirectTo.url;
}

class RedirectTo {
  RedirectTo({
    required this.state,
    required this.url,
  });
  late final String state;
  late final String url;

  RedirectTo.fromJson(Map<String, dynamic> json) {
    state = json['state'];
    url = json['url'];
  }
}
