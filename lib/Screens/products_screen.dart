import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/products_data.dart';
import 'package:loja_virtual/tiles/product_tiles.dart';

class CategoryScreen extends StatelessWidget {
  final DocumentSnapshot snapshot;

  CategoryScreen(this.snapshot);

  @override
  Widget build(BuildContext context) {
    // Use `snapshot.get` para acessar o campo 'title'
    final categoryTitle = snapshot.get('title') ?? 'Categoria';
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              categoryTitle,
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(
                    icon: Icon(
                  Icons.grid_on,
                  color: Colors.white,
                )),
                Tab(
                    icon: Icon(
                  Icons.list,
                  color: Colors.white,
                )),
              ],
            ),
            backgroundColor: Theme.of(context).primaryColor,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          body: FutureBuilder<QuerySnapshot>(
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: CircularProgressIndicator(),
                );
              else
                return TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    GridView.builder(

                      padding: EdgeInsets.all(4.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 4,
                          childAspectRatio: 0.65),
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        ProductData data=ProductData.fromDocument(snapshot.data?.docs[index]
                        as DocumentSnapshot<Object?>);
                        data.category= this.snapshot.id;
                        return ProductTile(
                            "grid", data
                            );
                      },
                    ),
                    ListView.builder(
                      padding: EdgeInsets.all(4.0),
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        ProductData data=ProductData.fromDocument(snapshot.data?.docs[index]
                        as DocumentSnapshot<Object?>);
                        data.category= this.snapshot.id;
                        return ProductTile(
                            "list", data
                        );
                      },
                    ),
                  ],
                );
            },
            future: firestore
                .collection("products")
                .doc(snapshot.id)
                .collection("items")
                .get(),
          )),
    );
  }
}
