import 'package:hired_u_vendor/models/models.dart';

class Product {
  Product({
    this.id,
    this.name = 'null',
    this.picPath,
    this.foodCategory,
    this.description =
        '''This is a professional description, so that you can buy our product, 
        go home and be happy!''',
    this.price = 0,
    this.discount,
    this.quantity,
    this.tags,
    this.supplier,
    this.stockAmount = 0,
    this.orderedQuantity = 1,
    this.sku,
    this.productCategoriesId,
    this.productSuppliersId
  });

  final int? id;
  final String? name;
  final List<ProductImage>? picPath;
  final String? description;
  final ProductCategory? foodCategory;
  final String? tags;
  final Supplier? supplier;
  final int? quantity;
  final int? discount;
  final int? price;
  final int? stockAmount;
  final String? sku;
  final int? productCategoriesId;
  final int? productSuppliersId;
  int orderedQuantity;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'] as String,
      id: json['id'] as int,
      description: json['desc'] as String,
      foodCategory: ProductCategory.fromJson(json['category']),
      picPath: (json['images'].map<ProductImage>((e) => ProductImage.fromJson(e)).toList()),
      price: json['price'] as int,
      discount: json['discount'] as int,
      quantity: json['quantity'] as int,
      tags: json['tags'] as String,
    );
  }

    Map<String, dynamic> toJson() => {
        'name': name,
        'desc': description,
        'SKU': sku,
        'category': foodCategory,
        'images': picPath,
        'price': price,
        "discount": discount,
        "quantity": quantity,
        "tags": tags,
        "supplier": supplier,
        
      };

  @override
  String toString() {
    return "The product name: $name\n The product price is: $price\n The product image length is: ${picPath!.length}\n The product description is: $description";
  }
}
