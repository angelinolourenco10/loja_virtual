import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/Screens/login_screen.dart';
import 'package:loja_virtual/Screens/signup_screen.dart';
import 'package:loja_virtual/models/cart_model.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

import 'Screens/Home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
        model: UserModel(),
        child: ScopedModelDescendant<UserModel>(
          builder: (context, child, model){
            return ScopedModel<CartModel>(
                model: CartModel(model),
                child:MaterialApp(
                    title: 'Flutter Demo',
                    theme: ThemeData(
                        iconTheme: IconThemeData(color: Colors.white),
                        primarySwatch: Colors.blue,
                        primaryColor: Color.fromARGB(255, 4, 125, 141)),
                    debugShowCheckedModeBanner: false,
                    home: HomeScreen()));
          },
        )
    );
  }
}
