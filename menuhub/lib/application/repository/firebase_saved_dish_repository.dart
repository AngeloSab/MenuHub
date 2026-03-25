import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/menu_package/saved_dish.dart';
import '../../domain/repository/abstract_saved_dish_repository.dart';
import '../../mappers/saved_dish_firestore_mapper.dart';

class FirebaseSavedDishRepository implements SavedDishRepository {
  final FirebaseFirestore firestore;

  FirebaseSavedDishRepository(this.firestore);

  CollectionReference<Map<String, dynamic>> _collection(String hotelId) {
    return firestore
        .collection('hotels')
        .doc(hotelId)
        .collection('saved_dishes');
  }

  @override
  Future<void> save(SavedDish dish) async {
    await _collection(dish.hotelId)
        .doc(dish.id)
        .set(DishFirestoreMapper.toFirestore(dish));
  }

  @override
  Future<List<SavedDish>> getByHotel(String hotelId) async {
    final snapshot = await _collection(hotelId).get();

    return snapshot.docs
        .map((doc) => DishFirestoreMapper.fromFirestore(doc.data()))
        .toList();
  }

  @override
  Stream<List<SavedDish>> watchByHotel(String hotelId) {
    return _collection(hotelId).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => DishFirestoreMapper.fromFirestore(doc.data()))
          .toList();
    });
  }

  @override
  Future<void> delete({
    required String hotelId,
    required String dishId,
  }) async {
    await _collection(hotelId).doc(dishId).delete();
  }
}