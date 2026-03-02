class Dish{
  String name;
  String description;

  Dish(this.name, this.description);

  set newName(String n) => name = n;
  set newDescription(String n) => description = n;

  void validateDish(){
    if (name.isEmpty || description.isEmpty) throw Exception("Nome e Descrizione non possono essere vuoti");
  }
}