import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:initium_2_comercio/Shop/model/product.dart';
import 'package:initium_2_comercio/Shop/services/cloud_firestore.dart';
import 'package:initium_2_comercio/Shop/services/firebase_storage.dart';

class ShopBloc implements Bloc {
  final cloudRepository = CloudFirestoreAPI();
  final storageRepository = FirebaseStorageAPI();

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

  Future<void> newProduct(bool available, String nameProduct, var prizeProduct,
          String photoURL) =>
      cloudRepository.newProduct(
          available, nameProduct, prizeProduct, photoURL);

  Future<StorageUploadTask> uploadPhoto(String path, File image) =>
      storageRepository.uploadPhoto(path, image);

  @override
  void dispose() {}
}
