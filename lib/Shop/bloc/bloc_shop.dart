import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:initium_2_comercio/Shop/services/cloud_firestore.dart';

class ShopBloc implements Bloc {
  final cloudRepository = CloudFirestoreAPI();

  Future<DocumentSnapshot> authShop(String idShop) =>
      cloudRepository.authShop(idShop);

  Stream<QuerySnapshot> showProducts(String idShop) =>
      cloudRepository.showProducts(idShop);

  @override
  void dispose() {}
}
