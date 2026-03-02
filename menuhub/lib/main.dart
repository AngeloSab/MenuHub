import 'domain/client_package/client.dart';
import 'domain/menu_package/course.dart';
import 'domain/menu_package/course_type.dart';
import 'domain/menu_package/dish.dart';
import 'domain/menu_package/meal_type.dart';
import 'domain/menu_package/menu.dart';
import 'domain/menu_package/menu_aggregator.dart';
import 'domain/order_package/order.dart';
import 'domain/order_package/order_manager.dart';

void main() {
  // ------------------------
  // CREAZIONE MENU
  // ------------------------
  Course primo = Course(CourseType.primo, [
    Dish("Carbonara", "Pasta con guanciale, uovo e pecorino"),
    Dish("Amatriciana", "Pasta con guanciale, pomodoro e pecorino")
  ]);

  Course secondo = Course(CourseType.secondo, [
    Dish("Pollo al forno", "Cosce di pollo al forno"),
    Dish("Salmone alla griglia", "Filetto di salmone alla griglia")
  ]);

  Course dessert = Course(CourseType.dessert, [
    Dish("Tiramisù", "Dolce al mascarpone e caffè"),
    Dish("Panna cotta", "Dolce al cucchiaio con coulis di frutti di bosco")
  ]);

  Menu pranzoOggi = Menu(
    "Pranzo di oggi",
    DateTime.now().add(Duration(hours: 2)), // deadline 2 ore da ora
    [primo, secondo, dessert],
    MealType.pranzo,
    DateTime.now().add(Duration(hours: 2)),
  );

  // ------------------------
  // CREAZIONE CLIENTI
  // ------------------------
  Client pippo = Client(10, "Pippo", 4, 102); // 4 persone in camera
  Client pluto = Client(11, "Pluto", 3, 103);

  // ------------------------
  // CREAZIONE ORDINI
  // ------------------------
  // Ordine Pippo
  Order ordinePippo = Order(pippo, pranzoOggi);
  try {
    ordinePippo.addDish(primo.dishes[0]); // Carbonara
    ordinePippo.addDish(primo.dishes[1]); // Amatriciana
    ordinePippo.addDish(primo.dishes[0]); // Carbonara di nuovo
    ordinePippo.addDish(primo.dishes[1]); // Amatriciana di nuovo
    // Prova ad eccedere numero massimo piatti
    ordinePippo.addDish(primo.dishes[0]); // Deve scattare eccezione
  } catch (e) {
    print("Errore ordine Pippo: $e");
  }

  // Ordine Pluto
  Order ordinePluto = Order(pluto, pranzoOggi);
  ordinePluto.addDish(primo.dishes[0]); // Carbonara
  ordinePluto.addDish(secondo.dishes[1]); // Salmone
  ordinePluto.addDish(dessert.dishes[0]); // Tiramisù

  // ------------------------
  // STAMPA ORDINI E CONTEGGI
  // ------------------------
  MenuAggregator aggregator = OrderManager().getAggregator(pranzoOggi);
  final totals = aggregator.calculateTotals();

  print("\n📊 Totali piatti per il menu '${pranzoOggi.name}':\n");

  totals.forEach((course, dishCounts) {
    print("--- ${course.courseType.toString().split('.').last.toUpperCase()} ---");
    dishCounts.forEach((dish, count) {
      print("${dish.name}: $count");
    });
    print("");
  });

  // ------------------------
  // TEST MENU CHIUSO / DEADLINE
  // ------------------------
  pranzoOggi.closeMenu();
  try {
    Order ordineTest = Order(pippo, pranzoOggi);
    ordineTest.addDish(primo.dishes[0]);
  } catch (e) {
    print("Tentativo dopo chiusura menu: $e");
  }
}