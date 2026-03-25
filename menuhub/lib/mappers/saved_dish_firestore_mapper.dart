import '../domain/menu_package/dish_tag.dart';
import '../domain/menu_package/saved_dish.dart';

class DishFirestoreMapper {
  static Map<String, dynamic> toFirestore(SavedDish savedDish) {
    return {
      'id': savedDish.id,
      'hotelId': savedDish.hotelId,
      'name': savedDish.name,
      'description': savedDish.description,
      'dishTags': savedDish.dishTags.map((t) => t.name).toList(),
    };
  }

  static SavedDish fromFirestore(Map<String, dynamic> data) {
    return SavedDish(
      id: data['id'] as String,
      hotelId: data['hotelId'] as String,
      name: data['name'] as String,
      description: data['description'] as String? ?? '',
      dishTags: (data['dishTags'] as List<dynamic>? ?? [])
          .map(
            (e) => DishTag.values.firstWhere(
              (t) => t.name == e as String,
        ),
      )
          .toList(),
    );
  }
}