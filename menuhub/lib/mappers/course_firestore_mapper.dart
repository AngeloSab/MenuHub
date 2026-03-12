import '../domain/menu_package/course.dart';
import '../domain/menu_package/course_type.dart';
import 'dish_firestore_mapper.dart';

class CourseFirestoreMapper {
  static Map<String, dynamic> toFirestore(Course course) {
    return {
      'id': course.id,
      'type': course.type.name,
      'dishes': course.dishes.map(DishFirestoreMapper.toFirestore).toList(),
    };
  }

  static Course fromFirestore(Map<String, dynamic> data) {
    final courseTypeString = data['type'] as String;

    return Course(
      id: data['id'] as String,
      type: CourseType.values.firstWhere(
            (value) => value.name == courseTypeString,
      ),
      dishes: (data['dishes'] as List)
          .map(
            (e) => DishFirestoreMapper.fromFirestore(
          Map<String, dynamic>.from(e),
        ),
      )
          .toList(),
    );
  }
}