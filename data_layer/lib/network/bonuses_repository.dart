import 'package:dio/dio.dart';
import 'dart:developer';

class BonusesRepository {
  Future<double> getBonusesBalance({required String accessToken}) async {
    try {
      Response responce = await Dio().get(
          'http://147.45.109.158:8881/auth/wallet_balances/',
          options: Options(headers: <String, String>{
            'authorization': 'Bearer ${accessToken.toString()}'
          }));

      double balance = double.parse(responce.data['Баланс бонусных баллов']);
      return balance;
    } catch (_) {
      return 0.0;
    }
  }

  Future<double> getAvailibleBonuses(
      {required double totalCost, required String accessToken}) async {
    try {
      Response responce = await Dio().get(
          'http://147.45.109.158:8881/orders_info/amount_without_bonuses/?sum=$totalCost',
          options: Options(headers: <String, String>{
            'authorization': 'Bearer ${accessToken}'
          }));

      return responce.data['Можно списать бонусов'];
    } catch (_) {
      log('error ${_}');
      return 0.0;
    }
  }
}
