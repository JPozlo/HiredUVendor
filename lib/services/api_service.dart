import 'dart:convert';

import 'package:hired_u_vendor/models/models.dart';
import 'package:hired_u_vendor/utils/local_database.dart';
import 'package:hired_u_vendor/utils/utils.dart';
import 'package:http/http.dart';

class ApiService {
  final PreferenceUtils _sharedPreferences = PreferenceUtils.getInstance();

  /// URLs
  static const String appBaseURL =
      "https://uhired.herokuapp.com/api/v1.0.1/user/";
  static const String imageBaseURL = "https://uhired.herokuapp.com";
  static const String resetBaseURL = "http://uhired.herokuapp.com/";
  // User
  static const String createNewUser = appBaseURL + "register";
  static const String loginUser = appBaseURL + "login";
  static const String resetPassword = resetBaseURL + "password/reset";
  static const String logoutUser = appBaseURL + "logout";
  static const String fetchUser = appBaseURL;
  static const String fetchIP = appBaseURL + "getip";
  //Profile
  static const String changeProfile = appBaseURL + "profile/changeprofile";
  static const String changePassword = appBaseURL + "profile/changepassword";
  // Order
  static const String baseOrdersURL = appBaseURL + "orders/";
  static const String fetchAllOrders = baseOrdersURL + "";
  static const String viewOrder = baseOrdersURL + "view";
  static const String payOrder = baseOrdersURL + "pay";
  static const String createOrder = appBaseURL + "create/order";
  static const String ordersHistory = appBaseURL + "orderhistory";
  // Address
  static const String createAddress = appBaseURL + "createaddress";
  static const String updateAddress = appBaseURL + "update/address/";
  static const String allAddresses = appBaseURL + "addresses";
  // Products
  static const String fetchProducts = appBaseURL + "products";
  static const String updateProduct = appBaseURL + "products/update";
  static const String createProduct = appBaseURL + "products/create";
  // Services
  static const String fetchServices = appBaseURL + "services/main/";
  static const String createServiceOrder = appBaseURL + "services/orders";
  // Payments
  static const String paymentsList = appBaseURL + "history/payments";
  static const String confirmPayment = appBaseURL + "payment/confirmation";
  // Logs
  static const String mobileLogs = appBaseURL + "mobilelogs";

  Future<Result> fetchProductsList() async {
    Result result;

    String token =
        await _sharedPreferences.getValueWithKey(Constants.userTokenPrefKey);

    Response response = await get(Uri.parse(ApiService.fetchProducts),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        });

    final Map<String, dynamic> responseData = json.decode(response.body);

    var status = responseData['status_code'];

    if (status == 200) {
      var fetchData = responseData['products'];
      var productsData = responseData['products']['data'];
      var paginationData = responseData['products']['pagination'];
      bool productsDataStatus;
      // var uid = responseData['uid'];
      // var token = responseData['token'];
      print("fetchData: ${fetchData.toString()}");
      print("productsData: ${productsData.toString()}");

      if (productsData == null) {
        productsDataStatus = false;
        result = Result(true, "No products", productStatus: productsDataStatus);
      } else {
        productsDataStatus = true;
        List<Product> products =
            productsData.map<Product>((e) => Product.fromJson(e)).toList();
        // PaginationData pagination = PaginationData.fromJson(paginationData);

        // if (products.length > 0) {
        //   var status = await _sharedPreferences.saveValueWithKey(
        //       Constants.productsListPrefKey, products);
        //   print("Save values status: $status");
        // }

        String? message = responseData['message'];

        print("Service products list: ${products.first.picPath?.first.image}");

        result = Result(true, message ??= "Success",
            products: products,
            // pagination: pagination,
            productStatus: productsDataStatus);
      }
    } else {
      String? errorMessage;

      var errors = responseData['errors'];

      print("The ERRORS: ${responseData['errors']}");

      if (status == 403) {
        errorMessage = "Access Forbidden";
      }

      result = Result(false,
          errorMessage == null ? "An unexpected error occurred" : errorMessage);
    }

    print("Result value: $result");

    return result;
  }

  Future<Result> fetchPaymentsList() async {
    Result result;

    String token =
        await _sharedPreferences.getValueWithKey(Constants.userTokenPrefKey);

    Response response = await get(Uri.parse(ApiService.paymentsList), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });

    final Map<String, dynamic> responseData = json.decode(response.body);

    var status = responseData['status_code'];

    if (status == 200) {
      var groceryPayments = responseData['grocerypayment'];
      var servicesPayments = responseData['servicespayment'];
      List<PaymentHistory> groceryPaymentsList = groceryPayments
          .map<PaymentHistory>((e) => PaymentHistory.fromJson(e))
          .toList();
      List<PaymentHistory> servicesPaymentsList = servicesPayments
          .map<PaymentHistory>((e) => PaymentHistory.fromJson(e))
          .toList();

      List<PaymentHistory> singleList = [
        ...groceryPaymentsList,
        ...servicesPaymentsList
      ];

      print("Grocery payments: $groceryPaymentsList");
      print("Service payments: $servicesPaymentsList");
      print("Single list combined: $singleList");

      String message = responseData['message'];

      result = Result(true, message == null ? "Success" : message,
          paymentsHistory: singleList);
    } else {
      result = Result(false, "An unexpected error occurred");
    }
    return result;
  }

  Future<Result> fetchOrdersHistoryList() async {
    Result result;

    String token =
        await _sharedPreferences.getValueWithKey(Constants.userTokenPrefKey);

    Response response = await get(Uri.parse(ApiService.ordersHistory),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        });

    final Map<String, dynamic> responseData = json.decode(response.body);

    var status = responseData['status_code'];

    if (status == 200) {
      var orderHistory = responseData['orderhistory'];

      if (ordersHistory == null) {
        result = Result(true, "No orders found", ordersHistoryList: null);
      } else {
        List<Order> orderHistoryList =
            orderHistory.map<Order>((e) => Order.fromJson(e)).toList();

        print("Orders History List: $orderHistoryList");

        String message = responseData['message'];

        result = Result(true, message == null ? "Success" : message,
            ordersHistoryList: orderHistoryList);
      }
    } else {
      result = Result(false, "An unexpected error occurred");
    }
    return result;
  }

  Future<int> sendPaymentConfirmation(int id) async {
    late int finalStatus;

    String token =
        await _sharedPreferences.getValueWithKey(Constants.userTokenPrefKey);

    final Map<String, dynamic> chargingResponse = {'id': id};

    Response response = await post(Uri.parse(ApiService.confirmPayment),
        body: json.encode(chargingResponse),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        });

    final Map<String, dynamic> responseData = json.decode(response.body);

    finalStatus = responseData['status_code'];

    if (finalStatus == 200) {
      var orderHistory = responseData;

      print("Response data: $responseData");

      // if (ordersHistory == null) {
      //   result = Result(true, "No orders found", ordersHistoryList: null);
      // } else {
      //   List<Order> orderHistoryList =
      //       orderHistory.map<Order>((e) => Order.fromJson(e)).toList();

      //   print("Orders History List: $orderHistoryList");

      //   String message = responseData['message'];

      // result = Result(true, "Success");
      // }

    } else {
      // final
      // result = Result(false, "An unexpected error occurred");
    }
    return finalStatus;
  }

 Future<Result> logout() async {
    Result result;

    String token =
        await _sharedPreferences.getValueWithKey(Constants.userTokenPrefKey);

    Response response = await post(Uri.parse(ApiService.logoutUser), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });
    print("response: $response");

    final Map<String, dynamic> responseData = json.decode(response.body);
    print("responsedatalogout: ${responseData.toString()}");

    var status = responseData['status_code'];

    if (status == 200) {
      String message = responseData['message'];
      result = Result(true, message == null ? "Successful logout" : message);
      _sharedPreferences.removeMultipleValuesWithKeys([
        Constants.userTokenPrefKey,
        Constants.userEmailPrefKey,
        Constants.userNamePrefKey,
        Constants.userIdPrefKey,
        Constants.userPhonePrefKey,
        Constants.userProfilePrefKey,
      ]);
    } else {
      result = Result(false, "An unexpected error occurred");
    }
    return result;
  }

}
