import 'package:flutter/material.dart';
import 'package:hired_u_vendor/models/models.dart';
import 'package:hired_u_vendor/services/services.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Future<Result> _ordersHistoryFuture;

  @override
  void initState() {
    super.initState();
    _ordersHistoryFuture = ApiService().fetchOrdersHistoryList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 9.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Orders History",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            FutureBuilder(
              future: _ordersHistoryFuture,
              builder: (context, AsyncSnapshot<Result> snapshot) {
                Widget defaultWidget;
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    if (snapshot.hasData && snapshot.data != null) {
                      if (snapshot.data!.ordersHistoryList!.length > 0) {
                        defaultWidget =
                            mainDisplayWidget(snapshot.data!.ordersHistoryList!);
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
        ),
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
            Text("Loading ... Please wait")
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
              "No orders found!",
              style: TextStyle(fontSize: 23),
            )
          ],
        ),
      ),
    );
  }

  Widget mainDisplayWidget(List<Order> ordersList) {
    return Expanded(
      child: Container(
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: ordersList.length,
            itemBuilder: (context, index) {
              var currentOrder = ordersList[index];
              return Padding(
                padding: const EdgeInsets.all(11.0),
                child: ListTile(
                  leading: Text("#${currentOrder.id}"),
                  title: Text("KSh ${currentOrder.total.toString()}"),
                  subtitle: Text(currentOrder.description!),
                  trailing: Text(currentOrder.status!, style: TextStyle(fontWeight: FontWeight.bold),),
                ),
              );
            }),
      ),
    );
  }
}
