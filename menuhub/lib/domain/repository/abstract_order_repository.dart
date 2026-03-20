import '../order_package/order.dart';
import '../order_package/order_status.dart';

abstract class OrderRepository {
  Future<void> save(Order order);

  Future<List<Order>> getByMenu(String hotelId, String menuId);

  Stream<List<Order>> watchByMenu(String hotelId, String menuId);

  Future<Order?> getById(String hotelId, String menuId, String orderId);

  Future<void> updateStatus({
    required String hotelId,
    required String menuId,
    required String orderId,
    required OrderStatus status,
  });

  Future<Order?> getByMenuAndClientSession(
      String hotelId,
      String menuId,
      String clientSessionId,
      );

  Future<int> countByMenu({
    required String hotelId,
    required String menuId,
  });

  Future<List<Order>> getByClientSession(String hotelId, String clientSessionId);

  Stream<List<Order>> watchByClientSession(
      String hotelId,
      String clientSessionId,
      );
}