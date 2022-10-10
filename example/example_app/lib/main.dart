import 'package:flutter/material.dart';
import 'package:flutter_onpay_sdk/flutter_onpay_sdk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'OnPay SDK Demo',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: const MyHomePage(title: 'OnPay SDK Demo'));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: orders.map((order) => _saleItem(order)).toList(),
        ),
      ),
    );
  }

  List<OnPayOrder> orders = [
    OnPayOrder(
      reference: "SALE1",
      amount: 0.99,
      payFor: 'Продукт 1',
      payMode: 'fix',
      recipient: 'cloud_sciencejet_net',
      userEmail: 'some@mail.ru',
      note: "Вернет ошибку",
    ),
    OnPayOrder(
      reference: "Пример Карты CRD",
      payFor: 'Пример Карты CRD',
      amount: 10,
      recipient: 'cloud_sciencejet_net',
      userEmail: 'some@mail.ru',
      note: "Короткая заметка о продукте. Оплата возможна",
      interfaceTicker: 'CRD',
    ),
    OnPayOrder(
        reference: "Пример Карты UNR",
        payFor: 'Пример Карты UNR',
        amount: 10,
        recipient: 'cloud_sciencejet_net',
        userEmail: 'some@mail.ru',
        note: "Короткая заметка о продукте. Оплата возможна",
        interfaceTicker: 'UNR'),
  ];

  Widget _saleItem(OnPayOrder order) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: Card(
          child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Expanded(child: Icon(Icons.card_giftcard, size: 30), flex: 1),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Text(order.payFor),
                Text(order.note ?? ""),
                Text("${order.amount} ${order.ticker}"),
                OutlinedButton(
                  onPressed: () => _openPaymentForm(order),
                  child: const Text("купить"),
                )
              ],
            ),
          ),
        ],
      )),
    );
  }

  void _openPaymentForm(OnPayOrder order) async {
    OnPayResult result = await OnPaySdk.openPaymentForm(context, order);
    print("_openPaymentForm RESULT: ${result.status.toString()}");

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
