import '../../../domain/repository/abstract_menu_repository.dart';

class ArchiveMenuUC {
  final MenuRepository menuRepository;

  ArchiveMenuUC(this.menuRepository);

  Future<void> execute({
    required String hotelId,
    required String menuId,
  }) {
    return menuRepository.archive(
      hotelId: hotelId,
      menuId: menuId,
    );
  }
}