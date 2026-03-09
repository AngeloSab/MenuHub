import 'order_selection.dart';
import 'order_status.dart';

class Order {
  final String id;
  final String hotelId;
  final String clientSessionId;
  final String reservationName;
  final String menuId;
  final String roomNumber;
  final OrderStatus status;
  final List<OrderSelection> selections;

  Order({
    required this.id,
    required this.hotelId,
    required this.clientSessionId,
    required this.reservationName,
    required this.menuId,
    required this.roomNumber,
    required this.status,
    required this.selections,
  }) : assert(selections.isNotEmpty, "Un ordine deve contenere almeno una selezione");
}