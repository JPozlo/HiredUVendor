import 'package:flutter/material.dart';
import 'package:hired_u_vendor/models/models.dart';
import 'package:hired_u_vendor/pages/pages.dart';
import 'package:hired_u_vendor/providers/providers.dart';
import 'package:hired_u_vendor/services/services.dart';
import 'package:hired_u_vendor/utils/utils.dart';
import 'package:hired_u_vendor/widgets/widgets.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<Result> _productsFuture;

  var doLoading = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      CircularProgressIndicator(),
      Text(" Fetching Products ... Please wait")
    ],
  );

  @override
  void initState() {
    super.initState();
    _productsFuture = ApiService().fetchProductsList();
  }

  @override
  Widget build(BuildContext context) {
    List<Product> productsList =
        Provider.of<ProductsOperationsController>(context, listen: false).productsInStock;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                        RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Your Products",
                            style:
                                Theme.of(context).textTheme.headline6?.copyWith(
                                      color: Colors.black,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 14,
                ),
                productsList == null
                    ? productsMainDisplay(productsList, context)
                    : FutureBuilder(
                        future: _productsFuture,
                        initialData: Result(false, "Success", products: []),
                        builder: (context, AsyncSnapshot<Result> snapshot) {
                          late Widget defaultWidget;
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              defaultWidget = doLoading;
                              break;
                            case ConnectionState.none:
                              defaultWidget = doLoading;
                              break;
                            case ConnectionState.done:
                              if (snapshot.hasData &&
                                  snapshot.data?.products != null) {
                                print(
                                    "Snapshot data: ${snapshot.data.toString()}");
                                defaultWidget = productsMainDisplay(
                                    snapshot.data!.products!, context);
                                Provider.of<ProductsOperationsController>(context,
                                            listen: false)
                                        .updateProductsList =
                                    snapshot.data!.products!;
                                print(
                                    "listProducts: ${snapshot.data!.products!}");
                              } else if (snapshot.hasError) {
                                defaultWidget =
                                    errorWidget(error: snapshot.error.toString());
                              } else {
                                defaultWidget = errorWidget();
                              }
                              break;
                            default:
                              defaultWidget = doLoading;
                              break;
                          }
                          return defaultWidget;
                        },
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget errorWidget({String? error}) {
    return Stack(alignment: Alignment.center, children: [
      Positioned(
        top: 230,
        left: 10,
        width: response.screenWidth,
        child: Container(
          height: response.setHeight(70),
          margin: EdgeInsets.only(top: 6.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.5, 1],
              colors: [
                AppTheme.mainScaffoldBackgroundColor,
                AppTheme.mainScaffoldBackgroundColor.withAlpha(150)
              ],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                error ??= "Products you have will be displayed here!",
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    ]);
  }

  Widget productsMainDisplay(List<Product> listInfo, BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(bottom: 12.5),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 35),
            child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: MediaQuery.of(context).size.width /
                        (MediaQuery.of(context).size.height / 1.18),
                    crossAxisSpacing: 6),
                itemCount: listInfo.length,
                itemBuilder: (context, index) {
                  Product currentProduct = listInfo[index];
                  print("Current product: ${currentProduct.tags}");
                  return ProductCard(product: currentProduct, index: index);
                }),
          ),
        ),
      ),
    );
  }
}
