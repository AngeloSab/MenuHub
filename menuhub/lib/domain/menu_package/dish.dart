class Dish {
  final String id;
  final String name;
  final String description;

  const Dish({
    required this.id,
    required this.name,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
  };

  factory Dish.fromJson(Map<String, dynamic> json) => Dish(
    id: json["id"],
    name: json["name"],
    description: json["description"],
  );

}