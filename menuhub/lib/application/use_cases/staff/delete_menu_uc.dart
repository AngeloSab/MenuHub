import '../../../domain/repository/abstract_menu_repository.dart';

class DeleteMenuUC {
  final MenuRepository menuRepository;

  DeleteMenuUC(this.menuRepository);

  Future<void> execute({
    required String hotelId,
    required String menuId,
  }) {
    return menuRepository.delete(
      hotelId: hotelId,
      menuId: menuId,
    );
  }
}