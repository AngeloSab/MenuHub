import '../../../domain/menu_package/menu.dart';
import '../../../domain/repository/abstract_menu_repository.dart';

class GetMenusByHotelUC {
  final MenuRepository menuRepository;

  GetMenusByHotelUC(this.menuRepository);

  Future<List<Menu>> execute(String hotelId) {
    return menuRepository.getByHotel(hotelId);
  }
}