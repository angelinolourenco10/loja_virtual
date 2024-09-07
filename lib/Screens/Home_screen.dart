
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/Tabs/Places.dart';
import 'package:loja_virtual/Tabs/products_tab.dart';
import 'package:loja_virtual/widgets/Cart_button.dart';
import 'package:loja_virtual/widgets/custom_drawer.dart';

import '../Tabs/Home_tab.dart';
import '../Tabs/orders_tab.dart';

class HomeScreen extends StatelessWidget {
  final _pageController= PageController();
  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Scaffold(
          body: HomeTab(),
          drawer: CustomDrawer(_pageController),
          floatingActionButton: CartButton(),
        ),
        Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            title: Text("Produtos", style: TextStyle(color: Colors.white),),
            centerTitle: true,
            backgroundColor: Theme.of(context).primaryColor,
          ),
          drawer: CustomDrawer(_pageController),
          floatingActionButton: CartButton(),
          body: ProductsTab(),
        ),
        Scaffold(
            appBar: AppBar(
              title:Text("Lojas", style: TextStyle(color: Colors.white),) ,
              backgroundColor: Theme.of(context).primaryColor,
              centerTitle: true,
              iconTheme: IconThemeData(color: Colors.white),
            ),
          body: PlacesTab(),
          drawer: CustomDrawer(_pageController),
        ),
        Scaffold(
          appBar: AppBar(
            title:Text("Meus Pedidos", style: TextStyle(color: Colors.white),) ,
            backgroundColor: Theme.of(context).primaryColor,
            centerTitle: true,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          body: OrderTabs(),
          drawer: CustomDrawer(_pageController),
        )
      ],
    );
  }
}
