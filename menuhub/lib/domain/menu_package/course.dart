import 'package:menuhub/domain/menu_package/course_type.dart';

import 'dish.dart';

class Course {
  final String id;
  final CourseType type;
  final List<Dish> dishes;

  const Course({
    required this.id,
    required this.type,
    required this.dishes,
  }) : assert(dishes.length > 0, "Un corso deve avere almeno un piatto");

}