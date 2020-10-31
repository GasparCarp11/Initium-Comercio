import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:initium_2_comercio/Shop/bloc/bloc_shop.dart';
import 'package:initium_2_comercio/Shop/ui/screens/sign_in_screen.dart';
import 'package:initium_2_comercio/Shop/ui/widgets/list_products.dart';
import 'package:initium_2_comercio/Shop/ui/widgets/navigation_bar.dart';
import 'package:initium_2_comercio/Shop/ui/widgets/shop_info.dart';
import 'package:initium_2_comercio/gradient_back.dart';

class StockScreen extends StatelessWidget {
  ShopBloc shopBloc;
  @override
  Widget build(BuildContext context) {
    shopBloc = BlocProvider.of(context);
    return Scaffold(
      appBar: createAppBar(shopInfo, context),
      bottomNavigationBar: NavigationBar(),
      backgroundColor: Colors.blueGrey[800],
      body: Column(
        children: [
          InfoShop(),
          Divider(
            height: 40,
            thickness: 5,
            color: Colors.blue[900],
          ),
          Expanded(child: ListProducts()),
        ],
      ),
    );
  }

  AppBar createAppBar(Map infoshop, BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blueGrey[900],
      leading: Padding(
        padding: const EdgeInsets.all(8),
        child: CircleAvatar(
          backgroundImage: NetworkImage(infoshop['photoURL']),
        ),
      ),
      centerTitle: true,
      title: Text(
        'Mis productos',
        style: TextStyle(
            fontFamily: 'Montserrat',
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25),
      ),
      actions: [
        IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => {Navigator.pushNamed(context, "/")})
      ],
    );
  }
}
