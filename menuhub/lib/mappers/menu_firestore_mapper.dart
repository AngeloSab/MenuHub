import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/menu_package/meal_type.dart';
import '../domain/menu_package/menu.dart';
import 'course_firestore_mapper.dart';

class MenuFirestoreMapper {
  static Map<String, dynamic> toFirestore(Menu menu) => {
    'hotelId': menu.hotelId,
    'date': Timestamp.fromDate(menu.date),
    'mealType': menu.mealType.name,
    'deadline': Timestamp.fromDate(menu.deadline),
    'isOpen': menu.isOpen,
    'courses': menu.courses.map(CourseFirestoreMapper.toFirestore).toList(),
  };

  static Menu fromFirestore({
    required String docId,
    required Map<String, dynamic> data,
  }) {
    final mealTypeString = data['mealType'] as String;
    return Menu(
      id: (data['id'] as String?) ?? docId,
      hotelId: data['hotelId'] as String,
      date: (data['date'] as Timestamp).toDate(),
      mealType: MealType.values.firstWhere(
            (value) => value.name == mealTypeString,
      ),
      deadline: (data['deadline'] as Timestamp).toDate(),
      isOpen: data['isOpen'] as bool,
      courses: (data['courses'] as List)
          .map((e) => CourseFirestoreMapper.fromFirestore(
        Map<String, dynamic>.from(e),
      ))
          .toList(),
    );
  }
}