import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/product.dart';

class ProductService {
  final CollectionReference products =
  FirebaseFirestore.instance.collection('products');

  Stream<List<Product>> watch() {
    return products
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Product.fromFirestore(doc))
          .toList();
    });
  }

  Future<void> add(Product product) async {
    await products.add({
      ...product.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // ===========================
  // CHANGE:
  // Added update product.
  // ===========================
  Future<void> update(Product product) async {
    await products.doc(product.id).update(product.toMap());
  }

  Future<void> updateStock(
      String id,
      int stock,
      ) async {
    await products.doc(id).update({
      'stock': stock,
    });
  }

  Future<void> delete(String id) async {
    await products.doc(id).delete();
  }
}