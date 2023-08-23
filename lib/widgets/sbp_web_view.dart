import 'package:webview_flutter/webview_flutter.dart';
import '../data_models/pay_order.dart';
import '../data_models/qr_pay_response.dart';
import 'on_pay_web_view.dart';

class SbpWebView extends OnPayWebView {
  const SbpWebView({super.key, required this.order});

  @override
  final OnPayOrder order;

  @override
  QrCodeWebViewState createState() => QrCodeWebViewState();
}

class QrCodeWebViewState extends OnPayWebViewState<SbpWebView> {
  @override
  Future<void> redirectToPayment() async {
    DataModelsQrPayResponse postData = await onpay.sbpPay(widget.order);
    Uri outgoingUri = Uri.parse(postData.qrCodeUrl);
    // print("URL: ${outgoingUri}");
    return controller.loadRequest(outgoingUri, method: LoadRequestMethod.get, headers: <String, String>{'Content-Type': 'text/html'});
  }
}
