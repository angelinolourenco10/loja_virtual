

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {
  final String orderId;
  OrderScreen(this.orderId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pedido realizado", style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child:Icon(Icons.check, color: Theme.of(context).primaryColor,
              size: 80.0,),),
            Center(child:Text("Pedido realizado com sucesso", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
            ),
            Center(child: Text("Codigo do pedido ${orderId}", style: TextStyle(fontSize: 16.0),),)
          ],
        ),
      ),
    );
  }
}
