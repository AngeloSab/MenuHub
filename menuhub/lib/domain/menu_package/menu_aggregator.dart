import '../order_package/order.dart';
import 'course.dart';
import 'dish.dart';
import 'menu.dart';


class MenuAggregator {
  final Menu menu;
  final List<Order> orders;

  MenuAggregator(this.menu, this.orders);

  /// Calcola quanti piatti di ogni tipo sono stati ordinati per questo menu
  Map<Course, Map<Dish, int>> calculateTotals() {
    final Map<Course, Map<Dish, int>> totals = {};

    for (Order order in orders) {
      order.selections.forEach((Course course, List<Dish> dishes) {
        totals.putIfAbsent(course, () => {});
        for (Dish dish in dishes) {
          totals[course]![dish] = (totals[course]![dish] ?? 0) + 1;
        }
      });
    }

    return totals;
  }
}