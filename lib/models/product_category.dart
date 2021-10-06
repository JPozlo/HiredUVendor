class ProductCategory {
  ProductCategory({this.id, this.name, this.description});
  final int? id;
  final String? name;
  final String? description;

  factory ProductCategory.fromJson(Map<String, dynamic> json) =>
      ProductCategory(
        name: json['name'] as String,
        description: json['description'] as String,
        id: json['id'] as int
      );

      @override
  String toString() {
    return "Name: $name\n Description: $description";
  }
}
