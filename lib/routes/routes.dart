import 'package:flutter/material.dart';
import 'package:initium_2_comercio/Shop/ui/screens/bluetooth_connection.dart';
import 'package:initium_2_comercio/Shop/ui/screens/initium_screen.dart';
import 'package:initium_2_comercio/Shop/ui/screens/stock_screen.dart';
import 'package:initium_2_comercio/Shop/ui/screens/sign_in_screen.dart';
import 'package:initium_2_comercio/Shop/ui/widgets/add_product.dart';

Map<String, WidgetBuilder> getNamedRoutes() {
  return <String, WidgetBuilder>{
    "/": (BuildContext context) => SignInScreen(),
    "stock": (BuildContext context) => StockScreen(),
    "initium": (BuildContext context) => InitiumScreen(),
    "add_product": (BuildContext context) => AddProductScreen(),
    "bluetooth": (BuildContext context) => BluetoothApp(),
  };
}
