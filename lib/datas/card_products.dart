import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/datas/products_data.dart';

class CartProduct {
  String cid;
  String category;
  String pid;
  int quantity;
  String size;
  ProductData? productData;

  CartProduct({
    required this.cid,
    required this.category,
    required this.pid,
    required this.quantity,
    required this.size,
    this.productData,
  });

  CartProduct.fromDocument(DocumentSnapshot document)
      : cid = document.id,
        category = document.get('category') ?? '',
        pid = document.get('pid') ?? '',
        quantity = document.get('quantity') ?? 0,
        size = document.get('size') ?? '';

  // Método para carregar o ProductData após a criação do CartProduct
  Future<void> loadProductData() async {
    if (productData == null) {
      DocumentSnapshot productDoc = await FirebaseFirestore.instance
          .collection('products')
          .doc(category)
          .collection('items')
          .doc(pid)
          .get();

      if (productDoc.exists) {
        productData = ProductData.fromDocument(productDoc);
      }
    }
  }

  Map<String, dynamic> toMap() {
    return {
      "category": category,
      'pid': pid,
      'quantity': quantity,
      'size': size,
      'productData': productData?.toResumedMap(),
    };
  }
}


