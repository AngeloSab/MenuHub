import '../../../domain/repository/abstract_order_repository.dart';

class GetMenuOrdersCountUC {
  final OrderRepository orderRepository;

  GetMenuOrdersCountUC(this.orderRepository);

  Future<int> execute({
    required String hotelId,
    required String menuId,
  }) {
    return orderRepository.countByMenu(
      hotelId: hotelId,
      menuId: menuId,
    );
  }
}