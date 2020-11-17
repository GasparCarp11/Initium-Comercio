import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:initium_2_comercio/Shop/bloc/bloc_shop.dart';
import 'package:initium_2_comercio/Shop/ui/screens/sign_in_screen.dart';
import 'package:initium_2_comercio/Shop/ui/widgets/navigation_bar.dart';
import 'package:initium_2_comercio/Shop/ui/widgets/order_view.dart';

class InitiumScreen extends StatefulWidget {
  InitiumScreen({Key key}) : super(key: key);

  @override
  _InitiumScreenState createState() => _InitiumScreenState();
}

class _InitiumScreenState extends State<InitiumScreen> {
  ShopBloc shopBloc;
  @override
  Widget build(BuildContext context) {
    shopBloc = BlocProvider.of(context);
    return Scaffold(
        appBar: createAppBar(context),
        backgroundColor: Colors.blueGrey[800],
        bottomNavigationBar: NavigationBar(),
        body: StreamBuilder(
            stream: shopBloc.showOrders(shopInfo["uid"]),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  snapshot.connectionState == ConnectionState.none) {
                return Center(
                  child: Column(
                    children: [
                      Text("Obteniendo información de los pedidos"),
                      CircularProgressIndicator(),
                    ],
                  ),
                );
              }
              if (snapshot.hasData) {
                List<DocumentSnapshot> data = snapshot.data.docs;
                return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, index) {
                      Map<String, dynamic> orders = data[index].data();
                      return OrderView(
                        orders: orders,
                        onPress: () {
                          infoOrder(orders);
                        },
                      );
                    });
              } else {
                return Center(
                  child: Text("No existen pedidos o no pudimos encontrarlos"),
                );
              }
            }));
  }

  void infoOrder(Map orders) {
    shopBloc.userInfo(orders["buyer"]).then((value) {
      Map<String, dynamic> userInfo = value.data();
      List products_order = orders["products"];
      Timestamp orderDate = orders["date"];
      Duration durationOrder = -orderDate.toDate().difference(DateTime.now());
      bool inHour;
      bool orderReady = true;
      if (durationOrder.inMinutes > 60) {
        inHour = false;
      } else {
        inHour = true;
      }

      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
              elevation: 10,
              insetPadding: EdgeInsets.all(25),
              contentTextStyle: TextStyle(
                  color: Colors.white,
                  fontFamily: "Montserrat",
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
              titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontFamily: "Montserrat",
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
              backgroundColor: Colors.blueGrey[900],
              contentPadding:
                  EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  textInfo("Comprador: ", "${userInfo["name"]}"),
                  SizedBox(height: 20),
                  textInfo(
                      "Pedido hace: ",
                      inHour
                          ? "+${durationOrder.inMinutes.toInt().toString()}MIN"
                          : "+${durationOrder.inHours.toInt().toString()}HS"),
                  SizedBox(height: 20),
                  listProducts(context, products_order),
                  SizedBox(height: 20),
                  textInfo(
                      "Importe total: ", "\$${orders["ammount"].toString()}"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      button("CANCELAR", Colors.red[300], Colors.red[700],
                          orders, false),
                      button("AVANZAR", Colors.blue[300], Colors.blue[800],
                          orders, true)
                    ],
                  ),
                ],
              ));
        },
      );
    });
  }

  Widget listProducts(BuildContext context, List products_order) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 300,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black, width: 4),
          gradient: LinearGradient(
              colors: [Colors.blue[900], Colors.blue[400]],
              begin: FractionalOffset(0.2, 0.0),
              end: FractionalOffset(1.0, 0.6),
              stops: [0.0, 0.6],
              tileMode: TileMode.clamp)),
      child: ListView.builder(
          itemCount: products_order.length,
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.all(5),
              child: Text("- ${products_order[index]}"),
            );
          }),
    );
  }

  AppBar createAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blueGrey[900],
      centerTitle: true,
      title: Text(
        'Pedidos',
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

  Widget textInfo(String info, String data, {inHour}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 30,
      child: Row(
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(top: 5, left: 8),
              width: 290,
              height: 30,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2.5),
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                      colors: [Colors.blue[900], Colors.blue[400]],
                      begin: FractionalOffset(0.2, 0.0),
                      end: FractionalOffset(1.0, 0.6),
                      stops: [0.0, 0.6],
                      tileMode: TileMode.clamp)),
              child: Text(info + data))
        ],
      ),
    );
  }

  Widget button(
      String data, Color color1, Color color2, Map orders, bool work) {
    return InkWell(
      onTap: () {
        if (work == true) {
          Navigator.pushNamed(context, "bluetooth",
              arguments: orders["uidorder"]);
        }
        if (work == false) {
          Navigator.pop(context);
        }
      },
      child: Container(
        margin: EdgeInsets.only(top: 30, bottom: 10),
        width: 125,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            gradient: LinearGradient(
                colors: [color1, color2],
                begin: FractionalOffset(0.2, 0.0),
                end: FractionalOffset(1.0, 0.6),
                stops: [0.0, 0.6],
                tileMode: TileMode.clamp)),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Text(
              data,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: "Montserrat",
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}
