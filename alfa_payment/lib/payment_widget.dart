import 'dart:async';

import 'package:alfa_payment/acquiring.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWidget extends StatefulWidget {
  PaymentObject paymentObject;
  AlfaAquiring alfaAquiring;

  PaymentWidget(
      {super.key, required this.paymentObject, required this.alfaAquiring});

  @override
  State<PaymentWidget> createState() => _PaymentWidgetState();
}

class _PaymentWidgetState extends State<PaymentWidget> {
  WebViewController controller = WebViewController();
  late Timer _timer;

  Future<PaymentStatus> getPaymentStatus() async {
    PaymentStatus paymentStatus = await widget.alfaAquiring
        .checkPaymentStatus(orderId: widget.paymentObject.id);
    print(paymentStatus);
    if (paymentStatus == PaymentStatus.REGISTER_WITHOUT_PAYMENT)
      return paymentStatus;
    if (paymentStatus == PaymentStatus.AUTH)
      Navigator.pop(context, paymentStatus);
    if (paymentStatus != PaymentStatus.REGISTER_WITHOUT_PAYMENT ||
        paymentStatus != PaymentStatus.AUTH) {
      // Navigator.pop(context, paymentStatus);
    }

    return paymentStatus;
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 3), (_) async {
      try {
        await getPaymentStatus();
      } catch (_) {}
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentObject.urlForPayment));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Онлайн оплата')),
      body: WebViewWidget(controller: controller),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer.cancel();
    super.dispose();
  }
}
