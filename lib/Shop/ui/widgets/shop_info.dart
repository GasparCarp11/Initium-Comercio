import 'package:flutter/material.dart';
import 'package:initium_2_comercio/Shop/ui/screens/sign_in_screen.dart';

class InfoShop extends StatelessWidget {
  InfoShop({
    Key key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 10),
          child: Container(
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.blue[900],
                      width: 3.5,
                      style: BorderStyle.solid),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(shopInfo["photoURL"]),
                  ))),
        ),
        Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 40, top: 20),
              child: Text(
                shopInfo["name"],
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: Text(
                shopInfo["address"],
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40, top: 10),
              child: InkWell(
                  onTap: () {},
                  child: Container(
                    width: 180,
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Agregar producto",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16.0,
                                fontFamily: "Montserrat",
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                          Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  )),
            )
          ],
        ),
      ],
    );
  }
}
