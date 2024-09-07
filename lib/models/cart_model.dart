import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/datas/card_products.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {
  String coupomCode = '0';
  int discountPercentage = 0;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late UserModel user;
  List<CartProduct> products = [];
  bool isLoading = false;

  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  CartModel(this.user) {
    if (user.isLoggedIn()) {
      _loadCartItems();
    }
  }

  // Adicionar produto ao carrinho
  void addCartItem(CartProduct cartProduct) {
    if (cartProduct.category.isEmpty || cartProduct.pid.isEmpty) {
      print('Produto inválido: categoria ou ID do produto não definidos');
      return;
    }

    products.add(cartProduct);
    firestore
        .collection("users")
        .doc(user.firebaseUser?.uid)
        .collection("cart")
        .add(cartProduct.toMap())
        .then((doc) {
      cartProduct.cid = doc.id;
      notifyListeners();
    }).catchError((e) {
      print('Erro ao adicionar produto ao carrinho: $e');
    });
  }

  // Remover produto do carrinho
  void removeCartItem(CartProduct cartProduct) {
    if (cartProduct.cid.isEmpty) {
      print('Produto inválido: CID vazio');
      return;
    }

    firestore
        .collection("users")
        .doc(user.firebaseUser?.uid)
        .collection("cart")
        .doc(cartProduct.cid)
        .delete()
        .then((_) {
      products.remove(cartProduct);
      notifyListeners();
    }).catchError((e) {
      print('Erro ao remover produto do carrinho: $e');
    });
  }

  // Diminuir quantidade de produto
  void decProduct(CartProduct cartProduct) {
    if (cartProduct.cid.isEmpty) {
      print('Produto inválido: CID vazio');
      return;
    }

    if (cartProduct.quantity > 1) {
      cartProduct.quantity--;
      firestore
          .collection("users")
          .doc(user.firebaseUser?.uid)
          .collection("cart")
          .doc(cartProduct.cid)
          .update(cartProduct.toMap())
          .then((_) {
        notifyListeners();
      }).catchError((e) {
        print('Erro ao decrementar quantidade do produto: $e');
      });
    }
  }

  // Aumentar quantidade de produto
  void incProduct(CartProduct cartProduct) {
    if (cartProduct.cid.isEmpty) {
      print('Produto inválido: CID vazio');
      return;
    }

    cartProduct.quantity++;
    firestore
        .collection("users")
        .doc(user.firebaseUser?.uid)
        .collection("cart")
        .doc(cartProduct.cid)
        .update(cartProduct.toMap())
        .then((_) {
      notifyListeners();
    }).catchError((e) {
      print('Erro ao incrementar quantidade do produto: $e');
    });
  }

  // Carregar itens do carrinho do Firestore
  void _loadCartItems() async {
    isLoading = true;
    notifyListeners();

    try {
      QuerySnapshot query = await firestore
          .collection("users")
          .doc(user.firebaseUser?.uid)
          .collection("cart")
          .get();

      products = query.docs.map((doc) {
        CartProduct cartProduct = CartProduct.fromDocument(doc);

        // Verifica se o `cid` está vazio e corrige se necessário
        if (cartProduct.cid.isEmpty) {
          cartProduct.cid = doc.id;
          doc.reference.update({'cid': cartProduct.cid});
        }

        return cartProduct;
      }).toList();

      // Remove produtos inválidos após carregar os itens
      removeInvalidProducts();
    } catch (e) {
      print('Erro ao carregar itens do carrinho: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Remover produtos inválidos
  void removeInvalidProducts() {
    List<CartProduct> invalidProducts = products
        .where((product) => product.category.isEmpty || product.pid.isEmpty)
        .toList();

    for (var product in invalidProducts) {
      removeCartItem(product);
    }
  }

  // Definir cupom de desconto
  void setCoupon(String code, int discountPercentage) {
    coupomCode = code;
    this.discountPercentage = discountPercentage;
    notifyListeners();
  }

  // Calcular preço total dos produtos
  double getProductPrice() {
    double price = 0.0;
    for (CartProduct c in products) {
      if (c.productData != null) {
        price += c.quantity * c.productData!.price;
      }
    }
    return price;
  }

  // Calcular valor do desconto
  double getDiscount() {
    return getProductPrice() * discountPercentage / 100;
  }

  // Valor do frete
  double getShipPrice() {
    return 9.99;
  }

  // Atualizar preços e chamar notificação
  void updatePrices() {
    notifyListeners();
  }

  // Finalizar pedido e salvar no Firestore
  Future<String?> finishOrder() async {
    if (products.isEmpty) return null;

    isLoading = true;
    notifyListeners();

    double productPrice = getProductPrice();
    double shipPrice = getShipPrice();
    double discount = getDiscount();

    // Adicionando o pedido na coleção "orders"
    DocumentReference refOrder = await firestore.collection("orders").add({
      "clienteID": user.firebaseUser!.uid,
      // Salvando o 'products' como uma lista de mapas JSON válidos
      "products": products.map((cartProduct) => cartProduct.toMap()).toList(),
      "shipPrice": shipPrice,
      "productsPrice": productPrice,
      "discount": discount,
      "totalPrice": productPrice - discount + shipPrice,
      "status": 1,
    });

    // Adicionando o pedido na coleção "orders" do usuário
    await firestore
        .collection("users")
        .doc(user.firebaseUser!.uid)
        .collection("orders")
        .doc(refOrder.id)
        .set({
      "orderId": refOrder.id,
    });

    // Limpando o carrinho após finalizar o pedido
    QuerySnapshot querySnapshot = await firestore
        .collection("users")
        .doc(user.firebaseUser!.uid)
        .collection("cart")
        .get();

    for (DocumentSnapshot doc in querySnapshot.docs) {
      doc.reference.delete();
    }

    // Limpando os dados locais do carrinho
    products.clear();
    coupomCode = "";
    discountPercentage = 0;
    isLoading = false;
    notifyListeners();

    return refOrder.id;
  }
}
