import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:microwave/models/classes/microwave.dart';

import '../../utils/main_endpoint.dart';

class MicrowaveList with ChangeNotifier {
  List<Microwave> _items = [];
  List<Microwave> get items => [..._items];

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadMicrowaves() async {
    _items.clear();
    final response = await Api.doRequest('/api/Microwave/', http.get, '');

    if (response!.body.isEmpty) return;
    final data =
        jsonDecode(utf8.decode(response.bodyBytes)) as List?;

    if (data != null) {
      _items = data.map((e) => Microwave.fromMap(e)).toList();
      // print(data);
    }

    notifyListeners();
  }

  Future<void> loadMicrowaveById(
    String microwaveId,
  ) async {
    final response = await Api.doRequest('/api/Microwave/$microwaveId', http.get, '');

    if (response!.body.isEmpty) return;
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    Map<String, dynamic> body = json;

    if (body != null) {
      _items = [body].map((e) => Microwave.fromMap(e)).toList();
    }

    notifyListeners();
  }

  Future<void> saveMicrowave(
    Microwave microwave
  ) async {
    final body = microwave.toJson();
    await Api.doRequest(
      '/api/Microwave/',
      http.post,
      body,
    );
    // print(response!.statusCode);
    notifyListeners();
  }


  Future<void> startHeating(
    Microwave microwave
  ) async {
    
    final teste = await Api.doRequest(
      '/api/Microwave/start-heating/${microwave.id}',
      http.put,
      microwave.toJson(),
    );

    print(teste);
    notifyListeners();
  }

  Future<void> pauseOrCancelHeating(
    Microwave microwave
  ) async {
    
    await Api.doRequest(
      '/api/Microwave/pause-or-cancel-heating/${microwave.id}',
      http.put,
      microwave.toJson(),
    );
    notifyListeners();
  }

  Future<void> removeMicrowave(
    String microwaveId,
  ) async {
    await Api.doRequest('/api/Microwave/$microwaveId', http.delete, '');

    _items.removeWhere((element) => element.id == microwaveId);
    notifyListeners();
  }
}
