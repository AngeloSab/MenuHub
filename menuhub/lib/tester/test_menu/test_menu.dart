import '../domain/menu_package/menu.dart';
import '../domain/menu_package/course.dart';
import '../domain/menu_package/dish.dart';
import '../domain/menu_package/dish_tag.dart';

Menu createTestMenu() {
  return Menu(
    id: "menu_test",
    hotelId: "hotel_test_01",
    date: DateTime.now(),
    mealType: "Dinner",
    deadline: DateTime.now().add(const Duration(hours: 3)),
    isOpen: true,
    courses: [
      Course(
        id: "course_1",
        type: "Antipasti",
        dishes: [
          Dish(
            id: "dish_1",
            name: "Bruschetta",
            description: "Pane tostato con pomodoro",
            dishTags: [DishTag.vegetarian],
          ),
        ],
      ),
      Course(
        id: "course_2",
        type: "Primi",
        dishes: [
          Dish(
            id: "dish_2",
            name: "Risotto ai funghi",
            description: "Riso con funghi porcini",
            dishTags: [],
          ),
        ],
      ),
    ],
  );
}