class DataModelsPayResponse {
  DataModelsPayResponse({
    required this.poPsiDataRequest,
    required this.orderKey,
  });
  late final _PoPsiDataRequest poPsiDataRequest;
  late final String orderKey;

  DataModelsPayResponse.fromJson(Map<String, dynamic> json) {
    orderKey = json["order_key"];
    poPsiDataRequest = _PoPsiDataRequest.fromJson(json['po_psi_data_request']);
  }

  String get postUrl => poPsiDataRequest.route.action;
  Map<String, String> get postData {
    Map<String, String> newData = {};
    poPsiDataRequest.data.forEach((key, value) {
      newData[key] = value.toString();
    });
    return newData;
  }
}

class _PoPsiDataRequest {
  _PoPsiDataRequest({
    required this.route,
    required this.data,
  });
  late final _Route route;
  late final Map<String, dynamic> data;

  _PoPsiDataRequest.fromJson(Map<String, dynamic> json) {
    route = _Route.fromJson(json['route']);
    data = Map<String, dynamic>.from(json['data']);
  }

  String get url => route.action;
}

class _Route {
  _Route({
    required this.action,
    required this.method,
  });
  late final String action;
  late final String method;

  _Route.fromJson(Map<String, dynamic> json) {
    action = json['action'];
    method = json['method'];
  }
}
