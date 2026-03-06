import '../../domain/menu_package/dish.dart';

class DishFirestoreMapper {
  static Map<String, dynamic> toMap(Dish dish) => {
    'id': dish.id,
    'name': dish.name,
    'description': dish.description,
  };

  static Dish fromMap(Map<String, dynamic> json) => Dish(
    id: json['id'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
  );
}