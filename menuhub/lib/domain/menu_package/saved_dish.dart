import 'package:menuhub/domain/menu_package/dish_tag.dart';

class SavedDish{
  final String id;
  final String hotelId;
  final String name;
  final String description;
  final List<DishTag> dishTags;

  SavedDish({
    required this.id,
    required this.hotelId,
    required this.name,
    required this.description,
    required this.dishTags
  });
}