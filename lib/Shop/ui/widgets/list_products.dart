import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:initium_2_comercio/Shop/bloc/bloc_shop.dart';
import 'package:initium_2_comercio/Shop/ui/screens/sign_in_screen.dart';

class ListProducts extends StatefulWidget {
  ListProducts({Key key});

  @override
  _ListProductsState createState() => _ListProductsState();
}

class _ListProductsState extends State<ListProducts> {
  @override
  Widget build(BuildContext context) {
    ShopBloc shopBloc = BlocProvider.of(context);
    return StreamBuilder(
        stream: shopBloc.showProducts(shopInfo["uid"]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.none) {
            return Center();
          } else if (snapshot.data == null) {
            return Center();
          } else if (snapshot.hasData) {
            List<DocumentSnapshot> data = snapshot.data.docs;
            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, index) {
                  Map<String, dynamic> products = data[index].data();
                  return ListTile(
                    leading: FadeInImage(
                      fadeInCurve: Curves.bounceIn,
                      placeholder: AssetImage('assets/loading.gif'),
                      fadeInDuration: Duration(milliseconds: 10),
                      image: NetworkImage(products["photoURL"]),
                      fit: BoxFit.contain,
                      height: 50,
                      width: 60,
                    ),
                    title: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        products["name"],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: products["available"]
                              ? Colors.white
                              : Colors.grey[700],
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    subtitle: Text(
                      products["available"]
                          ? "\$${products["prize"].toString()}"
                          : "DESHABILITADO",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: products["available"]
                            ? Colors.white
                            : Colors.grey[700],
                        fontSize: 14.0,
                      ),
                    ),
                    trailing: Icon(
                      Icons.edit,
                      color: products["available"]
                          ? Colors.white
                          : Colors.grey[700],
                    ),
                    isThreeLine: true,
                    contentPadding:
                        EdgeInsets.only(top: 10, bottom: 5, left: 6, right: 10),
                    dense: false,
                    onTap: () {
                      editDialog(
                          context, shopInfo["uid"], data[index].id, products);
                    },
                  );
                });
          }
        });
  }
}

void editDialog(
    BuildContext context, String idShop, String idProduct, Map product) {
  TextEditingController nameProduct =
      new TextEditingController(text: product["name"]);
  TextEditingController prizeProduct =
      new TextEditingController(text: "${product["prize"].toString()}");
  ShopBloc shopBloc = BlocProvider.of(context);

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return AlertDialog(
          contentTextStyle: TextStyle(
              color: Colors.white,
              fontFamily: "Montserrat",
              fontSize: 16,
              fontWeight: FontWeight.w500),
          titleTextStyle: TextStyle(
              color: Colors.white,
              fontFamily: "Montserrat",
              fontSize: 22,
              fontWeight: FontWeight.w500),
          backgroundColor: Colors.blueGrey[900],
          contentPadding: EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10),
          title: Text(
            "EDITAR PRODUCTO",
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _textField(nameProduct, TextInputType.name),
              SizedBox(
                height: 10,
              ),
              _textField(prizeProduct, TextInputType.number),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: InkWell(
                  onTap: () {
                    print(nameProduct.text);
                    print(prizeProduct.text);
                    shopBloc.updateProduct(
                        idShop, idProduct, nameProduct.text, prizeProduct.text);
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 250,
                    height: 35,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        gradient: LinearGradient(
                            colors: [Colors.blue[900], Colors.blue[400]],
                            begin: FractionalOffset(0.2, 0.0),
                            end: FractionalOffset(1.0, 0.6),
                            stops: [0.0, 0.6],
                            tileMode: TileMode.clamp)),
                    child: Container(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        "ACTUALIZAR",
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
              ),
              Divider(
                height: 20,
                thickness: 2,
                color: Colors.blue[900],
              ),
              Text(
                product["available"]
                    ? "¿Está seguro que va a deshabilitar este producto?"
                    : "¿Está seguro que va a habilitar este producto?",
                textAlign: TextAlign.center,
              ),
              _disableProduct(context, product["available"], idShop, idProduct),
            ],
          ));
    },
  );
}

Widget _textField(
    TextEditingController editingController, TextInputType inputType) {
  return Container(
    height: 30,
    width: 250,
    child: TextField(
      keyboardType: inputType,
      textAlign: TextAlign.start,
      enableInteractiveSelection: false,
      textAlignVertical: TextAlignVertical.center,
      cursorColor: Colors.white,
      controller: editingController,
      style: TextStyle(
          color: Colors.white,
          fontFamily: "Montserrat",
          fontWeight: FontWeight.w400),
      decoration: InputDecoration(
        suffixIcon: Icon(
          Icons.edit,
          size: 20,
          color: Colors.white,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      onChanged: (value) {},
    ),
  );
}

Widget _disableProduct(
    BuildContext context, bool available, String idShop, String idProduct) {
  ShopBloc shopBloc = BlocProvider.of(context);
  return Padding(
    padding: const EdgeInsets.only(top: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        InkWell(
          onTap: () {
            if (available) {
              shopBloc.availableProduct(idShop, idProduct, false);
              Navigator.pop(context);
            } else {
              shopBloc.availableProduct(idShop, idProduct, true);
              Navigator.pop(context);
            }
          },
          child: Container(
            width: 120,
            height: 35,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                gradient: LinearGradient(
                    colors: [Colors.blue[900], Colors.blue[400]],
                    begin: FractionalOffset(0.2, 0.0),
                    end: FractionalOffset(1.0, 0.6),
                    stops: [0.0, 0.6],
                    tileMode: TileMode.clamp)),
            child: Container(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                available ? "DESHABILITAR" : "HABILITAR",
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
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            width: 120,
            height: 35,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                gradient: LinearGradient(
                    colors: [Colors.red[900], Colors.red[400]],
                    begin: FractionalOffset(0.2, 0.0),
                    end: FractionalOffset(1.0, 0.6),
                    stops: [0.0, 0.6],
                    tileMode: TileMode.clamp)),
            child: Container(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                "CANCELAR",
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
      ],
    ),
  );
}
