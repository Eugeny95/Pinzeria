import 'dart:convert';

import 'package:data_layer/models/http_models/menu_http_model.dart';
import 'package:data_layer/models/http_models/order_http_model.dart';
import 'package:data_layer/network/mock.dart';
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';

enum CreateOrderStatus { success, failure }

class OrderRepository {
  Future<CreateOrderStatus> createOrder(
      OrderHttpModel orderHttpModel, String accessToken) async {
    try {
      print(orderHttpModel.toJson());
      Response responce = await Dio().post(
          'http://147.45.109.158:8881/orders/order/',
          data: orderHttpModel.toJson(),
          options: Options(headers: <String, String>{
            'authorization': 'Bearer ${accessToken}'
          }));
      print(responce.statusCode);

      if (responce.statusCode == 201) return CreateOrderStatus.success;
    } catch (_) {
      print(_);
      return CreateOrderStatus.failure;
    }
    return CreateOrderStatus.failure;
  }
}
