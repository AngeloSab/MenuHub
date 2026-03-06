import '../menu_package/course.dart';
import '../menu_package/dish.dart';

class CourseBuilder {
  final String id;
  final String type;
  final List<Dish> _dishes = [];

  CourseBuilder({
    required this.id,
    required this.type,
  });

  void addDish(Dish dish) {
    _dishes.add(dish);
  }

  Course build() {
    if (_dishes.isEmpty) {
      throw Exception("Un corso deve contenere almeno un piatto");
    }

    return Course(
      id: id,
      type: type,
      dishes: List.unmodifiable(_dishes),
    );
  }
}