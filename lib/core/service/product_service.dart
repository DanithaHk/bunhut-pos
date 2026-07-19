import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/product.dart';

class ProductService {
  final CollectionReference products =
  FirebaseFirestore.instance.collection('products');

  /// ===========================
  /// STREAM PRODUCTS
  /// ===========================
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

  /// ===========================
  /// ADD PRODUCT
  /// ===========================
  Future<void> add(Product product) async {
    await products.add({
      ...product.toMap(),

      /// ensure createdAt always exists
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// ===========================
  /// UPDATE FULL PRODUCT
  /// ===========================
  Future<void> update(Product product) async {

    await products.doc(product.id).update({

      'name': product.name,

      'price': product.price,

      'stock': product.stock,

      'category': product.category,

      'tone': product.tone
          .toARGB32()
          .toRadixString(16)
          .substring(2)
          .toUpperCase(),

      'trackStock': product.trackStock,

      'updatedAt': FieldValue.serverTimestamp(),

    });

  }

  /// ===========================
  /// UPDATE STOCK ONLY
  /// ===========================
  Future<void> updateStock(String id, int stock) async {
    await products.doc(id).update({
      'stock': stock,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// ===========================
  /// DELETE PRODUCT
  /// ===========================
  Future<void> delete(String id) async {
    await products.doc(id).delete();
  }
}