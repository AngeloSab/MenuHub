import '../order_package/order.dart';
import '../order_package/order_selection.dart';
import '../order_package/order_status.dart';

class OrderBuilder {
  final String hotelId;
  final String id;
  final String clientSessionId;
  final String reservationName;
  final String roomNumber;
  final String menuId;
  final List<OrderSelection> _selections = [];

  OrderBuilder({
    required this.hotelId,
    required this.id,
    required this.clientSessionId,
    required this.reservationName,
    required this.roomNumber,
    required this.menuId,
  });

  void addDish(OrderSelection item) {
    _selections.add(item);
  }

  Order build() {
    if (_selections.isEmpty) {
      throw Exception("Non puoi creare un ordine vuoto");
    }

    return Order(
      hotelId: hotelId,
      id: id,
      clientSessionId: clientSessionId,
      reservationName: reservationName,
      roomNumber: roomNumber,
      menuId: menuId,
      status: OrderStatus.confirmed,
      selections: List.unmodifiable(_selections),
    );
  }
}