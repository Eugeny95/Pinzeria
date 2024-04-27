import 'dart:convert';

import 'package:data_layer/models/http_models/menu_http_model.dart';
import 'package:data_layer/network/mock.dart';
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MenuRepository {
  Future<MenuHttpModel> syncMenu() async {
    await Hive.initFlutter();
    Response responce = await Dio().get('http://147.45.109.158:8881/api/menu');
    var box = await Hive.openBox('menuBox1');

    await box.put('menu', json.encode(responce.data));
    return MenuHttpModel.fromJson(responce.data);
  }

  Future<MenuHttpModel> getCachedMenu() async {
    await Hive.initFlutter();
    var box = await Hive.openBox('menuBox1');
    Map<String, dynamic> temp = {};
    var data = json.decode(box.get('menu'));
    return MenuHttpModel.fromJson(data);
  }
}
