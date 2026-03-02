

import '../client_package/client.dart';
import '../menu_package/course.dart';
import '../menu_package/dish.dart';
import '../menu_package/menu.dart';
import 'order_manager.dart';

class Order {
  final Client client;
  final Menu menu;

  final Map<Course, List<Dish>> selections;

  Order(this.client, this.menu)
      : selections = {}
  {
    OrderManager.addOrder(this);
  }

  void addDish(Dish dish) {
    _validateMenuOpen();
    int maxPerCourse = client.peopleCount;
    Course ct = findCourseByDish(dish);
    if (!selections.containsKey(ct)) selections[ct] = [];
    int actualDishForCourse = selections[ct]!.length;
    if (actualDishForCourse >= maxPerCourse) throw Exception("Hai raggiunto il massimo di $maxPerCourse piatti per questa portata");
    selections[ct]!.add(dish);
  }

  void removeDish(Dish dish) {
    _validateMenuOpen();
    Course ct = findCourseByDish(dish);
    if (!selections[ct]!.contains(dish)) throw Exception("Questo piatto non è stato ordinato");
    selections[ct]!.remove(dish);
  }

  void _validateMenuOpen() {
    if (!menu.isOpen || menu.isDeadlinePassed()) {
      throw Exception("Il menu è chiuso o la deadline è scaduta");
    }
  }

  Course findCourseByDish(Dish d){
    for (Course c in menu.courses){
      if (c.dishes.contains(d)) return c;    }
    throw Exception("Piatto non trovato");
  }
}