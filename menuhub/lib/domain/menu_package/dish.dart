import 'dish_tag.dart';

class Dish {
  final String id;
  final String name;
  final String description;
  final List<DishTag> dishTags;

  const Dish({
    required this.id,
    required this.name,
    required this.description,
    required this.dishTags
  });
}
