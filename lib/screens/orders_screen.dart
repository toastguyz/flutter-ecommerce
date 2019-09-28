import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/providers/orders.dart' show Orders;
import 'package:flutter_ecommerce/widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import 'package:flutter_ecommerce/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = "/orders";

//  var _isLoading = false;

//  @override
//  void initState() {
  // Method-1

  /*Future.delayed(Duration.zero).then((_) async {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
      setState(() {
        _isLoading = false;
      });
    });*/

  // Method-2

  /*_isLoading = true;

    // WILL WORK ONLY DUE TO "listen:false" attribute of provider
    Provider.of<Orders>(context, listen: false).fetchAndSetOrders().then((_) {
      setState(() {
        _isLoading = false;
      });
    });*/

//    super.initState();
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      drawer: AppDrawer(),
      /*body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: orderData.orders.length,
              itemBuilder: (BuildContext context, int index) {
                return OrderItem(orderData.orders[index]);
              },
            ),*/
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.error != null) {
              return Center(
                child: Text("An error occured!!"),
              );
            } else {
              return Consumer<Orders>(
                builder:
                    (BuildContext context, Orders orderData, Widget child) {
                  if (orderData.orders != null) {
                    if (orderData.orders.length > 0) {
                      return ListView.builder(
                        itemCount: orderData.orders.length,
                        itemBuilder: (BuildContext context, int index) {
                          return OrderItem(orderData.orders[index]);
                        },
                      );
                    } else {
                      return Center(
                        child: Text(
                          "No Data Found!!",
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.w500),
                        ),
                      );
                    }
                  } else {
                    return Center(
                      child: Text(
                        "No Data Found!!",
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.w500),
                      ),
                    );
                  }
                },
              );
            }
          }
        },
      ),
    );
  }
}
