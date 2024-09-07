import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/Screens/products_screen.dart';

class CategoryTile extends StatelessWidget {
  final DocumentSnapshot snapshot;

  CategoryTile(this.snapshot);

  @override
  Widget build(BuildContext context) {
    final data = snapshot.data() as Map<String, dynamic>?;

    // Verifique se `data` é nulo para evitar erros em tempo de execução
    if (data == null) {
      return ListTile(
        title: Text('Dados indisponíveis'),
      );
    }

    final iconUrl = data['icon'] as String?;
    final title = data['title'] as String?;

    return ListTile(
      leading: CircleAvatar(
        radius: 25.0,
        backgroundColor: Colors.transparent,
        backgroundImage: iconUrl != null ? NetworkImage(iconUrl) : null,
      ),
      title: Text(title ?? 'Sem título'),
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => CategoryScreen(snapshot)));
      },
    );
  }
}
