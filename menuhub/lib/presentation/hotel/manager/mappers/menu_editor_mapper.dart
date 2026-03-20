import '../../../../domain/menu_package/course.dart';
import '../../../../domain/menu_package/dish.dart';
import '../../../../domain/menu_package/dish_tag.dart';
import '../../../../domain/menu_package/menu.dart';
import '../models/edit_course_model.dart';
import '../models/edit_dish_model.dart';
import '../models/edit_menu_model.dart';


class MenuEditorMapper {
  static MenuEditorModel fromDomain(Menu menu) {
    return MenuEditorModel(
      id: menu.id,
      hotelId: menu.hotelId,
      date: menu.date,
      mealType: menu.mealType,
      deadline: menu.deadline,
      isOpen: menu.isOpen,
      isArchived: menu.isArchived,
      courses: menu.courses.map((course) {
        return EditCourseModel(
          id: course.id,
          type: course.type,
          dishes: course.dishes.map((dish) {
            return EditDishModel(
              id: dish.id,
              name: dish.name,
              description: dish.description,
              dishTags: Set<DishTag>.from(dish.dishTags),
            );
          }).toList(),
        );
      }).toList(),
      isLoading: false,
      isSaving: false,
      errorMessage: null,
    );
  }

  static Menu toDomain(MenuEditorModel model) {
    if (model.date == null) {
      throw Exception('Seleziona la data del menu');
    }

    if (model.mealType == null) {
      throw Exception('Seleziona il tipo di pasto');
    }

    if (model.deadline == null) {
      throw Exception('Seleziona la deadline');
    }

    if (model.courses.isEmpty) {
      throw Exception('Aggiungi almeno un corso');
    }

    final courses = model.courses.map((editableCourse) {
      if (editableCourse.type == null) {
        throw Exception('Ogni corso deve avere un tipo');
      }

      if (editableCourse.dishes.isEmpty) {
        throw Exception('Ogni corso deve contenere almeno un piatto');
      }

      final dishes = editableCourse.dishes.map((editableDish) {
        if (editableDish.name.trim().isEmpty) {
          throw Exception('Ogni piatto deve avere un nome');
        }

        return Dish(
          id: editableDish.id,
          name: editableDish.name.trim(),
          description: editableDish.description.trim(),
          dishTags: editableDish.dishTags.toList(),
        );
      }).toList();

      return Course(
        id: editableCourse.id,
        type: editableCourse.type!,
        dishes: dishes,
      );
    }).toList();

    return Menu(
      id: model.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      hotelId: model.hotelId,
      date: model.date!,
      mealType: model.mealType!,
      deadline: model.deadline!,
      isOpen: model.isOpen,
      isArchived: model.isArchived,
      courses: courses,
    );
  }
}