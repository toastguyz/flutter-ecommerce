import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/providers/cart.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  CartItem(this.id, this.productId, this.price, this.quantity, this.title);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Are you sure ?"),
                content: Text("Do you want to remove the item from the cart?"),
                actions: <Widget>[
                  FlatButton(child: Text("No"),onPressed: (){
                    Navigator.of(context).pop(false);
                  },),
                  FlatButton(child: Text("Yes"),onPressed: (){
                    Navigator.of(context).pop(true);
                  },),
                ],
              );
            });
      },
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40.0,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.0),
        margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: FittedBox(child: Text("\$${price}")),
              ),
            ),
            title: Text(title),
            subtitle: Text("Total : \$${price * quantity}"),
            trailing: Text("x ${quantity}"),
          ),
        ),
      ),
    );
  }
}
