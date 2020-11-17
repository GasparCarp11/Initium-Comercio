import 'package:flutter/material.dart';
import 'package:linear_gradient/linear_gradient.dart';

class OrderView extends StatelessWidget {
  const OrderView({
    Key key,
    @required this.orders,
    @required this.onPress,
  }) : super(key: key);

  final Map<String, dynamic> orders;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        margin: EdgeInsets.all(10.0),
        padding: EdgeInsets.only(left: 8.0),
        width: MediaQuery.of(context).size.width,
        height: 80,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            gradient: LinearGradientStyle.linearGradient(
              orientation: LinearGradientStyle.ORIENTATION_HORIZONTAL,
              gradientType: LinearGradientStyle.GRADIENT_TYPE_MIDNIGHT_CITY,
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
              padding: const EdgeInsets.only(left: 10, right: 10),
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
  }
}
