import 'package:menuhub/domain/menu_package/meal_type.dart';

import '../menu_package/course.dart';
import '../menu_package/menu.dart';

class MenuBuilder {
  final String id;
  final String hotelId;
  final DateTime date;
  final MealType mealType;
  final DateTime deadline;

  final List<Course> _courses = [];

  MenuBuilder({
    required this.id,
    required this.hotelId,
    required this.date,
    required this.mealType,
    required this.deadline,
  });

  void addCourse(Course course) {
    _courses.add(course);
  }

  Menu build() {
    if (_courses.isEmpty) {
      throw Exception("Un menu deve contenere almeno un corso");
    }

    return Menu(
      id: id,
      hotelId: hotelId,
      date: date,
      mealType: mealType,
      deadline: deadline,
      isOpen: false,
      isArchived: false,
      courses: List.unmodifiable(_courses),
    );
  }
}