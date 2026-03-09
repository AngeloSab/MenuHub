import '../domain/menu_package/course.dart';
import 'dish_firestore_mapper.dart';

class CourseFirestoreMapper {
  static Map<String, dynamic> toFirestore(Course course) {
    return {
      'id': course.id,
      'type': course.type,
      'dishes': course.dishes.map(DishFirestoreMapper.toFirestore).toList(),
    };
  }

  static Course fromFirestore(Map<String, dynamic> data) {
    return Course(
      id: data['id'] as String,
      type: data['type'] as String,
      dishes: (data['dishes'] as List)
          .map((e) => DishFirestoreMapper.fromFirestore(
        Map<String, dynamic>.from(e),
      ))
          .toList(),
    );
  }
}