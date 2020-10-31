import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:initium_2_comercio/Shop/bloc/bloc_shop.dart';
import 'package:initium_2_comercio/Shop/services/cloud_firestore.dart';
import 'package:initium_2_comercio/Shop/ui/screens/sign_in_screen.dart';
import 'package:initium_2_comercio/Shop/ui/widgets/navigation_bar.dart';
import 'package:linear_gradient/linear_gradient.dart';

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
              print("Snapashot");
              print(snapshot.connectionState);
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
              } else if (snapshot.data == null) {
                return Center(
                    child: Text("Error al obtener información de los pedidos"));
              } else if (snapshot.hasData) {
                List<DocumentSnapshot> data = snapshot.data.docs;
                return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, index) {
                      Map<String, dynamic> orders = data[index].data();
                      print(orders);
                      return InkWell(
                        onTap: () {},
                        child: Container(
                          margin: EdgeInsets.all(10.0),
                          padding: EdgeInsets.only(left: 8.0),
                          width: MediaQuery.of(context).size.width,
                          height: 80,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              gradient: LinearGradientStyle.linearGradient(
                                orientation:
                                    LinearGradientStyle.ORIENTATION_HORIZONTAL,
                                gradientType: LinearGradientStyle
                                    .GRADIENT_TYPE_MIDNIGHT_CITY,
                              ),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Colors.black38,
                                    blurRadius: 10.0,
                                    spreadRadius: 3.0,
                                    offset: Offset(2.0, 10.0))
                              ]),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: FadeInImage(
                                  placeholder: AssetImage('assets/loading.gif'),
                                  fadeInDuration: Duration(milliseconds: 10),
                                  image: AssetImage("assets/initium.png"),
                                  fit: BoxFit.contain,
                                  height: 90,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "PEDIDO #${orders["uidorder"]}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    Text(
                                      "\$${orders["ammount"].toString()}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Icon(
                                  Icons.assignment,
                                  color: Colors.blue[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              }
            }));
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
}
