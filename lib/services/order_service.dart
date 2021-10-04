import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hired_u_vendor/models/models.dart';
import 'package:hired_u_vendor/services/services.dart';
import 'package:hired_u_vendor/utils/utils.dart';
import 'package:http/http.dart';

class OrderService {
  final PreferenceUtils _sharedPreferences = PreferenceUtils.getInstance();

  Future<Result> fetchOrdersHistory() async {
    Result result;

    String token =
        await _sharedPreferences.getValueWithKey(Constants.userTokenPrefKey);

    Response response = await get(Uri.parse(ApiService.ordersHistory),
        headers: {'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
        });

    final Map<String, dynamic> responseData = json.decode(response.body);

    var status = responseData['status_code'];

    if (status == 200) {
      var orderData = responseData['order'];
      
      var order = Order.fromJson(orderData);

      String message = responseData['message'];

      result = Result(true, message, order: order);
    } else {

      var errors = responseData['errors'];

      print("The ERRORS: ${responseData['errors']}");

      result = Result(false, "Error registering");
    }

    print("Result value: $result");

    return result;
  }
}
