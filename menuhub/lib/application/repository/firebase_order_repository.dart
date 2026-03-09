import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/order_package/order.dart' as domain;
import '../../domain/order_package/order_status.dart';
import '../../domain/repository/abstract_order_repository.dart';
import '../../mappers/order_firestore_mapper.dart';

class FirebaseOrderRepository implements OrderRepository {
  final FirebaseFirestore firestore;

  FirebaseOrderRepository(this.firestore);

  @override
  Future<void> save(domain.Order order) async {
    await firestore
        .collection('hotels')
        .doc(order.hotelId)
        .collection('menus')
        .doc(order.menuId)
        .collection('orders')
        .doc(order.id)
        .set(OrderFirestoreMapper.toFirestore(order));
  }

  @override
  Future<List<domain.Order>> getByMenu(String hotelId, String menuId) async {
    final snapshot = await firestore
        .collection('hotels')
        .doc(hotelId)
        .collection('menus')
        .doc(menuId)
        .collection('orders')
        .get();

    return snapshot.docs
        .map(
          (doc) => OrderFirestoreMapper.fromFirestore(
        docId: doc.id,
        data: doc.data(),
      ),
    )
        .toList();
  }

  @override
  Stream<List<domain.Order>> watchByMenu(String hotelId, String menuId) {
    return firestore
        .collection('hotels')
        .doc(hotelId)
        .collection('menus')
        .doc(menuId)
        .collection('orders')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
            (doc) => OrderFirestoreMapper.fromFirestore(
          docId: doc.id,
          data: doc.data(),
        ),
      )
          .toList(),
    );
  }

  @override
  Future<domain.Order?> getById(String hotelId, String menuId, String orderId) async {
    final doc = await firestore
        .collection('hotels')
        .doc(hotelId)
        .collection('menus')
        .doc(menuId)
        .collection('orders')
        .doc(orderId)
        .get();

    if (!doc.exists || doc.data() == null) {
      return null;
    }

    return OrderFirestoreMapper.fromFirestore(
      docId: doc.id,
      data: doc.data()!,
    );
  }

  @override
  Future<void> updateStatus({
    required String hotelId,
    required String menuId,
    required String orderId,
    required OrderStatus status,
  }) async {
    await firestore
        .collection('hotels')
        .doc(hotelId)
        .collection('menus')
        .doc(menuId)
        .collection('orders')
        .doc(orderId)
        .update({
      'status': _statusToString(status),
    });
  }

  @override
  Future<List<domain.Order>> getByClientSession(
      String hotelId,
      String clientSessionId,
      ) async {
    final snapshot = await firestore
        .collectionGroup('orders')
        .where('hotelId', isEqualTo: hotelId)
        .where('clientSessionId', isEqualTo: clientSessionId)
        .get();

    return snapshot.docs
        .map(
          (doc) => OrderFirestoreMapper.fromFirestore(
        docId: doc.id,
        data: doc.data(),
      ),
    )
        .toList();
  }

  @override
  Future<domain.Order?> getByMenuAndClientSession(
      String hotelId,
      String menuId,
      String clientSessionId,
      ) async {
    final snapshot = await firestore
        .collection('hotels')
        .doc(hotelId)
        .collection('menus')
        .doc(menuId)
        .collection('orders')
        .where('clientSessionId', isEqualTo: clientSessionId)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    final doc = snapshot.docs.first;

    return OrderFirestoreMapper.fromFirestore(
      docId: doc.id,
      data: doc.data(),
    );
  }

  @override
  Stream<List<domain.Order>> watchByClientSession(
      String hotelId,
      String clientSessionId,
      ) {
    return firestore
        .collectionGroup('orders')
        .where('hotelId', isEqualTo: hotelId)
        .where('clientSessionId', isEqualTo: clientSessionId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
            (doc) => OrderFirestoreMapper.fromFirestore(
          docId: doc.id,
          data: doc.data(),
        ),
      )
          .toList(),
    );
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