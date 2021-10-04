import 'package:hired_u_vendor/models/models.dart';

class CreateProductDTO {

  CreateProductDTO({
      this.id,
    this.name = 'null',
    this.picPath,
    this.foodCategory,
    this.description =
        '''This is a professional description, so that you can buy our product, go home and be happy!''',
    this.price = 0,
    this.discount,
    this.quantity,
    this.tags,
    this.supplier,
    this.sku,
    this.productCategoriesId,
    this.productSuppliersId,
    this.stockAmount = 0,
    });

  final int? id;
  final String? name;
  final List<ProductImage>? picPath;
  final String? description;
  final ProductCategory? foodCategory;
  final String? tags;
  final String? sku;
  final Supplier? supplier;
  final int? quantity;
  final int? discount;
  final int? price;
  final int? stockAmount;
  final int? productCategoriesId;
  final int? productSuppliersId;

      Map<String, dynamic> toJson() => {
        'name': name,
        'desc': description,
        'SKU': sku,
        'price': price,
        "discount": discount,
        "quantity": quantity,
        "tags": tags,
        "product_categories_id": productCategoriesId,
        "product_suppliers_id": productSuppliersId,
      };
}
