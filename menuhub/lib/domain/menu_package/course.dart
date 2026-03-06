import 'dish.dart';

class Course {
  final String id;
  final String type;
  final List<Dish> dishes;

  const Course({
    required this.id,
    required this.type,
    required this.dishes,
  }) : assert(dishes.length > 0, "Un corso deve avere almeno un piatto");

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "dishes": dishes.map((d) => d.toJson()).toList(),
  };

  factory Course.fromJson(Map<String, dynamic> json) => Course(
    id: json["id"],
    type: json["type"],
    dishes: (json["dishes"] as List)
        .map((e) => Dish.fromJson(e))
        .toList(),
  );
}