class Supplier {
  Supplier({this.id, this.name});

  final int? id;
  final String? name;

  factory Supplier.fromJson(Map<String, dynamic> json) =>
      Supplier(id: json['id'] ?? 0, name: json['name'] ?? "");
}
