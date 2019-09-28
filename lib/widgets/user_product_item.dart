import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/providers/products.dart';
import 'package:flutter_ecommerce/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String id;

  UserProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final _scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(this.title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName, arguments: this.id);
            },
            color: Theme.of(context).primaryColor,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            /*onPressed: (){
              Provider.of<Products>(context, listen: false).deleteProduct(this.id);
            },*/
            onPressed: () async {
              try {
                await Provider.of<Products>(context, listen: false).deleteProduct(this.id);
              } catch (error) {
                _scaffold.showSnackBar(SnackBar(content: Text(error.toString())));
              }
            },
            color: Theme.of(context).errorColor,
          ),
        ],
      ),
    );
  }
}
