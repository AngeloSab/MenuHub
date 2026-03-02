import '../order_package/order.dart';

class Client {
  final int clientId;
  final String reservationName;
  final int peopleCount;
  final int roomNumber;

  final List<Order> _orders = [];

  Client(this.clientId, this.reservationName, this.peopleCount, this.roomNumber);

  List<Order> get orders => List.unmodifiable(_orders);

}