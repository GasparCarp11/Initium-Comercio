import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:initium_2_comercio/Shop/services/cloud_firestore.dart';

class ShopBloc implements Bloc {
  final cloudRepository = CloudFirestoreAPI();

  Future<DocumentSnapshot> authShop(String idShop) =>
      cloudRepository.authShop(idShop);

  Stream<QuerySnapshot> showProducts(String idShop) =>
      cloudRepository.showProducts(idShop);

  Future<void> availableProduct(
          String shopUID, String productID, bool available) =>
      cloudRepository.availableProduct(shopUID, productID, available);

  Future<void> updateProduct(
          String shopUID, String productID, String nameProduct, String prize) =>
      cloudRepository.updateProduct(shopUID, productID, nameProduct, prize);

  Stream<QuerySnapshot> showOrders(String idShop) =>
      cloudRepository.showOrders(idShop);

  @override
  void dispose() {}
}
