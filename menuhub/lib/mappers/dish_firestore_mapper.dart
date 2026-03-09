import '../domain/menu_package/dish.dart';
import '../domain/menu_package/dish_tag.dart';

class DishFirestoreMapper {

  static Map<String, dynamic> toFirestore(Dish dish) {
    return {
      "id": dish.id,
      "name": dish.name,
      "description": dish.description,
      "dishTags": dish.dishTags.map((t) => t.name).toList(),
    };
  }

  static Dish fromFirestore(Map<String, dynamic> data) {
    return Dish(
      id: data["id"],
      name: data["name"],
      description: data["description"],
      dishTags: (data["dishTags"] as List)
          .map((e) => DishTag.values.firstWhere((t) => t.name == e))
          .toList(),
    );
  }
}