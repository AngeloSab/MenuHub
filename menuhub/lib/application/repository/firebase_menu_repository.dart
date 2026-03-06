import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/menu_package/menu.dart';
import '../../domain/repository/abstract_menu_repository.dart';
import '../../mappers/menu_firestore_mapper.dart';

class FirebaseMenuRepository implements MenuRepository {
  final FirebaseFirestore firestore;

  FirebaseMenuRepository(this.firestore);

  CollectionReference<Map<String, dynamic>> _menusRef(String hotelId) {
    return firestore.collection('hotels').doc(hotelId).collection('menus');
  }

  @override
  Future<void> save(Menu menu) async {
    try {
      await _menusRef(menu.hotelId)
          .doc(menu.id)
          .set(MenuFirestoreMapper.toFirestore(menu));
    } on FirebaseException catch (e) {
      throw Exception(
        'Errore Firestore in save(menuId=${menu.id}): ${e.message}',
      );
    }
  }

  @override
  Future<Menu?> getById({
    required String hotelId,
    required String menuId,
  }) async {
    try {
      final doc = await _menusRef(hotelId).doc(menuId).get();
      final data = doc.data();
      if (data == null) return null;

      return MenuFirestoreMapper.fromFirestore(
        docId: doc.id,
        data: data,
      );
    } on FirebaseException catch (e) {
      throw Exception(
        'Errore Firestore in getById(hotelId=$hotelId, menuId=$menuId): ${e.message}',
      );
    }
  }

  @override
  Future<List<Menu>> getByHotel(String hotelId) async {
    try {
      final snapshot = await _menusRef(hotelId).get();

      return snapshot.docs
          .map(
            (doc) => MenuFirestoreMapper.fromFirestore(
          docId: doc.id,
          data: doc.data(),
        ),
      )
          .toList();
    } on FirebaseException catch (e) {
      throw Exception(
        'Errore Firestore in getByHotel(hotelId=$hotelId): ${e.message}',
      );
    }
  }

  @override
  Stream<List<Menu>> watchByHotel(String hotelId) {
    return _menusRef(hotelId).snapshots().map((snapshot) {
      return snapshot.docs
          .map(
            (doc) => MenuFirestoreMapper.fromFirestore(
          docId: doc.id,
          data: doc.data(),
        ),
      )
          .toList();
    });
  }

  @override
  Future<List<Menu>> getOpenMenus(String hotelId) async {
    try {
      final snapshot =
      await _menusRef(hotelId).where('isOpen', isEqualTo: true).get();

      return snapshot.docs
          .map(
            (doc) => MenuFirestoreMapper.fromFirestore(
          docId: doc.id,
          data: doc.data(),
        ),
      )
          .toList();
    } on FirebaseException catch (e) {
      throw Exception(
        'Errore Firestore in getOpenMenus(hotelId=$hotelId): ${e.message}',
      );
    }
  }

  @override
  Stream<List<Menu>> watchOpenMenus(String hotelId) {
    return _menusRef(hotelId)
        .where('isOpen', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map(
            (doc) => MenuFirestoreMapper.fromFirestore(
          docId: doc.id,
          data: doc.data(),
        ),
      )
          .toList();
    });
  }

  @override
  Future<void> openMenu({
    required String hotelId,
    required String menuId,
  }) async {
    try {
      await _menusRef(hotelId).doc(menuId).update({
        'isOpen': true,
      });
    } on FirebaseException catch (e) {
      throw Exception(
        'Errore Firestore in openMenu(hotelId=$hotelId, menuId=$menuId): ${e.message}',
      );
    }
  }

  @override
  Future<void> closeMenu({
    required String hotelId,
    required String menuId,
  }) async {
    try {
      await _menusRef(hotelId).doc(menuId).update({
        'isOpen': false,
      });
    } on FirebaseException catch (e) {
      throw Exception(
        'Errore Firestore in closeMenu(hotelId=$hotelId, menuId=$menuId): ${e.message}',
      );
    }
  }
}