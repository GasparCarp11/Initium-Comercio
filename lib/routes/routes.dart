import 'package:flutter/material.dart';
import 'package:initium_2_comercio/Shop/ui/screens/stock_screen.dart';
import 'package:initium_2_comercio/Shop/ui/screens/sign_in_screen.dart';

Map<String, WidgetBuilder> getNamedRoutes() {
  return <String, WidgetBuilder>{
    "/": (BuildContext context) => SignInScreen(),
    "stock": (BuildContext context) => StockScreen(),
  };
}