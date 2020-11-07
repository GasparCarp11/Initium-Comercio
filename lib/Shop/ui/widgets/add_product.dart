import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:initium_2_comercio/Shop/bloc/bloc_shop.dart';
import 'package:initium_2_comercio/Shop/ui/screens/sign_in_screen.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key key}) : super(key: key);

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  String nameProduct;
  var prizeProduct;

  @override
  Widget build(BuildContext context) {
    File image = ModalRoute.of(context).settings.arguments;
    ShopBloc shopBloc = BlocProvider.of(context);
    return Scaffold(
      backgroundColor: Colors.blueGrey[800],
      resizeToAvoidBottomPadding: false,
      body: Container(
        child: Column(
          children: <Widget>[
            _cardtipo2(image),
            Container(
              margin: EdgeInsets.all(10),
              height: 80,
              width: MediaQuery.of(context).size.width - 30,
              child: TextField(
                textAlign: TextAlign.start,
                keyboardType: TextInputType.name,
                enableInteractiveSelection: false,
                textAlignVertical: TextAlignVertical.center,
                cursorColor: Colors.white,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w400),
                decoration: InputDecoration(
                  labelText: "Nombre del producto",
                  labelStyle: TextStyle(
                      color: Colors.white,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w800),
                  icon: Icon(
                    Icons.assignment,
                    color: Colors.white,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    nameProduct = value;
                  });
                },
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              height: 80,
              width: MediaQuery.of(context).size.width - 30,
              child: TextField(
                textAlign: TextAlign.start,
                keyboardType: TextInputType.number,
                enableInteractiveSelection: false,
                textAlignVertical: TextAlignVertical.center,
                cursorColor: Colors.white,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w400),
                decoration: InputDecoration(
                  labelText: "Precio del producto",
                  labelStyle: TextStyle(
                      color: Colors.white,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w800),
                  icon: Icon(
                    Icons.attach_money,
                    color: Colors.white,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    prizeProduct = value;
                  });
                },
              ),
            ),
            InkWell(
              onTap: () {
                shopBloc
                    .uploadPhoto(
                        "${shopInfo["uid"]}/${DateTime.now().toString()}.jpg",
                        image)
                    .then((StorageUploadTask storageUploadTask) {
                      storageUploadTask.onComplete
                          .then((StorageTaskSnapshot snapshot) {
                        snapshot.ref.getDownloadURL().then((urlImage) {
                          print("lo hace?");
                          shopBloc.newProduct(
                              true, nameProduct, prizeProduct, urlImage);
                        });
                      });
                    })
                    .whenComplete(() => Navigator.pop(context))
                    .catchError((onError) {
                      print("Error: ${onError}");
                    });
              },
              child: Container(
                margin: EdgeInsets.only(top: 20),
                width: 250,
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
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      "CONFIRMAR",
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
            )
          ],
        ),
      ),
    );
  }

  Widget _cardtipo2(image) {
    final card = Container(
      child: Column(
        children: <Widget>[
          Image.file(
            image,
            height: 300,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );

    return Container(
      margin: EdgeInsets.only(left: 15, right: 15, top: 40, bottom: 30),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30.0),
        child: card,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                spreadRadius: 2.0,
                offset: Offset(2.0, 10.0))
          ]),
    );
  }

  Widget _textfield(
      BuildContext context,
      TextInputType inputType,
      IconData iconData,
      String labeltext,
      TextEditingController controller,
      String value) {
    return Container(
      margin: EdgeInsets.all(10),
      height: 80,
      width: MediaQuery.of(context).size.width - 30,
      child: TextField(
        textAlign: TextAlign.start,
        keyboardType: inputType,
        controller: controller,
        enableInteractiveSelection: false,
        textAlignVertical: TextAlignVertical.center,
        cursorColor: Colors.white,
        style: TextStyle(
            color: Colors.white,
            fontFamily: "Montserrat",
            fontWeight: FontWeight.w400),
        decoration: InputDecoration(
          labelText: labeltext,
          labelStyle: TextStyle(
              color: Colors.white,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w800),
          icon: Icon(
            iconData,
            color: Colors.white,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        onChanged: (value) {
          setState(() {
            value = value;
          });
        },
      ),
    );
  }

  Widget _addButton(BuildContext context, TextEditingController nameProduct,
      TextEditingController prizeProduct, image) {
    ShopBloc shopBloc = BlocProvider.of(context);
    return InkWell(
      onTap: () {
        // shopBloc.uploadPhoto(image.path, image);
      },
      child: Container(
        margin: EdgeInsets.only(top: 20),
        width: 250,
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
          child: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Text(
              "CONFIRMAR",
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
