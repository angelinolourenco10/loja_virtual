import 'dart:convert'; // Para usar jsonDecode
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderTile extends StatelessWidget {
  final String orderId;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  OrderTile(this.orderId);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot?>(
      stream: firestore.collection("orders").doc(orderId).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data!.exists || snapshot.data!.data() == null) {
          // Retorna um widget vazio (tela em branco) se o pedido não existir ou for inválido
          return Container();
        } else {
          int Status= snapshot.data?["status"];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
            margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Código do pedido: ${snapshot.data!.id}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    _buildProductsText(snapshot.data!),style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 4.0,),
                  Text(
                    "Status do Pedido:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [

                      _buildCircle("1", "Preparação", Status, 1),
                      Container(height: 1.0,width: 40.0,color: Colors.grey,),
                      _buildCircle("2", "Transporte", Status, 2),
                      Container(height: 1.0,width: 40.0,color: Colors.grey,),
                      _buildCircle("3", "Entrega", Status, 3),
                    ],
                  )
                ],
              ),
            ),
          );
        }
      },
    );
  }

  String _buildProductsText(DocumentSnapshot snapshot) {
    String text = "Descrição:\n";

    // Acessar o campo 'products' e garantir que é uma lista
    var productsField = snapshot["products"];

    if (productsField is List) {
      for (var p in productsField) {
        // Se o produto é uma String, ajustar o formato
        if (p is String) {
          try {
            // Ajustar o formato da string para JSON válido
            String jsonString = p
                .replaceAll(RegExp(r'(\w+):'), r'"\1":') // Adiciona aspas para chaves
                .replaceAll(RegExp(r'(\w+)'), r'"\1"') // Adiciona aspas para valores
                .replaceAll(',,', ','); // Remove vírgulas extras

            // Converter a string JSON para um mapa
            p = jsonDecode(jsonString);
          } catch (e) {
            text += "Produto inválido: Erro ao decodificar.\n";
            continue;
          }
        }

        if (p is Map<String, dynamic>) {
          var quantity = p["quantity"] ?? 0;
          var size = p["size"] ?? "Tamanho não especificado";
          var productData = p["productData"] ?? {};
          var title = productData["title"] ?? "Produto desconhecido";
          var price = productData["price"]?.toDouble() ?? 0.0;

          text += "${quantity} x $title (Tamanho: $size) - AOA ${price.toStringAsFixed(2)}\n";
        } else {
          text += "Produto inválido: ${p.toString()}\n";
        }
      }
    } else {
    }

    // Adicionar o total do pedido
    double totalPrice = snapshot["totalPrice"]?.toDouble() ?? 0.0;
    text += "Total: AOA ${totalPrice.toStringAsFixed(2)}";

    return text;
  }

  Widget _buildCircle(String title, String subtitle, int Status, int thisStatus){
    Color backColor;
    Widget child;

    if(Status<thisStatus){
      backColor = Colors.grey;
      child=Text(title, style: TextStyle(color: Colors.white),);
    }else if(Status== thisStatus){
      backColor= Colors.blue;
      child= Stack(
        alignment: Alignment.center,
        children: [
          Text(title, style: TextStyle(color: Colors.white),),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.white),
          )
        ],
      );
    }else{
      backColor= Colors.green;
      child= Icon(Icons.check, color: Colors.white,);
    }
    return Column(
      children: [
        CircleAvatar(
          radius: 20.0,
          backgroundColor: backColor,
          child: child,
        ),
        Text(subtitle)
      ],
    );
  }
}
