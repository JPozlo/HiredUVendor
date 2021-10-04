import 'package:hired_u_vendor/models/models.dart';

class Order {
  final int? id;
  final int? addressId;
  final List<Product>? orderItems;
  final String? token;
  final String? status;
  final String? description;
  final int? total;

  Order(
      {this.id,
      this.addressId,
      this.token,
      this.orderItems,
      this.description,
      this.total,
      this.status});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as int,
      total: json['total'] as int,
      description: json['description'] as String,
      status: json['status'] as String
    );
  }

  Map<String, dynamic> toJson() =>
      {'address_id': addressId, 'order_items': orderItems, 'token': token};

  @override
  String toString() {
    return "The id:$id\n status:";
  }
}
