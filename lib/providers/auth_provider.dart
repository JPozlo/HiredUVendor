import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hired_u_vendor/models/models.dart';
import 'package:hired_u_vendor/services/services.dart';
import 'package:hired_u_vendor/utils/utils.dart';
import 'package:http/http.dart';

import '../utils/local_database.dart';

enum Status {
  NotLoggedIn,
  LoggedIn,
  Authenticating
}

class AuthProvider with ChangeNotifier {
  final PreferenceUtils _sharedPreferences = PreferenceUtils.getInstance();
  
  Status _loggedInStatus = Status.NotLoggedIn;

  Status get loggedInStatus => _loggedInStatus;


  Future<Result> login(String email, String password) async {
    Result result;

    String deviceName = await _sharedPreferences
        .getValueWithKey(Constants.userDeviceModelPrefKey);

    final Map<String, dynamic> loginData = {
      'email': email,
      'password': password,
      'device_name': deviceName
    };

    _loggedInStatus = Status.Authenticating;
    notifyListeners();

    Response response = await post(
      Uri.parse(ApiService.loginUser),
      body: json.encode(loginData),
      headers: {'Content-Type': 'application/json'},
    );

    final Map<String, dynamic> responseData = json.decode(response.body);

    var status = responseData['status_code'];

    print("Status code: $status");

    if (status == 200) {
      var userData = responseData['user'];
      var token = responseData['token'];

      var user = User.fromJsonUserData(userData);

      String message = responseData['message'];

      _sharedPreferences.saveValueWithKey(Constants.userIdPrefKey, user.uid);
      _sharedPreferences.saveValueWithKey(Constants.userNamePrefKey, user.name);
      _sharedPreferences.saveValueWithKey(Constants.userTokenPrefKey, token);
      _sharedPreferences.saveValueWithKey(
          Constants.userEmailPrefKey, user.email);
        _sharedPreferences.saveValueWithKey(
            Constants.userProfilePrefKey, user.profile ?? "");
          if(user.phone != null){
   _sharedPreferences.saveValueWithKey(
            Constants.userPhonePrefKey, user.phone ?? "");
          }
   

      _loggedInStatus = Status.LoggedIn;
      notifyListeners();

      print("FINAL USER: $user");

      result = Result(true, message, user: user);
    } else {
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();

      var errors = responseData['errors'];

      print("The ERRORS: ${responseData['errors']}");

      result = Result(false, "Error signing in", errors: errors);
    }
    return result;
  }


}
