import '../../../domain/repository/abstract_menu_repository.dart';

class CloseMenuUC {
  final MenuRepository menuRepository;

  CloseMenuUC(this.menuRepository);

  Future<void> execute({
    required String hotelId,
    required String menuId,
  }) {
    return menuRepository.closeMenu(
      hotelId: hotelId,
      menuId: menuId,
    );
  }
}