import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/card_products.dart';
import 'package:loja_virtual/datas/products_data.dart';
import 'package:loja_virtual/models/cart_model.dart';

class CartTile extends StatelessWidget {
  final CartProduct cartProduct;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  CartTile(this.cartProduct);

  @override
  Widget build(BuildContext context) {
    if (cartProduct.category.isEmpty || cartProduct.pid.isEmpty) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Container(
          height: 70.0,
          alignment: Alignment.center,
          child: Text(
            'Produto inválido\nCategoria: ${cartProduct.category}\nPID: ${cartProduct.pid}',
            style: TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: cartProduct.productData == null
          ? FutureBuilder<DocumentSnapshot>(
        future: firestore
            .collection("products")
            .doc(cartProduct.category)
            .collection("items")
            .doc(cartProduct.pid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: 70.0,
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData && snapshot.data!.exists) {
            cartProduct.productData =
                ProductData.fromDocument(snapshot.data!);
            return _buildContent(context);
          } else {
            return Container(
              height: 70.0,
              alignment: Alignment.center,
              child: Text("Erro ao carregar produto"),
            );
          }
        },
      )
          : _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    CartModel.of(context).updatePrices();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 120.0,
          padding: EdgeInsets.all(8.0),
          child: Image.network(
            cartProduct.productData?.images[0] ?? '',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
          ),
        ),
        Expanded(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    cartProduct.productData?.title ?? 'Produto sem título',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17.0),
                  ),
                  Text(
                    "Tamanho: ${cartProduct.size}",
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                  Text(
                    "AOA ${cartProduct.productData?.price.toStringAsFixed(2) ?? '0.00'}",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          onPressed: cartProduct.quantity > 1 ? () {
                            CartModel.of(context).decProduct(cartProduct);
                          } : null,
                          icon: Icon(
                            Icons.remove,
                            color: Theme.of(context).primaryColor,
                          )),
                      Text(cartProduct.quantity.toString()),
                      IconButton(
                          onPressed: () {
                            CartModel.of(context).incProduct(cartProduct);
                          },
                          icon: Icon(
                            Icons.add,
                            color: Theme.of(context).primaryColor,
                          )),
                      TextButton(
                        onPressed: () {
                          CartModel.of(context).removeCartItem(cartProduct);
                        },
                        child: Text(
                          "Remover",
                          style: TextStyle(color: Colors.grey),
                        ),
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0))),
                      )
                    ],
                  )
                ],
              ),
            ))
      ],
    );
  }
}
