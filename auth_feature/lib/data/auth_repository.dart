import 'dart:convert';
import 'dart:io';
import 'package:auth_feature/data/auth_data.dart';
import 'package:dio/dio.dart';

Future<UserData> registerInServer(UserData user, String registerUrl) async {
  try {
    print(user.toJson());
    Response response = await Dio().post(registerUrl, data: user.toJson());
    print(user.toJson());

    user.accessToken = response.data['access_token'].toString();

    user.authStatus = AuthStatus.authorized;

    return user;
  } on DioError catch (_, e) {
    print('exception on register server $_');
    if (_.runtimeType == SocketException) {
      user.authStatus = AuthStatus.network_failure;
      return user;
    }
    if (_.response == null) {
      user.authStatus = AuthStatus.network_failure;
      return user;
    }
    if (_.response!.statusCode == 409) {
      user.authStatus = AuthStatus.user_exist;
      return user;
    }
  }
  return user;
}

Future<UserData> loginInServer(
    {required String message_service_token,
    required String deviceType,
    required String username,
    required String password,
    required String authUrl}) async {
  String basicAuth =
      'Basic ' + base64Encode(utf8.encode('${username}:${password}'));
  print(basicAuth);

  try {
    Response response = await Dio().post(authUrl,
        // data: {
        //   'message_service_token': message_service_token ?? '',
        //   'device_type': deviceType ?? '',
        // },
        options: Options(
            //receiveDataWhenStatusError: true,
            headers: <String, String>{
              'Authorization': basicAuth,
              'User-Agent': 'PostmanRuntime/7.36.3',
              'Accept': '*/*',
              'Cache-Control': 'no-cache',
              'Postman-Token': '30bb6a90-1f78-43a4-999f-b1dd6152e315',
              'Host': '147.45.109.158:8881',
              'Accept-Encoding': 'gzip, deflate, br',
              'Connection': 'keep-alive',
              'Content-Length': '0'
            }));
    Map jsonString = response.data;

    UserData user = UserData()
      ..username = username
      ..password = password
      ..accessToken = jsonString['access_token'] ?? ''
      ..first_name = jsonString['first_name'] ?? ''
      ..email = jsonString['email'] ?? ''
      ..last_name = jsonString['last_name'] ?? ''
      ..date_birth = DateTime.fromMillisecondsSinceEpoch(
              int.parse(jsonString['date_birth'].toString())) ??
          DateTime.now();

    // RSAPublicKey.fromPEM(jsonString['server_rsa_public_key']);
    user.authStatus = AuthStatus.authorized;
    return user;
  } on DioError catch (_, e) {
    if (_.response == null)
      return UserData()..authStatus = AuthStatus.network_failure;
    if (_.response!.statusCode == 404) {
      return UserData()..authStatus = AuthStatus.user_not_found;
    }
    if (_.response!.statusCode == 401) {
      return UserData()..authStatus = AuthStatus.unauthorized;
    }
    return UserData()..authStatus = AuthStatus.unauthorized;
  }
}
