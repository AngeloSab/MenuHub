import 'package:menuhub/domain/menu_package/meal_type.dart';

import 'course.dart';

class Menu {
  final String id;
  final String hotelId;
  final DateTime date;
  final MealType mealType;
  final DateTime deadline;
  final bool isOpen;
  final List<Course> courses;

  Menu({
    required this.id,
    required this.hotelId,
    required this.date,
    required this.mealType,
    required this.deadline,
    required this.isOpen,
    required this.courses,
  }) : assert(courses.isNotEmpty, "Un menu deve avere almeno un corso");


}