import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/cart_model.dart';

class DiscountCard extends StatelessWidget {
  const DiscountCard({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTile(
        title: Text(
          "Cupom de desconto",
          textAlign: TextAlign.start,
          style:
          TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[700]),
        ),
        leading: Icon(
          Icons.card_giftcard,
          color: Colors.grey,
        ),
        trailing: Icon(
          Icons.add,
          color: Colors.grey,
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Digite seu cupom",
              ),
              initialValue: CartModel.of(context).coupomCode ?? "",
              onFieldSubmitted: (text) async {
                try {
                  DocumentSnapshot docSnap =
                  await firestore.collection("coupons").doc(text).get();
                  if (docSnap.exists) {
                    final data = docSnap.data() as Map<String, dynamic>;
                    int percent = data["percent"] ?? 0;
                    CartModel.of(context).setCoupon(text, percent);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                        Text("Desconto de $percent% aplicado"),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Cupom não existente"),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Erro ao validar cupom: $e"),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
