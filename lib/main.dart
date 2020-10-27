import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:initium_2_comercio/Shop/bloc/bloc_shop.dart';
import 'package:initium_2_comercio/routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Error();
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MyApp();
        }
        return Loading();
      },
    );
  }
}

class Error extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: ShopBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Initium Comercio',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Scaffold(
          body: Text("Error al conectar con FireBase"),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      child: MaterialApp(
        title: 'Initium Comercio',
        debugShowCheckedModeBanner: false,
        initialRoute: "/",
        routes: getNamedRoutes(),
      ),
      bloc: ShopBloc(),
    );
  }
}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: ShopBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Initium Comercio',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Scaffold(
          body: Text("Cargando con FireBase"),
        ),
      ),
    );
  }
}
