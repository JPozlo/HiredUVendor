import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hired_u_vendor/models/models.dart';
import 'package:hired_u_vendor/providers/providers.dart';
import 'package:hired_u_vendor/services/services.dart';
import 'package:hired_u_vendor/utils/utils.dart';
import 'package:hired_u_vendor/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CreateProductPage extends StatefulWidget {
  const CreateProductPage({Key? key}) : super(key: key);

  @override
  _CreateProductPageState createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {
  final PreferenceUtils _sharedPreferences = PreferenceUtils.getInstance();
  final _formKey = GlobalKey<FormState>();
  ProductCategory? _selectedCategory;
  String? _selectedCategoryName;
  List<ProductCategory>? _productCategories;
  late String _name, _description, _tags, _sku;
  late int _stockAmount, _price, _discount;
  late Future<Result> _categoriesFuture;
  bool categoryIsSelected = false;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = ApiService().fetchProductCategoriesList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: FutureBuilder(
                future: _categoriesFuture,
                builder: (context, AsyncSnapshot<Result> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.done:
                      if (snapshot.hasData && snapshot.data != null) {
                        print("Snapshot data: ${snapshot.data.toString()}");
                        _productCategories = snapshot.data!.productCategories!;
                        _selectedCategoryName =
                            snapshot.data!.productCategories!.first.name!;
                        print(
                            "listProducts: ${snapshot.data!.productCategories!}");
                      } else if (snapshot.hasError) {
                      } else {}
                      break;
                    default:
                      break;
                  }
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        topBar(),
                        const SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 13.0),
                          child: detailsFormUpdate(
                              context, snapshot.data?.productCategories),
                        )
                      ],
                    ),
                  );
                })));
  }

  Widget topBar() {
    return Container(
      height: 32,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Add New Product",
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                        color: Colors.black,
                      ),
                ),
              ],
            ),
          ),
          const Spacer()
        ],
      ),
    );
  }

  Widget detailsFormUpdate(
      BuildContext context, List<ProductCategory>? categories) {
    ProductsOperationsController productProvider =
        Provider.of<ProductsOperationsController>(context);
    productProvider.productsCategories = categories ?? List.empty();

    final nameInput = TextFormField(
        validator: (value) => value!.isEmpty ? "Please enter name" : null,
        onSaved: (value) => _name = value!,
        decoration: inputFieldDecoration("Enter the name"));
    final descInput = TextFormField(
        maxLines: 6,
        validator: (value) =>
            value!.isEmpty ? "Please enter description" : null,
        onSaved: (value) => _description = value!,
        decoration: inputFieldDecoration("Enter the description"));
    final stockInput = TextFormField(
        validator: (value) =>
            value!.isEmpty ? "Please enter the amount in stock" : null,
        onSaved: (value) => _stockAmount = int.parse(value!),
        decoration: inputFieldDecoration("Enter stock amount"));
    final priceInput = TextFormField(
        validator: (value) => value!.isEmpty ? "Please enter price" : null,
        onSaved: (value) => _price = int.parse(value!),
        decoration: inputFieldDecoration("Enter the price"));
    final discountInput = TextFormField(
        validator: (value) => value!.isEmpty ? "Please enter disocunt" : null,
        onSaved: (value) => _discount = int.parse(value!),
        decoration: inputFieldDecoration("Enter the discount"));
    final tagsInput = TextFormField(
        validator: (value) => value!.isEmpty ? "Please enter tags" : null,
        onSaved: (value) => _tags = value!,
        decoration: inputFieldDecoration("Enter product tags"));
    final skuInput = TextFormField(
        validator: (value) => value!.isEmpty ? "Please enter an SKU" : null,
        onSaved: (value) => _sku = value!,
        decoration: inputFieldDecoration("Enter product SKU"));

    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const <Widget>[
        CircularProgressIndicator(),
        Text(" Processing ... Please wait")
      ],
    );

    doCreateAddress() {
      final form = _formKey.currentState;
      if (form!.validate()) {
        form.save();

        CreateProductDTO createAddressDTO = CreateProductDTO(
            name: _name,
            description: _description,
            quantity: _stockAmount,
            price: _price,
            discount: _discount,
            productCategoriesId: _selectedCategory?.id,
            tags: _tags,
            sku: _sku);

        final Future<Result> createAddressResponse =
            productProvider.createProduct(createAddressDTO);

        createAddressResponse.then((response) async {
          if (response.status) {
            setState(() {
              categoryIsSelected = false;
            });
            if (response.imageUploadURL != null) {
              await launchPasswordResetURl(response.imageUploadURL!);
            }
            Fluttertoast.showToast(
                msg: "Successfully added product",
                toastLength: Toast.LENGTH_LONG);
            // nextScreen(context, MainHome());
          } else {
            setState(() {
              categoryIsSelected = false;
            });
            Flushbar(
              title: "Failed Login",
              message: response.message.toString(),
              duration: const Duration(seconds: 3),
            ).show(context);
          }
        });
      } else {
        Flushbar(
          title: "Invalid form",
          message: "Please Complete the form properly",
          duration: const Duration(seconds: 10),
        ).show(context);
      }
    }

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            label("Name"),
            const SizedBox(
              height: 7.0,
            ),
            nameInput,
            label("Description"),
            const SizedBox(
              height: 7.0,
            ),
            descInput,
            label("Price"),
            const SizedBox(
              height: 7.0,
            ),
            priceInput,
            label("Stock Quantity"),
            const SizedBox(
              height: 7.0,
            ),
            stockInput,
            label("Discount offered"),
            const SizedBox(
              height: 7.0,
            ),
            discountInput,
            label("Product Tags"),
            const SizedBox(
              height: 7.0,
            ),
            tagsInput,
            label("SKU"),
            const SizedBox(
              height: 7.0,
            ),
            skuInput,
            const SizedBox(
              height: 11.0,
            ),
            categoriesWidget(),
            const SizedBox(
              height: 25.0,
            ),
            productProvider.createOrderStatus == ProductStatus.CreatingProduct
                ? loading
                : AppButton(
                    type: ButtonType.PRIMARY,
                    text: "Add Product",
                    onPressed: () {
                      doCreateAddress();
                    }),
            const SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget categoriesWidget() {
    Widget child = Column(
      children: [
        const Text(
          'Select a category from the list below:',
          style: const TextStyle(fontSize: 19.0),
        ),
        DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            hint: const Text("Select a category for your product"),
            value: _selectedCategoryName,
            icon: const Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: AppTheme.mainBlueColor),
            // underline: Container(
            //   height: 2,
            //   color: Colors.deepPurpleAccent,
            // ),
            onChanged: (String? newValue) {
              setState(() {
                _selectedCategoryName = newValue!;
                categoryIsSelected = true;
                ProductCategory? newService = _productCategories
                    ?.where((element) => element.name == _selectedCategoryName)
                    .first;
                print("New Service: ${newService.toString()}");
                _selectedCategory = newService;
              });
            },
            items: _productCategories?.map((ProductCategory productCategory) {
              return DropdownMenuItem<String>(
                child: Text(productCategory.name!),
                value: productCategory.name,
              );
            }).toList(),
          ),
        ),
        Visibility(
          visible: categoryIsSelected,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 4,
                child: Card(
                  child: ListTile(title: Text("${_selectedCategory?.name}")),
                ),
              ),
              // Expanded(
              //   flex: 1,
              //   child: Container(
              //     decoration: BoxDecoration(
              //       color: Constants.scaffoldBackgroundColor,
              //     ),
              //     child: GestureDetector(
              //       child: Icon(
              //         FlutterIcons.md_remove_circle_ion,
              //         color: Colors.black,
              //       ),
              //       onTap: () {
              //         _selectedServices
              //             .remove(_selectedServices[index]);
              //         setState(() {
              //           _selectedServices = _selectedServices;
              //         });
              //         print(
              //             "Selected services after removal: ${this._selectedServices.toString()}");
              //         print(
              //             "Selected services length: ${this._selectedServices.length}");
              //       },
              //     ),
              //   ),
              // )
            ],
          ),
        )
      ],
    );
    return child;
  }

  Future<bool> launchPasswordResetURl(String imageURL) async {
    Future<bool> success;
    bool canWait = await canLaunch(imageURL);
    print("canwait status: $canWait");
    if (canWait) {
      success = launch(imageURL);
    } else {
      success = Future.delayed(Duration.zero, () => false);
    }
    return success;
  }
}
