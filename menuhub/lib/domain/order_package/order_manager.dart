import '../menu_package/menu.dart';
import '../menu_package/menu_aggregator.dart';
import 'order.dart';

class OrderManager {
  static final Map<Menu, List<Order>> ordersPerMenu = {};

  static void addOrder(Order order) {
    final menu = order.menu;
    if (!ordersPerMenu.containsKey(menu)) {
      ordersPerMenu[menu] = [];
    }
    ordersPerMenu[menu]!.add(order);
  }

  static List<Order> getOrders(Menu menu) {
    return ordersPerMenu[menu] ?? [];
  }

  MenuAggregator getAggregator(Menu menu) {
    final menuOrders = getOrders(menu);
    return MenuAggregator(menu, menuOrders);
  }
}