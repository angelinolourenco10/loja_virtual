import 'package:cloud_firestore/cloud_firestore.dart';

class ProductData {
  late String id;
  late String title;
  late String description;
  late String category;
  late double price; // Corrigido de 'prince' para 'price'
  late List<String> images; // Especificar o tipo de lista como List<String>
  late List<String> sizes;  // Especificar o tipo de lista como List<String>

  // Construtor a partir do snapshot do documento Firestore
  ProductData.fromDocument(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>?; // Obtém os dados como Map, com verificação nula
    id = snapshot.id;

    // Usa o operador null-aware (??) para valores padrão, evitando nulos
    title = data?['title'] ?? '';
    description = data?['description'] ?? '';
    price = (data?['price'] ?? 0.0).toDouble();

    // Inicializa listas garantindo que o tipo seja consistente
    images = List<String>.from(data?['images'] ?? []);
    sizes = List<String>.from(data?['sizes'] ?? []);
  }

  // Método para resumir os dados em um mapa
  Map<String, dynamic> toResumedMap() {
    return {
      "title": title,
      "description": description,
      "price": price,
    };
  }
}
