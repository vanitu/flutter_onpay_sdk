import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_onpay_sdk/flutter_onpay_sdk.dart';

OnPayOrder _order() {
  return OnPayOrder(
    amount: 10,
    payFor: 'Продукт 2',
    payMode: 'fix',
    recipient: 'cloud_sciencejet_net',
    userEmail: 'some@mail.ru',
    note: "Короткая заметка о продукте",
  );
}

void main() {
  testWidgets('Able to open WebForm', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    OnPayOrder order = _order();

    await tester.pumpWidget(MyWidget(order: order));
    expect(find.text('openForm'), findsOneWidget);

    await tester.tap(find.text('openForm'));
    await tester.pump();
  });
}

class MyWidget extends StatelessWidget {
  const MyWidget({Key? key, required this.order}) : super(key: key);

  final OnPayOrder order;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text("TEST"),
        ),
        body: Center(
          child: OutlinedButton(
            child: const Text("openForm"),
            onPressed: () => _openPaymentForm(context),
          ),
        ),
      ),
    );
  }

  void _openPaymentForm(BuildContext context) async {
    OnPayResult result = await OnPaySdk.openPaymentForm(context, order);
  }
}
