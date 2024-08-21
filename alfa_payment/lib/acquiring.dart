// ignore_for_file: public_member_api_docs, sort_constructors_first
library acquiring;

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'dart:developer' as developer;

class Acquiring {
  String userName;
  String password;

  Acquiring({required this.userName, required this.password});

  static String getRandom(int length) {
    const ch = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
    Random r = Random();
    return String.fromCharCodes(
        Iterable.generate(length, (_) => ch.codeUnitAt(r.nextInt(ch.length))));
  }

//  Future<void> toPay() async {}
}

enum PageViewVariants { MOBILE, DESKTOP }

enum PaymentStatus {
  REGISTER_WITHOUT_PAYMENT,
  PREAUTH,
  AUTH,
  AUTH_CANCELLED,
  PAYMENT_RETURNED,
  INIT_AUTH_BANK_ACCESS,
  AUTH_DECLINED
}

class PaymentObject {
  String id;
  PaymentStatus status;
  String urlForPayment;

  PaymentObject({
    required this.id,
    required this.status,
    required this.urlForPayment,
  });
}

class AlfaAquiring extends Acquiring {
  String returnUrl;
  String failUrl;
  String? token;
  PageViewVariants pageView;

  AlfaAquiring(
      {required super.userName,
      required super.password,
      required this.returnUrl,
      required this.pageView,
      required this.failUrl,
      this.token});

  Future<PaymentStatus> checkPaymentStatus({required String orderId}) async {
    String request = '';
    if (token != null) {
      request =
          'https://pay.alfabank.ru/payment/rest/getOrderStatusExtended.do?token=$token&orderId=$orderId';
    } else {
      request =
          'https://pay.alfabank.ru/payment/rest/getOrderStatusExtended.do?userName=$userName&password=$password&orderId=$orderId';
    }

    Dio dio = Dio();
    (dio!.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    Response response = await dio.post(request);
    int orderStatusCode = -1;
    developer.log('order status ${response.data}');
    orderStatusCode = jsonDecode(response.data)['orderStatus'];
    developer.log('order status code ${orderStatusCode}');
    print(response.data);
    switch (orderStatusCode) {
      case (0):
        return PaymentStatus.REGISTER_WITHOUT_PAYMENT;
      case (1):
        return PaymentStatus.PREAUTH;
      case (2):
        return PaymentStatus.AUTH;
      case (3):
        return PaymentStatus.AUTH_CANCELLED;
      case (4):
        return PaymentStatus.PAYMENT_RETURNED;
      case (5):
        return PaymentStatus.INIT_AUTH_BANK_ACCESS;
      case (6):
        return PaymentStatus.AUTH_DECLINED;
    }
    return PaymentStatus.REGISTER_WITHOUT_PAYMENT;
  }

  Future<PaymentObject> toPay(
      {required int amount, required String orderNumber}) async {
    String request = '';

    if (token != null) {
      request =
          'https://pay.alfabank.ru/payment/rest/register.do?token=$token&amount=$amount&returnUrl=$returnUrl&failUrl=$failUrl&pageView=MOBILE&orderNumber=$orderNumber';
    } else {
      request =
          'https://pay.alfabank.ru/payment/rest/register.do?userName=$userName&password=$password&amount=$amount&returnUrl=$returnUrl&failUrl=$failUrl&pageView=MOBILE&orderNumber=$orderNumber';
    }

    print('requwest $request');
    Dio dio = Dio();
    (dio!.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    Response response = await dio.post(request);
    print(response.data);
    PaymentObject paymentObject = PaymentObject(
        id: jsonDecode(response.data)['orderId'],
        status: PaymentStatus.INIT_AUTH_BANK_ACCESS,
        urlForPayment: jsonDecode(response.data)['formUrl']);

    return paymentObject;
    // TODO: implement toPay
  }
}
