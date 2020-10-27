import 'package:cloud_firestore/cloud_firestore.dart';

class CloudFirestoreAPI {
  final String USERS = "users";
  final String ORDERS = "orders";
  final String SHOPS = "shops";

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<DocumentSnapshot> authShop(String docShop) async {
    DocumentSnapshot infoShop = await _db.collection(SHOPS).doc(docShop).get();
    return infoShop;
  }

  Stream<QuerySnapshot> showProducts(String shopUID) {
    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection("shops")
        .doc(shopUID)
        .collection("products");
    return collectionReference.snapshots();
  }
}
