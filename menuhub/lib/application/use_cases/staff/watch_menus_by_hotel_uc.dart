import '../../../domain/menu_package/menu.dart';
import '../../../domain/repository/abstract_menu_repository.dart';

class WatchMenusByHotelUC {
  final MenuRepository menuRepository;

  WatchMenusByHotelUC(this.menuRepository);

  Stream<List<Menu>> execute(String hotelId) {
    return menuRepository.watchByHotel(hotelId);
  }
}