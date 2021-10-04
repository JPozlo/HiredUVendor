class ProductImage {
  ProductImage({this.image});
  final String? image;

  factory ProductImage.fromJson(Map<String, dynamic> json) =>
      ProductImage(image: json['image']);

          Map<String, dynamic> toJson() => {
        'image': image,
      };
}
