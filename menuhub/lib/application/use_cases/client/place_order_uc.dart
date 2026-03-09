import '../../../domain/order_package/order.dart';
import '../../../domain/order_package/order_selection.dart';
import '../../../domain/order_package/order_status.dart';
import '../../../domain/repository/abstract_order_repository.dart';

class PlaceOrderUC {
  final OrderRepository orderRepository;

  PlaceOrderUC(this.orderRepository);

  Future<Order> execute({
    required String id,
    required String hotelId,
    required String clientSessionId,
    required String reservationName,
    required String roomNumber,
    required String menuId,
    required List<OrderSelection> selections,
  }) async {
    if (selections.isEmpty) {
      throw Exception("Non puoi inviare un ordine vuoto.");
    }

    for (final selection in selections) {
      if (selection.quantity <= 0) {
        throw Exception(
          "La quantità del piatto ${selection.dishId} deve essere maggiore di 0.",
        );
      }
    }

    final existingOrder = await orderRepository.getByMenuAndClientSession(
      hotelId,
      menuId,
      clientSessionId,
    );

    final order = Order(
      id: existingOrder?.id ?? id,
      hotelId: hotelId,
      clientSessionId: clientSessionId,
      reservationName: reservationName,
      roomNumber: roomNumber,
      menuId: menuId,
      status: OrderStatus.confirmed,
      selections: selections,
    );

    await orderRepository.save(order);

    return order;
  }
}