import '../order_package/order.dart';
import '../order_package/order_status.dart';

class OrderBuilder {
  final String hotelId;
  final String id;
  final String clientId;
  final String menuId;

  final Map<String, List<String>> _selections = {};

  OrderBuilder({
    required this.hotelId,
    required this.id,
    required this.clientId,
    required this.menuId,
  });

  void addDish(String courseId, String dishId) {
    _selections.putIfAbsent(courseId, () => []);
    _selections[courseId]!.add(dishId);
  }

  Order build() {
    if (_selections.isEmpty) {
      throw Exception("Non puoi creare un ordine vuoto");
    }

    return Order(
      hotelId: hotelId,
      id: id,
      clientId: clientId,
      menuId: menuId,
      status: OrderStatus.confirmed,
      selections: Map.unmodifiable(_selections),
    );
  }
}