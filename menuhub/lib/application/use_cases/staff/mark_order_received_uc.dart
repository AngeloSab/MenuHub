import '../../../domain/order_package/order_status.dart';
import '../../../domain/repository/abstract_order_repository.dart';

class MarkOrderReceivedUC {
  final OrderRepository orderRepository;

  MarkOrderReceivedUC(this.orderRepository);

  Future<void> execute({
    required String hotelId,
    required String menuId,
    required String orderId,
  }) {
    return orderRepository.updateStatus(
      hotelId: hotelId,
      menuId: menuId,
      orderId: orderId,
      status: OrderStatus.received,
    );
  }
}