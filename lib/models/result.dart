import 'package:hired_u_vendor/models/models.dart';

class Result {
  final bool status;
  final String message;
  final List<Order>? orders;
  final List<Order>? ordersHistoryList;
  final Product? product;
  final List<Product>? products;
  final List<ProductCategory>? productCategories;
  final Payment? payment;
  final User? user;
  final String? imageUploadURL;
  final UpdateProfileUser? updateProfileUser;
  final List<Payment>? payments;
  final List<PaymentHistory>? paymentsHistory;
  final bool? productStatus;
  final Order? order;
  final List? errors;

  Result(this.status, this.message,
      {this.products,
      this.productCategories,
      this.imageUploadURL,
      this.updateProfileUser,
      this.product,
      this.user,
      this.payments,
      this.payment,
      this.ordersHistoryList,
      this.productStatus,
      this.paymentsHistory,
      this.order,
      this.orders,
      this.errors});

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'orders': orders,
        "errors": errors,
        "products": products
      };

  @override
  String toString() {
    return "The status: $status\n message: $message\n";
  }
}
