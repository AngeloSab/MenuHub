import '../../domain/menu_package/course.dart';
import 'dish_firestore_mapper.dart';

class CourseFirestoreMapper {
  static Map<String, dynamic> toMap(Course course) => {
    'id': course.id,
    'type': course.type,
    'dishes': course.dishes.map(DishFirestoreMapper.toMap).toList(),
  };

  static Course fromMap(Map<String, dynamic> json) => Course(
    id: json['id'] as String,
    type: json['type'] as String,
    dishes: (json['dishes'] as List)
        .map((e) => DishFirestoreMapper.fromMap(
      Map<String, dynamic>.from(e),
    ))
        .toList(),
  );
}