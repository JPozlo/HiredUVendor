import 'package:flutter/material.dart';
import 'package:hired_u_vendor/models/models.dart';
import 'package:hired_u_vendor/pages/pages.dart';
import 'package:hired_u_vendor/services/services.dart';

enum PaymentStatus{
  pending,
  successful,
  failed,
  cancelled,
  error
}

class PaymentList extends StatefulWidget {
  const PaymentList({Key? key}) : super(key: key);

  @override
  _PaymentListState createState() => _PaymentListState();
}

class _PaymentListState extends State<PaymentList> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  List<Payment> _userAddresses = [];
  late Future<Result> _paymentsListFuture;

  List<Payment> tempPaymentsList = [
    Payment(
        id: 0,
        amount: 9029,
        serviceOrdersId: 3,
        updatedAt: "2021/03/12",
        createdAt: "2021/02/01"),
    Payment(
        id: 0,
        amount: 9029,
        serviceOrdersId: 3,
        updatedAt: "2021/03/12",
        createdAt: "2021/02/01"),
    Payment(
        id: 0,
        amount: 9029,
        serviceOrdersId: 3,
        updatedAt: "2021/03/12",
        createdAt: "2021/02/01"),
    Payment(
        id: 0,
        amount: 9029,
        serviceOrdersId: 3,
        updatedAt: "2021/03/12",
        createdAt: "2021/02/01"),
    Payment(
        id: 0,
        amount: 9029,
        serviceOrdersId: 3,
        updatedAt: "2021/03/12",
        createdAt: "2021/02/01"),
    Payment(
        id: 0,
        amount: 9029,
        serviceOrdersId: 3,
        updatedAt: "2021/03/12",
        createdAt: "2021/02/01"),
    Payment(
        id: 0,
        amount: 9029,
        serviceOrdersId: 3,
        updatedAt: "2021/03/12",
        createdAt: "2021/02/01"),
  ];

  @override
  void initState() {
    super.initState();
    _paymentsListFuture = ApiService().fetchPaymentsList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Builder(builder: (context) {
          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Hero(
                      tag: 'backarrow',
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back,
                          size: response.setHeight(23),
                        ),
                      ),
                    ),
                    Spacer(flex: 5),
                    Text(
                      "Your Payments",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: response.setFontSize(18),
                      ),
                    ),
                    Spacer(flex: 5),
                  ],
                ),
              ),
              FutureBuilder(
                future: _paymentsListFuture,
                builder: (context, AsyncSnapshot<Result> snapshot) {
                  Widget defaultWidget;
                  switch (snapshot.connectionState) {
                    case ConnectionState.done:
                      if (snapshot.hasData && snapshot.data != null) {
                        if (snapshot.data!.paymentsHistory!.length > 0) {
                          defaultWidget =
                              mainDisplayWidget(snapshot.data!.paymentsHistory!);
                        } else {
                          defaultWidget = errorWidget();
                        }
                      } else {
                        defaultWidget = errorWidget();
                      }
                      break;
                    case ConnectionState.none:
                      defaultWidget = loading();
                      break;
                    case ConnectionState.waiting:
                      defaultWidget = loading();
                      break;
                    default:
                      defaultWidget = loading();
                      break;
                  }
                  return defaultWidget;
                },
              )
            ],
          );
        }),
      ),
    );
  }

  Widget loading() {
    return Center(
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            Text(" Loading ... Please wait")
          ],
        ),
      ),
    );
  }

  Widget errorWidget() {
    return Center(
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "No payments found!",
              style: TextStyle(fontSize: 23),
            )
          ],
        ),
      ),
    );
  }

  Widget mainDisplayWidget(List<PaymentHistory> paymentsList) {
    return Expanded(
      child: Container(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: paymentsList.length,
              itemBuilder: (context, index) {
                var currentItem = paymentsList[index];
                return ListTile(
                  title: Text("KSh " + currentItem.amount.toString()),
                  subtitle: Text("#" + currentItem.id.toString()),
                  trailing: Text("Status: " + currentItem.status),
                );
              })),
      flex: 90,
    );
  }


}
