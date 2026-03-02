import 'course_type.dart';
import 'dish.dart';

class Course{
  final List<Dish> dishes;
  final CourseType courseType;

  Course(this.courseType, List<Dish> dishes) : dishes = List.unmodifiable(dishes) {
    _validate();
  }

  void _validate() {
    if (dishes.isEmpty) {
      throw Exception("La portata $courseType deve avere almeno un piatto");
    }

    final names = <String>{};

    for (final dish in dishes) {
      if (!names.add(dish.name)) {
        throw Exception("Piatto ${dish.name} duplicato nella portata $courseType");
      }
    }
  }

}