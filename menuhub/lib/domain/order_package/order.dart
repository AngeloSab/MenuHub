import 'package:menuhub/domain/order_package/order_status.dart';

class Order {
  final String hotelId;
  final String id;
  final String clientId;
  final String menuId;
  final OrderStatus status;
  final Map<String, List<String>> selections;

  const Order({
    required this.hotelId,
    required this.id,
    required this.clientId,
    required this.menuId,
    required this.status,
    required this.selections,
  });
}