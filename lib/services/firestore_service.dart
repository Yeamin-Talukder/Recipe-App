import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get a collection of documents mapped to a custom model
  Future<List<T>> getCollection<T>({
    required String collectionPath,
    required T Function(String id, Map<String, dynamic> data) builder,
    Query Function(Query query)? queryBuilder,
  }) async {
    Query query = _db.collection(collectionPath);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => builder(doc.id, doc.data() as Map<String, dynamic>))
        .toList();
  }

  // Get a single document
  Future<T?> getDocument<T>({
    required String collectionPath,
    required String documentId,
    required T Function(String id, Map<String, dynamic> data) builder,
  }) async {
    final doc = await _db.collection(collectionPath).doc(documentId).get();
    if (!doc.exists || doc.data() == null) return null;
    return builder(doc.id, doc.data()!);
  }

  // Set or update a document
  Future<void> setDocument({
    required String collectionPath,
    required String documentId,
    required Map<String, dynamic> data,
    bool merge = true,
  }) async {
    await _db
        .collection(collectionPath)
        .doc(documentId)
        .set(data, SetOptions(merge: merge));
  }

  // Delete a document
  Future<void> deleteDocument({
    required String collectionPath,
    required String documentId,
  }) async {
    await _db.collection(collectionPath).doc(documentId).delete();
  }

  // Write batch data (e.g., seeding)
  Future<void> batchSet({
    required String collectionPath,
    required List<Map<String, dynamic>> items,
    required String Function(Map<String, dynamic> item) idGenerator,
  }) async {
    final batch = _db.batch();
    for (var item in items) {
      final docRef = _db.collection(collectionPath).doc(idGenerator(item));
      batch.set(docRef, item, SetOptions(merge: true));
    }
    await batch.commit();
  }

  // Subcollection methods
  Future<List<T>> getSubcollection<T>({
    required String parentCollection,
    required String parentId,
    required String subcollection,
    required T Function(String id, Map<String, dynamic> data) builder,
  }) async {
    final snapshot = await _db
        .collection(parentCollection)
        .doc(parentId)
        .collection(subcollection)
        .get();

    return snapshot.docs
        .map((doc) => builder(doc.id, doc.data()))
        .toList();
  }

  Future<void> setSubcollectionDocument({
    required String parentCollection,
    required String parentId,
    required String subcollection,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    await _db
        .collection(parentCollection)
        .doc(parentId)
        .collection(subcollection)
        .doc(documentId)
        .set(data, SetOptions(merge: true));
  }

  Future<void> deleteSubcollectionDocument({
    required String parentCollection,
    required String parentId,
    required String subcollection,
    required String documentId,
  }) async {
    await _db
        .collection(parentCollection)
        .doc(parentId)
        .collection(subcollection)
        .doc(documentId)
        .delete();
  }
}
