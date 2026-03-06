import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/menu_package/menu.dart';
import '../domain/menu_package/course.dart';
import '../domain/menu_package/dish.dart';

class MenuFirestoreMapper {
  static Map<String, dynamic> toFirestore(Menu menu) => {
    'hotelId': menu.hotelId,
    'date': Timestamp.fromDate(menu.date),
    'mealType': menu.mealType,
    'deadline': Timestamp.fromDate(menu.deadline),
    'isOpen': menu.isOpen,
    'courses': menu.courses.map(_courseToMap).toList(),
  };

  static Menu fromFirestore({
    required String docId,
    required Map<String, dynamic> data,
  }) {
    return Menu(
      id: (data['id'] as String?) ?? docId,
      hotelId: data['hotelId'] as String,
      date: (data['date'] as Timestamp).toDate(),
      mealType: data['mealType'] as String,
      deadline: (data['deadline'] as Timestamp).toDate(),
      isOpen: data['isOpen'] as bool,
      courses: (data['courses'] as List)
          .map((e) => _courseFromMap(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }

  static Map<String, dynamic> _courseToMap(Course course) => {
    'id': course.id,
    'type': course.type,
    'dishes': course.dishes.map(_dishToMap).toList(),
  };

  static Course _courseFromMap(Map<String, dynamic> json) => Course(
    id: json['id'] as String,
    type: json['type'] as String,
    dishes: (json['dishes'] as List)
        .map((e) => _dishFromMap(Map<String, dynamic>.from(e)))
        .toList(),
  );

  static Map<String, dynamic> _dishToMap(Dish dish) => {
    'id': dish.id,
    'name': dish.name,
    'description': dish.description,
  };

  static Dish _dishFromMap(Map<String, dynamic> json) => Dish(
    id: json['id'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
  );
}