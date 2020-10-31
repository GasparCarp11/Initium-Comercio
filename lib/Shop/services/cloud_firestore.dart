import 'package:cloud_firestore/cloud_firestore.dart';

Map<String, dynamic> infoshop;

class CloudFirestoreAPI {
  final String USERS = "users";
  final String ORDERS = "orders";
  final String SHOPS = "shops";

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<DocumentSnapshot> authShop(String docShop) async {
    DocumentSnapshot infoShop = await _db.collection(SHOPS).doc(docShop).get();
    print(infoshop);
    return infoShop;
  }

  Stream<QuerySnapshot> showProducts(String shopUID) {
    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection("shops")
        .doc(shopUID)
        .collection("products");
    return collectionReference.snapshots();
  }

  Future<void> availableProduct(
      String shopUID, String productID, bool available) async {
    DocumentReference collectionReference = FirebaseFirestore.instance
        .collection("shops")
        .doc(shopUID)
        .collection("products")
        .doc(productID);

    return collectionReference
        .update({'available': available})
        .then((value) => print("Actualizado"))
        .catchError((onError) => print("Error:$onError"));
  }

  Future<void> updateProduct(String shopUID, String productID,
      String nameProduct, String prize) async {
    DocumentReference collectionReference = FirebaseFirestore.instance
        .collection("shops")
        .doc(shopUID)
        .collection("products")
        .doc(productID);

    var realPrize = int.parse(prize);

    return collectionReference
        .update({'name': nameProduct, 'prize': realPrize})
        .then((value) => print("Actualizado"))
        .catchError((onError) => print("Error:$onError"));
  }

  Stream<QuerySnapshot> showOrders(String idShop) {
    Stream<QuerySnapshot> refOrders = _db
        .collection(ORDERS)
        .where("uidshop", isEqualTo: "$idShop")
        .snapshots();
    return refOrders;
  }
}
