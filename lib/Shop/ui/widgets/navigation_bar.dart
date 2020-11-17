import 'package:flutter/material.dart';

class NavigationBar extends StatefulWidget {
  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  int _currentIndex;
  final List<String> _list = ["initium", "stock", "wifi_connection"];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.blueGrey[900],
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.all_inclusive,
            color: Colors.white,
          ),
          title: Text("Initium",
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w400)),
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.store,
            color: Colors.white,
          ),
          title: Text(
            "Stock",
            style: TextStyle(
                color: Colors.white,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w400),
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.settings_remote,
            color: Colors.white,
          ),
          title: Text("Centrales",
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w400)),
        )
      ],
      onTap: (index) {
        setState(() {
          _currentIndex = index;
          Navigator.pushNamed(context, _list[_currentIndex]);
        });
      },
    );
    ;
  }
}
