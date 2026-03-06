import '../order_package/order.dart';
import '../order_package/order_status.dart';

abstract class OrderRepository {
  Future<void> save(Order order);

  Future<List<Order>> getByMenu({
    required String hotelId,
    required String menuId,
  });

  Stream<List<Order>> watchByMenu({
    required String hotelId,
    required String menuId,
  });

  Future<void> updateStatus({
    required String hotelId,
    required String menuId,
    required String orderId,
    required OrderStatus status,
  });

  Future<Order?> getById({
    required String hotelId,
    required String menuId,
    required String orderId,
  });
}