import '../../../../domain/menu_package/dish_tag.dart';

class EditDishModel {
  final String id;
  final String name;
  final String description;
  final Set<DishTag> dishTags;

  const EditDishModel({
    required this.id,
    required this.name,
    required this.description,
    required this.dishTags,
  });

  factory EditDishModel.empty({required String id}) {
    return EditDishModel(
      id: id,
      name: '',
      description: '',
      dishTags: <DishTag>{},
    );
  }

  EditDishModel copyWith({
    String? id,
    String? name,
    String? description,
    Set<DishTag>? dishTags,
  }) {
    return EditDishModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      dishTags: dishTags ?? this.dishTags,
    );
  }
}