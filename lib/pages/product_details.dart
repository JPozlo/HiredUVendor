import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hired_u_vendor/models/models.dart';
import 'package:hired_u_vendor/pages/pages.dart';
import 'package:hired_u_vendor/providers/providers.dart';
import 'package:hired_u_vendor/services/services.dart';
import 'package:hired_u_vendor/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProductDetails extends StatefulWidget {
  ProductDetails({required this.product, required this.index});
  final int index;
  final Product product;
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  bool isFavourite = false;
  late PreferenceUtils _utils;
  // late AnimationController animationController;
  late Animation animation;
  late bool isToPreview;
  double opacity = 1;
  int productAmountInStock = 1;
  bool temp = false;
  int _activeIndex = 0;
  final _carouselController = CarouselController();
  List<ProductImage> productImage = [];

  @override
  void initState() {
    super.initState();
    isToPreview = false;
    print("The product: ${widget.product.toString()}");
    if (widget.product.picPath!.isNotEmpty) {
      productImage = widget.product.picPath!;
    } else {
      productImage = [
        ProductImage(
            image: 'https://uhired.herokuapp.com/profile-images/profile.png'),
        ProductImage(
            image: 'https://uhired.herokuapp.com/profile-images/profile.png')
      ];
    }
    _utils = PreferenceUtils.getInstance();
    productAmountInStock = widget.product.stockAmount!;
  }

  @override
  void dispose() {
    // animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ProductsOperationsController>(context);
    var productProvider =
        Provider.of<ProductsOperationsController>(context).productsInStock;
    print("The productsprovider length: ${productProvider.length}");
    return Scaffold(
      backgroundColor: AppTheme.mainScaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.mainScaffoldBackgroundColor,
        brightness: Brightness.light,
        leading: IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            icon: Hero(
              tag: 'backarrow',
              child: Icon(Icons.arrow_back_ios, color: Colors.black, size: 24),
            ),
            onPressed: () {
              setState(() => opacity = 0);
              Navigator.pop(context);
            }),
      ),
      floatingActionButton: InkWell(
        onTap: () {
          switch (temp) {
            case false:
              SystemChrome.setEnabledSystemUIOverlays([]);
              setState(() {
                temp = true;
              });
              break;
            case true:
              SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
              setState(() {
                temp = false;
              });
              break;
          }
        },
        child: Container(height: 100, width: 100),
      ),
      body: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Hero(
            tag: 'detailsScreen - ${widget.product.id}',
            child: Container(
              // height: response.screenHeight,
              // width: response.screenWidth,
              decoration: BoxDecoration(
                color: AppTheme.mainScaffoldBackgroundColor,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  productImages(productImage, widget.product.name!),
                  const SizedBox(height: 13),
                  buildIndicator(productImage),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: response.setWidth(30)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: response.setHeight(20)),
                        Text(
                          widget.product.name!,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: response.setFontSize(40),
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        SizedBox(height: response.setHeight(5)),
                        Text(
                          widget.product.foodCategory!.name!,
                          style: TextStyle(
                              fontSize: response.setFontSize(15),
                              fontWeight: FontWeight.w500,
                              color: Colors.black45),
                        ),
                        SizedBox(height: response.setHeight(25)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            // ProductQuantity(
                            //   orderQuantity: productAmountInStock,
                            //   minusOnTap: () =>
                            //       setState(() => productAmountInStock--),
                            //   plusOnTap: () =>
                            //       setState(() => productAmountInStock++),
                            // ),
                            Text(
                              "KSh ${widget.product.price}",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: response.setFontSize(32),
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                        SizedBox(height: response.setHeight(30)),
                        Text(
                          "About the Product",
                          style: TextStyle(
                              fontSize: response.setFontSize(17),
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        SizedBox(height: response.setHeight(5)),
                        Text(
                          widget.product.description!,
                          style: TextStyle(
                              fontSize: response.setFontSize(15),
                              color: Colors.black87),
                        ),
                        SizedBox(height: response.setHeight(25)),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: <Widget>[
                        //     GestureDetector(
                        //       onTap: () {
                        //         // provider.updateProduct(widget.product, widget.product.id!, productAmountInStock);
                        //         setState(() {
                        //           isToPreview = true;
                        //           opacity = 0;
                        //         });
                        //         Navigator.pop(context);
                        //       },
                        //       child: Opacity(
                        //         opacity: opacity,
                        //         child: Container(
                        //           height: response.setHeight(55),
                        //           // width: response.setWidth(235),
                        //           width: response.screenWidth! * 0.6,
                        //           decoration: BoxDecoration(
                        //               color: AppTheme.mainBlueColor,
                        //               borderRadius: BorderRadius.circular(
                        //                   response.setHeight(50))),
                        //           child: Center(
                        //             child: Text(
                        //               "Update Product Amount",
                        //               style: TextStyle(
                        //                 fontSize: response.setFontSize(18),
                        //                 fontWeight: FontWeight.w700,
                        //                 color: Colors.white,
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        SizedBox(height: response.setHeight(25)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget productImages(List<ProductImage> imagePaths, String productName) {
    Widget productImage;

    if (imagePaths.length <= 1) {
      productImage = buildImage(productName, imagePaths.first);
    } else {
      productImage = CarouselSlider.builder(
          carouselController: _carouselController,
          itemCount: imagePaths.length,
          itemBuilder: (context, index, realIndex) {
            final imagePath = imagePaths[index];
            return buildImage(productName, imagePath);
          },
          options: CarouselOptions(
              onPageChanged: (index, reason) {
                setState(() {
                  _activeIndex = index;
                });
              },
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 6),
              viewportFraction: 1));
    }

    return productImage;
  }

  Widget buildImage(String name, ProductImage path) {
    return Hero(
        tag: isToPreview ? '$name-name' : '$path-path',
        child: CachedNetworkImage(
          placeholder: (context, url) => const CircularProgressIndicator(),
          imageUrl: path != null
              ? ApiService.imageBaseURL + path.image!
              : 'https://uhired.herokuapp.com/profile-images/profile.png',
          errorWidget: (context, url, error) =>
              Text("Problem loading the image!"),
        )
        // child: Image.network(ApiService.imageBaseURL + path.image, scale: 0.8),
        );
  }

  Widget buildIndicator(List<ProductImage> imagePaths) {
    return AnimatedSmoothIndicator(
      activeIndex: _activeIndex,
      count: imagePaths.length,
      // onDotClicked: jumpToPage,
      effect: JumpingDotEffect(
          dotWidth: 20,
          dotHeight: 20,
          activeDotColor: AppTheme.mainOrangeColor,
          dotColor: AppTheme.mainCardBackgroundColor),
    );
  }

  void jumpToPage(int index) => _carouselController.animateToPage(index);
}

class ProductQuantity extends StatelessWidget {
  ProductQuantity({
    required this.orderQuantity,
    required this.minusOnTap,
    required this.plusOnTap,
  });
  final int orderQuantity;
  final VoidCallback minusOnTap;
  final VoidCallback plusOnTap;
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(
      color: Colors.black,
      fontSize: response.setFontSize(20),
    );
    return Container(
      height: response.setHeight(45),
      width: response.setWidth(70),
      padding: EdgeInsets.symmetric(horizontal: response.setWidth(15)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(response.setHeight(30)),
        border:
            Border.all(color: Colors.black38, width: response.setHeight(0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IgnorePointer(
            ignoring: orderQuantity > 1 ? false : true,
            child: InkWell(
              onTap: minusOnTap,
              child: Text(
                "-",
                style: textStyle.copyWith(
                    color: orderQuantity > 1 ? Colors.black87 : Colors.black26,
                    fontSize: response.setFontSize(35),
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),
          Text(orderQuantity.toString(), style: textStyle),
          IgnorePointer(
            ignoring: orderQuantity < 50 ? false : true,
            child: InkWell(
              onTap: plusOnTap,
              child: Text(
                "+",
                style: textStyle.copyWith(
                  color: orderQuantity < 50 ? Colors.black87 : Colors.black26,
                  fontSize: response.setFontSize(24),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
