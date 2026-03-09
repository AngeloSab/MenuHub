import '../domain/order_package/order.dart' as domain;
import '../domain/order_package/order_selection.dart';
import '../domain/order_package/order_status.dart';

class OrderFirestoreMapper {
  static Map<String, dynamic> toFirestore(domain.Order order) => {
    'hotelId': order.hotelId,
    'clientSessionId': order.clientSessionId,
    'reservationName': order.reservationName,
    'roomNumber': order.roomNumber,
    'menuId': order.menuId,
    'status': _statusToString(order.status),
    'selections': order.selections
        .map(
          (selection) => {
        'courseId': selection.courseId,
        'dishId': selection.dishId,
        'variations': selection.variations,
        'quantity': selection.quantity,
      },
    )
        .toList(),
  };

  static domain.Order fromFirestore({
    required String docId,
    required Map<String, dynamic> data,
  }) {
    final rawSelections = List<Map<String, dynamic>>.from(
      (data['selections'] as List<dynamic>? ?? const [])
          .map((item) => Map<String, dynamic>.from(item as Map)),
    );

    final selections = rawSelections
        .map(
          (item) => OrderSelection(
        courseId: item['courseId'] as String,
        dishId: item['dishId'] as String,
        variations: item['variations'] as String?,
        quantity: item['quantity'] as int,
      ),
    )
        .toList();

    return domain.Order(
      id: (data['id'] as String?) ?? docId,
      hotelId: data['hotelId'] as String,
      clientSessionId: data['clientSessionId'] as String,
      reservationName: data['reservationName'] as String,
      roomNumber: data['roomNumber'] as String,
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