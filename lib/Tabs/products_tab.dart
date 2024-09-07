import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/tiles/category_tile.dart';

class ProductsTab extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: firestore.collection("products").get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Erro ao carregar produtos"),
          );
        } else if (snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text("Nenhum produto disponível"),
          );
        } else {
          // Extraímos os documentos em uma lista
          final documents = snapshot.data!.docs;

          return ListView.separated(
            itemCount: documents.length,
            separatorBuilder: (context, index) {
              return Divider(
                color: Colors.grey[500], // Cor do divisor
                thickness: 1.0, // Espessura do divisor
              );
            },
            itemBuilder: (context, index) {
              final document = documents[index];
              return CategoryTile(document);
            },
          );
        }
      },
    );
  }
}
