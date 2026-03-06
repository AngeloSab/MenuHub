import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/order_package/order.dart' as domain;
import '../../domain/order_package/order_status.dart';
import '../../domain/repository/abstract_order_repository.dart';
import '../../mappers/order_firestore_mapper.dart';

class FirebaseOrderRepository implements OrderRepository {
  final FirebaseFirestore firestore;

  FirebaseOrderRepository(this.firestore);

  CollectionReference<Map<String, dynamic>> _ordersRef({
    required String hotelId,
    required String menuId,
  }) {
    return firestore
        .collection('hotels')
        .doc(hotelId)
        .collection('menus')
        .doc(menuId)
        .collection('orders');
  }

  Query<Map<String, dynamic>> _ordersGroupRef() {
    return firestore.collectionGroup('orders');
  }

  @override
  Future<void> save(domain.Order order) async {
    try {
      await _ordersRef(
        hotelId: order.hotelId,
        menuId: order.menuId,
      ).doc(order.id).set(
        OrderFirestoreMapper.toFirestore(order),
      );
    } on FirebaseException catch (e) {
      throw Exception(
        'Errore Firestore in save(orderId=${order.id}): ${e.message}',
      );
    }
  }

  @override
  Future<List<domain.Order>> getByMenu({
    required String hotelId,
    required String menuId,
  }) async {
    try {
      final snapshot = await _ordersRef(
        hotelId: hotelId,
        menuId: menuId,
      ).get();

      return snapshot.docs
          .map(
            (doc) => OrderFirestoreMapper.fromFirestore(
          docId: doc.id,
          data: doc.data(),
        ),
      )
          .toList();
    } on FirebaseException catch (e) {
      throw Exception(
        'Errore Firestore in getByMenu(hotelId=$hotelId, menuId=$menuId): ${e.message}',
      );
    }
  }

  @override
  Stream<List<domain.Order>> watchByMenu({
    required String hotelId,
    required String menuId,
  }) {
    return _ordersRef(
      hotelId: hotelId,
      menuId: menuId,
    ).snapshots().map((snapshot) {
      return snapshot.docs
          .map(
            (doc) => OrderFirestoreMapper.fromFirestore(
          docId: doc.id,
          data: doc.data(),
        ),
      )
          .toList();
    });
  }

  @override
  Future<domain.Order?> getById({
    required String hotelId,
    required String menuId,
    required String orderId,
  }) async {
    try {
      final doc = await _ordersRef(
        hotelId: hotelId,
        menuId: menuId,
      ).doc(orderId).get();

      final data = doc.data();
      if (data == null) return null;

      return OrderFirestoreMapper.fromFirestore(
        docId: doc.id,
        data: data,
      );
    } on FirebaseException catch (e) {
      throw Exception(
        'Errore Firestore in getById(hotelId=$hotelId, menuId=$menuId, orderId=$orderId): ${e.message}',
      );
    }
  }

  @override
  Future<void> updateStatus({
    required String hotelId,
    required String menuId,
    required String orderId,
    required OrderStatus status,
  }) async {
    try {
      await _ordersRef(
        hotelId: hotelId,
        menuId: menuId,
      ).doc(orderId).update({
        'status': _statusToString(status),
      });
    } on FirebaseException catch (e) {
      throw Exception(
        'Errore Firestore in updateStatus(hotelId=$hotelId, menuId=$menuId, orderId=$orderId): ${e.message}',
      );
    }
  }

  Future<List<domain.Order>> getByClient({
    required String hotelId,
    required String clientId,
  }) async {
    try {
      final snapshot = await _ordersGroupRef()
          .where('hotelId', isEqualTo: hotelId)
          .where('clientId', isEqualTo: clientId)
          .get();

      return snapshot.docs
          .map(
            (doc) => OrderFirestoreMapper.fromFirestore(
          docId: doc.id,
          data: doc.data(),
        ),
      )
          .toList();
    } on FirebaseException catch (e) {
      throw Exception(
        'Errore Firestore in getByClient(hotelId=$hotelId, clientId=$clientId): ${e.message}',
      );
    }
  }

  Stream<List<domain.Order>> watchByClient({
    required String hotelId,
    required String clientId,
  }) {
    return _ordersGroupRef()
        .where('hotelId', isEqualTo: hotelId)
        .where('clientId', isEqualTo: clientId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map(
            (doc) => OrderFirestoreMapper.fromFirestore(
          docId: doc.id,
          data: doc.data(),
        ),
      )
          .toList();
    });
  }

  String _statusToString(OrderStatus status) {
    switch (status) {
      case OrderStatus.confirmed:
        return 'confirmed';
      case OrderStatus.received:
        return 'received';
    }
  }
}