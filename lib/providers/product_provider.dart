import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hired_u_vendor/models/models.dart';
import 'package:hired_u_vendor/services/services.dart';
import 'package:hired_u_vendor/utils/utils.dart';
import 'package:http/http.dart';

enum ProductStatus {
  NotCreating,
  CreatingProduct,
  CreateProductSuccess,
  CreateProductFailure,
}

class ProductsOperationsController extends ChangeNotifier {
  final PreferenceUtils _sharedPreferences = PreferenceUtils.getInstance();

  ProductStatus _createProductStatus = ProductStatus.NotCreating;
  ProductStatus get createOrderStatus => _createProductStatus;

  late List<Product> allList;

  List _selectedCategories = [];

  // List<Product> _productsInStock = [];

  List<Product> _productsInStock = [
    Product(
        name: 'Fusilo ketchup Toglile',
        picPath: [ProductImage(image: 'assets/ketchup.png')],
        price: 109,
        foodCategory: ProductCategory(name: Constants.pastaFoodCategory)
        // weight: '550g'
        ),
    Product(
        name: 'Togliatelle Rice Organic',
        picPath: [
          ProductImage(image: 'assets/rice.png'),
          ProductImage(image: 'assets/flour.png')
        ],
        price: 132,
        foodCategory: ProductCategory(name: Constants.wheatFoodCategory),
        stockAmount: 50
        // weight: '500g'
        ),
    Product(
        name: 'Organic Potatos',
        picPath: [ProductImage(image: 'assets/potatoes.png')],
        price: 1099,
        foodCategory: ProductCategory(name: Constants.wholeFoodCategory),
        stockAmount: 100
        // weight: '1000g'
        ),
    Product(
        name: 'Desolve Milk',
        picPath: [ProductImage(image: 'assets/milk.png')],
        price: 9099,
        foodCategory: ProductCategory(name: Constants.drinkFoodCategory),
        stockAmount: 2
        // weight: '550g'
        ),
    Product(
        name: 'Fusilo Pasta Toglile',
        picPath: [
          ProductImage(image: 'assets/pasta.png'),
          ProductImage(image: 'assets/flour.png')
        ],
        foodCategory: ProductCategory(name: Constants.wheatFoodCategory),
        price: 679,
        stockAmount: 50
        // weight: '500g'
        ),
    Product(
        name: 'Organic Flour',
        picPath: [
          ProductImage(image: 'assets/flour.png'),
          ProductImage(image: 'assets/pasta.png')
        ],
        price: 610,
        foodCategory: ProductCategory(name: Constants.wheatFoodCategory),
        stockAmount: 120
        // weight: '250g'
        ),
  ];

  UnmodifiableListView<Product> get productsInStock {
    // Result result;
    // result = await Result(true, "Success", products: _productsInStock);
    // return result;
    return UnmodifiableListView(_productsInStock);
  }

  set updateProductsList(List<Product> newList) {
    _productsInStock = newList;
    // notifyListeners();
  }

  set updateSingleItem(Product newItem) {
    _productsInStock.add(newItem);
    notifyListeners();
  }

  set updateDefaultProductsList(List<Product> newList) {
    _productsInStock = newList;
    notifyListeners();
  }

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

        if (products.length > 0) {
          var status = await _sharedPreferences.saveValueWithKey(
              Constants.productsListPrefKey, products);
          print("Save values status: $status");
          _productsInStock = products;
          notifyListeners();
        }

        String message = responseData['message'];

        result = Result(true, message == null ? "Success" : message,
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

  Future<Result> createProduct(CreateProductDTO createProductDTOParam) async {
    Result result;

    String token =
        await _sharedPreferences.getValueWithKey(Constants.userTokenPrefKey);

    int uid = await _sharedPreferences.getValueWithKey(Constants.userIdPrefKey);

    CreateProductDTO productDTO = CreateProductDTO(
      name: createProductDTOParam.name,
      description: createProductDTOParam.description,
      quantity: createProductDTOParam.quantity,
      tags: createProductDTOParam.tags,
      sku: createProductDTOParam.sku,
      price: createProductDTOParam.price,
      discount: createProductDTOParam.discount,
      productCategoriesId: createProductDTOParam.productCategoriesId,
      productSuppliersId: uid,
    );

    final Map<String, dynamic> createProductData = productDTO.toJson();

    print("createServiceDat: $createProductData");

    _createProductStatus = ProductStatus.CreatingProduct;
    notifyListeners();

    Response response = await post(Uri.parse(ApiService.createProduct),
        body: json.encode(createProductData),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        });
    print("response: $response");

    final Map<String, dynamic> responseData = json.decode(response.body);

    var status = responseData['status_code'];

    if (status == 200) {
      var serviceData = responseData['payment'];
      Product product = Product.fromJson(serviceData);

      _createProductStatus = ProductStatus.CreateProductSuccess;
      notifyListeners();

      String? message = responseData['message'];

      result = Result(true, message ??= "Success", product: product);
    } else {
      result = Result(false, "An unexpected error occurred");
      _createProductStatus = ProductStatus.CreateProductFailure;
      notifyListeners();
    }

    return result;
  }

  Future<Result> updateProduct(
      Product createProductDTOParam, int id, int stockAmount) async {
    Result result;

    String token =
        await _sharedPreferences.getValueWithKey(Constants.userTokenPrefKey);

    // CreateProductDTO createServiceDTO = CreateProductDTO(
    //   product: createProductDTOParam.product,
    // );

    final Map<String, dynamic> createProductData =
        createProductDTOParam.toJson();

    print("createServiceDat: $createProductData");

    _createProductStatus = ProductStatus.CreatingProduct;
    notifyListeners();

    Response response = await post(
        Uri.parse(ApiService.updateProduct + id.toString()),
        body: json.encode(createProductData),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        });
    print("response: $response");

    final Map<String, dynamic> responseData = json.decode(response.body);

    var status = responseData['status_code'];

    if (status == 200) {
      var serviceData = responseData['payment'];
      Payment payment = Payment.fromJson(serviceData);

      _createProductStatus = ProductStatus.CreateProductSuccess;
      notifyListeners();

      String? message = responseData['message'];

      result = Result(true, message ??= "Success", payment: payment);
    } else {
      result = Result(false, "An unexpected error occurred");
      _createProductStatus = ProductStatus.CreateProductFailure;
      notifyListeners();
    }

    return result;
  }
}
