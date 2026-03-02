import 'meal_type.dart';
import 'menu.dart';

class MenuManager {
  static final Map<DateTime, Map<MealType, List<Menu>>> menusPerDay = {};

  static void addMenu(Menu menu) {
    final day = DateTime(menu.date.year, menu.date.month, menu.date.day);

    if (!menusPerDay.containsKey(day)) {
      menusPerDay[day] = {};
    }

    if (!menusPerDay[day]!.containsKey(menu.mealType)) {
      menusPerDay[day]![menu.mealType] = [];
    }

    menusPerDay[day]![menu.mealType]!.add(menu);
  }

  static List<Menu> getMenus(DateTime date, MealType type) {
    final day = DateTime(date.year, date.month, date.day);
    return menusPerDay[day]?[type] ?? [];
  }

  static Map<MealType, List<Menu>> getMenusForDay(DateTime date) {
    final day = DateTime(date.year, date.month, date.day);
    return menusPerDay[day] ?? {};
  }
}