import '../domain/order_package/order.dart' as domain;
import '../domain/order_package/order_status.dart';

class OrderFirestoreMapper {
  static Map<String, dynamic> toFirestore(domain.Order order) => {
    'hotelId': order.hotelId,
    'clientId': order.clientId,
    'menuId': order.menuId,
    'status': _statusToString(order.status),
    'selections': order.selections,
  };

  static domain.Order fromFirestore({
    required String docId,
    required Map<String, dynamic> data,
  }) {
    final rawSelections = Map<String, dynamic>.from(
      (data['selections'] ?? const <String, dynamic>{}) as Map,
    );

    final selections = rawSelections.map(
          (courseId, dishListDynamic) => MapEntry(
        courseId,
        List<String>.from(dishListDynamic as List),
      ),
    );

    return domain.Order(
      id: (data['id'] as String?) ?? docId,
      hotelId: data['hotelId'] as String,
      clientId: data['clientId'] as String,
      menuId: data['menuId'] as String,
      status: _statusFromString(data['status'] as String),
      selections: selections,
    );
  }

  static String _statusToString(OrderStatus status) {
    switch (status) {
      case OrderStatus.confirmed:
        return 'confirmed';
      case OrderStatus.received:
        return 'received';
    }
  }

  static OrderStatus _statusFromString(String value) {
    switch (value) {
      case 'confirmed':
        return OrderStatus.confirmed;
      case 'received':
        return OrderStatus.received;
      default:
        throw Exception('OrderStatus non valido: $value');
    }
  }
}