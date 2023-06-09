import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

const String urlServer = '127.0.0.1:7122';

const bool enabledHttps = true;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

String? _token;

class LoginRequestResult extends Equatable {
  final String? error;
  const LoginRequestResult({required this.error});

  factory LoginRequestResult.fromJson(Map<String, dynamic> json) {
    return LoginRequestResult(
      error: json['error'],
    );
  }
  @override
  List<Object> get props => [];
}

class Api with ChangeNotifier {
  bool authenticated = false;
  bool isLoading = true;

  static Function? onErr;

  static final Api _singleton = Api._internal(onErr);

  Api._internal(onErr);

  static Future<http.Response> doReq(
    path,
    method,
    body,
  ) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _token = sharedPreferences.getString('token');
    Uri uriServer =
        enabledHttps ? Uri.https(urlServer, path) : Uri.http(urlServer, path);
    if (method == http.get || method == http.delete) {
      return method(uriServer, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        // 'Authorization': 'Bearer $_token',
        'x-api-key': '$_token',
      }).timeout(const Duration(seconds: 20), onTimeout: () {
        throw TimeoutException(
            'The connection has timed out, Please try again!');
      });
    } else if (method == http.post || method == http.put) {
      return http
          .post(uriServer,
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                // 'Authorization': 'Bearer $_token',
                'x-api-key': '$_token',
              },
              body: body)
          .timeout(const Duration(seconds: 20), onTimeout: () {
        throw TimeoutException(
            'The connection has timed out, Please try again!');
      });
    } else {
      return method;
    }
  }

  static Future<http.Response?> doRequest(path, method, body) async {
    try {
      var response = await doReq(path, method, body);

      // print(response.statusCode);

      if (response.statusCode == 200) {
        return response;
      } else if (response.statusCode == 412) {
        return null;
      } else {}
      return response;
    } catch (e) {
      
    }
  }
}
