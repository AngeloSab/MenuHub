import 'course.dart';
import 'course_type.dart';
import 'meal_type.dart';
import 'menu_manager.dart';

class Menu {
  final DateTime date;
  final String name;
  final List<Course> courses;
  final DateTime deadline;
  final MealType mealType;
  bool isOpen;

  Menu(this.name, this.date, List<Course> courses, this.mealType, this.deadline)
      : courses = List.unmodifiable(courses),
        isOpen = true {
          _validate();
          MenuManager.addMenu(this);
  }

  void _validate() {
    if (courses.isEmpty) throw Exception("Il menu deve avere almeno una portata");

    if (deadline.isBefore(DateTime.now())) throw Exception("La deadline è già scaduta");

    final types = <CourseType>{};

    for (final course in courses) {
      if (!types.add(course.courseType)) {
        throw Exception("Portata ${course.courseType} duplicata nel menu");
      }
    }
  }

  void closeMenu() {
    isOpen = false;
  }

  bool isDeadlinePassed() {
    return DateTime.now().isAfter(deadline);
  }
}