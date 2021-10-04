import 'package:flutter/material.dart';
import 'package:hired_u_vendor/models/models.dart';
import 'package:hired_u_vendor/pages/pages.dart';
import 'package:hired_u_vendor/services/services.dart';
import 'package:hired_u_vendor/utils/utils.dart';
import 'package:hired_u_vendor/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
class ProductCard extends StatefulWidget {
  const ProductCard({Key? key, required this.product, required this.index}) : super(key: key);
  final Product product;
  final int index;

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late List<Product> producInfoProvider;

  @override
  void initState() {
    super.initState();
    print("Lenght of picpath: ${this.widget.product.picPath!.length}");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            DetailsPageRoute(
                route: ProductDetails(
              product: this.widget.product,
              index: this.widget.index
            )));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            color: AppTheme.secondaryScaffoldColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12, blurRadius: 10, spreadRadius: 0.8)
            ]),
        child: Padding(
          padding: EdgeInsets.only(
            left: 15,
            right: 15,
            top: 20,
            bottom: 10,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //2.4
              Hero(
                tag: '${this.widget.product.id}-path',
                child: Align(
                    alignment: Alignment.center,
                    child: CachedNetworkImage(
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      imageUrl: this.widget.product.picPath!.length > 0
                          ? ApiService.imageBaseURL +
                              this.widget.product.picPath!.first.image!
                          : 'https://uhired.herokuapp.com/profile-images/profile.png',
                      errorWidget: (context, url, error) =>
                          Text("Problem loading the image"),
                    )
                    ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "KSh ${this.widget.product.price}",
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    this.widget.product.name!,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
