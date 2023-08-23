import 'package:webview_flutter/webview_flutter.dart';

import '../data_models/pay_order.dart';
import 'on_pay_web_view.dart';

class QrCodeWebView extends OnPayWebView {
  const QrCodeWebView({super.key, required this.order});

  @override
  final OnPayOrder order;

  @override
  QrCodeWebViewState createState() => QrCodeWebViewState();
}

class QrCodeWebViewState extends OnPayWebViewState<QrCodeWebView> {
  @override
  Future<void> redirectToPayment() async {
    Uri outgoingUri = onpay.qrCodeUrl(widget.order);
    return controller.loadRequest(outgoingUri, method: LoadRequestMethod.get, headers: <String, String>{'Content-Type': 'text/html'});
  }
}
