
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/tiles/order_tile.dart';

import '../Screens/login_screen.dart';

class OrderTabs extends StatelessWidget {

final FirebaseFirestore firestore= FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
   if(UserModel.of(context).isLoggedIn()){
 String uid= UserModel.of(context).firebaseUser!.uid;
   return FutureBuilder<QuerySnapshot>(
       future: firestore.collection("users").doc(uid).collection("orders").get(),
       builder: (context, snapshot){
         if(!snapshot.hasData)
           return Center(child: CircularProgressIndicator(),);
         else{
           return ListView(
             children: snapshot.data!.docs.map((doc)=>OrderTile(doc.id)).toList().reversed.toList(),
           );
         }
       });

   }else{
     return Container(
       padding: EdgeInsets.all(16.0),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.stretch,
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           Icon(
             Icons.view_list,
             size: 80.0,
             color: Theme.of(context).primaryColor,
           ),
           SizedBox(
             height: 16.0,
           ),
           Text(
             "Faça login para acompanhar!",
             style:
             TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
             textAlign: TextAlign.center,
           ),
           SizedBox(
             height: 16.0,
           ),
           ElevatedButton(
             onPressed: () {
               Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoginScreen()));
             },
             child: Text(
               "Entrar",
               style: TextStyle(fontSize: 18.0, color: Colors.white),
             ),
             style: ElevatedButton.styleFrom(
                 backgroundColor: Theme.of(context).primaryColor,
                 shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(0))),
           )
         ],
       ),
     );
   } return Container();
  }
}
