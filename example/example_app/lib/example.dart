// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_onpay_sdk/data_models/pay_method.dart';
import 'package:flutter_onpay_sdk/data_models/pay_order.dart';
import 'package:flutter_onpay_sdk/data_models/pay_result.dart';
import 'package:flutter_onpay_sdk/sdk/onpay.dart';

class ExampleAppMyHomePage extends StatefulWidget {
  const ExampleAppMyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<ExampleAppMyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ExampleAppMyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _apiPayment(),
            _apiFailedPayment(),
            _sbpPayment(),
            _qrCodePayment(),
          ],
        ),
      ),
    );
  }

  Widget _apiFailedPayment() {
    OnPayOrder order = OnPayOrder(
      reference: "SALE1",
      amount: 0.99,
      payFor: 'Оплата картой',
      payMode: 'fix',
      recipient: 'cloud_sciencejet_net',
      userEmail: 'some@mail.ru',
      interfaceTicker: 'UNR',
      note: "Вернет ошибку",
    );
    return _saleItem(order, () => _openPaymentForm(order));
  }

  Widget _apiPayment() {
    OnPayOrder order = OnPayOrder(
      reference: "SALE2",
      payFor: 'Продукт 2',
      amount: 10,
      recipient: 'onpay',
      userEmail: 'some@mail.ru',
      interfaceTicker: 'UNR',
      note: "Короткая заметка о продукте. Оплата возможна",
    );
    return _saleItem(order, () => _openPaymentForm(order));
  }

  Widget _sbpPayment() {
    OnPayOrder order = OnPayOrder(
      reference: "SALE3",
      payFor: 'Оплата СБП',
      amount: 20,
      recipient: 'onpay',
      userEmail: 'some@mail.ru',
      interfaceTicker: 'QRW',
      note: "Оплата через систему СБП",
    );
    return _saleItem(order, () => _openPaymentForm(order, method: OnPayMethod.sbp));
  }

  Widget _qrCodePayment() {
    OnPayOrder order = OnPayOrder(
      reference: "SALE3",
      payFor: 'QR код для оплаты',
      amount: 20,
      recipient: 'onpay',
      userEmail: 'some@mail.ru',
      interfaceTicker: '',
      note: "QR-code для оплаты",
    );
    return _saleItem(order, () => _openPaymentForm(order, method: OnPayMethod.qrCode));
  }

  Widget _saleItem(OnPayOrder order, void Function() onPressed) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: Card(
          child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Expanded(flex: 1, child: Icon(Icons.card_giftcard, size: 30)),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Text(order.payFor),
                Text(order.note ?? ""),
                Text("${order.amount} ${order.ticker}"),
                OutlinedButton(
                  onPressed: onPressed,
                  child: const Text("купить"),
                )
              ],
            ),
          ),
        ],
      )),
    );
  }

  void _openPaymentForm(OnPayOrder order, {OnPayMethod method = OnPayMethod.api}) async {
    OnPayResult result = await OnPaySdk.openPaymentForm(context, order, method: method);
    print("_openPaymentForm RESULT: ${result.status.toString()}");
    print("_openPaymentForm RESULT: ${result.message}");

    String msg;
    switch (result.status) {
      case OnPayResultCode.success:
        msg = "ОПЛАЧЕНО";
        break;
      case OnPayResultCode.fail:
        msg = "Ошибка оплаты";
        break;
      case OnPayResultCode.notCompleted:
        msg = "Оплата не закончена";
        break;
    }

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('${result.order.payFor}: $msg [${result.message}]')));
  }
}
