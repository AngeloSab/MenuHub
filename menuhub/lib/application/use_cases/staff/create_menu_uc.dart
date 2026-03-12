import '../../../domain/menu_package/menu.dart';
import '../../../domain/repository/abstract_menu_repository.dart';

class CreateMenuUC {
  final MenuRepository menuRepository;

  CreateMenuUC(this.menuRepository);

  Future<void> execute(Menu menu) {
    return menuRepository.save(menu);
  }
}