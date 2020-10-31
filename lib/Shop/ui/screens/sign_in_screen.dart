import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:initium_2_comercio/Shop/bloc/bloc_shop.dart';
import 'package:initium_2_comercio/Shop/services/cloud_firestore.dart';

Map<String, dynamic> shopInfo;

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController idcontroller;
  String idShop;

  @override
  Widget build(BuildContext context) {
    ShopBloc shopBloc = BlocProvider.of(context);
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      key: _scaffoldKey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Container(
              child: Container(
                margin: EdgeInsets.only(left: 30.0),
                child: Row(
                  children: [
                    Text(
                      "Initium para\nComercios.",
                      style: TextStyle(
                        fontSize: 28.0,
                        fontFamily: "Montserrat",
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    Image(
                      image: AssetImage('assets/initium.png'),
                      height: 80,
                      width: 150,
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 20, right: 25, left: 25),
            child: TextField(
              style: TextStyle(color: Colors.white, fontFamily: "Montserrat"),
              controller: idcontroller,
              decoration: InputDecoration(
                  labelText: "Ingrese su Initium ID",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  )),
              onChanged: (value) {
                idShop = value;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: InkWell(
                onTap: () {
                  shopBloc.authShop(idShop).then((value) {
                    shopInfo = value.data();
                    if (shopInfo != null) {
                      print(shopInfo);
                      Navigator.pushNamed(context, "stock");
                    }
                    if (shopInfo == null) {
                      show("ID inválido, verifique que este bien escrito.");
                    }
                  });
                },
                child: Container(
                  width: 150,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      gradient: LinearGradient(
                          colors: [Colors.blue[900], Colors.blue[400]],
                          begin: FractionalOffset(0.2, 0.0),
                          end: FractionalOffset(1.0, 0.6),
                          stops: [0.0, 0.6],
                          tileMode: TileMode.clamp)),
                  child: Container(
                    padding: EdgeInsets.only(top: 13),
                    child: Text(
                      "Continuar",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: "Montserrat",
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  Future show(
    String message, {
    Duration duration: const Duration(seconds: 4),
  }) async {
    await new Future.delayed(new Duration(milliseconds: 100));
    _scaffoldKey.currentState.showSnackBar(
      new SnackBar(
        backgroundColor: Colors.blueGrey[800],
        content: new Text(
          message,
          textAlign: TextAlign.center,
          maxLines: 1,
          style: TextStyle(
              color: Colors.blue[600],
              fontWeight: FontWeight.w800,
              fontFamily: "Montserrat",
              fontSize: 14),
        ),
        duration: duration,
      ),
    );
  }
}
