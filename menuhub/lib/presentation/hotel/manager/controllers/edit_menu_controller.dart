import 'package:flutter/foundation.dart';
import '../../../../application/use_cases/staff/create_menu_uc.dart';
import '../../../../application/use_cases/staff/get_menu_by_id_uc.dart';
import '../../../../domain/menu_package/course_type.dart';
import '../../../../domain/menu_package/dish_tag.dart';
import '../../../../domain/menu_package/meal_type.dart';
import '../mappers/menu_editor_mapper.dart';
import '../models/edit_course_model.dart';
import '../models/edit_dish_model.dart';
import '../models/edit_menu_model.dart';


class MenuEditorController extends ChangeNotifier {
  final GetMenuByIdUC getMenuByIdUC;
  final CreateMenuUC createMenuUC;
  final CreateMenuUC updateMenuUC;

  MenuEditorModel _model;

  MenuEditorController({
    required this.getMenuByIdUC,
    required this.createMenuUC,
    required this.updateMenuUC,
    required String hotelId,
  }) : _model = MenuEditorModel.create(hotelId: hotelId);

  MenuEditorModel get model => _model;

  Future<void> initializeCreate({
    required String hotelId,
  }) async {
    _model = MenuEditorModel.create(hotelId: hotelId);
    notifyListeners();
  }

  Future<void> initializeEdit({
    required String hotelId,
    required String menuId,
  }) async {
    _model = _model.copyWith(
      isLoading: true,
      clearError: true,
    );
    notifyListeners();

    try {
      final menu = await getMenuByIdUC.execute(
        hotelId: hotelId,
        menuId: menuId,
      );

      if (menu == null) {
        _model = _model.copyWith(
          isLoading: false,
          errorMessage: 'Menu non trovato',
        );
        notifyListeners();
        return;
      }

      _model = MenuEditorMapper.fromDomain(menu).copyWith(
        isLoading: false,
        isSaving: false,
        clearError: true,
      );
      notifyListeners();
    } catch (e) {
      _model = _model.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      notifyListeners();
    }
  }

  void setDate(DateTime date) {
    _model = _model.copyWith(
      date: date,
      clearError: true,
    );
    notifyListeners();
  }

  void setMealType(MealType mealType) {
    _model = _model.copyWith(
      mealType: mealType,
      clearError: true,
    );
    notifyListeners();
  }

  void setDeadline(DateTime deadline) {
    _model = _model.copyWith(
      deadline: deadline,
      clearError: true,
    );
    notifyListeners();
  }

  void setIsOpen(bool isOpen) {
    _model = _model.copyWith(
      isOpen: isOpen,
      clearError: true,
    );
    notifyListeners();
  }

  void addCourse() {
    final updatedCourses = List<EditCourseModel>.from(_model.courses)
      ..add(
        EditCourseModel.empty(id: _generateId()),
      );

    _model = _model.copyWith(
      courses: updatedCourses,
      clearError: true,
    );
    notifyListeners();
  }

  void removeCourse(String courseId) {
    final updatedCourses = _model.courses
        .where((course) => course.id != courseId)
        .toList();

    _model = _model.copyWith(
      courses: updatedCourses,
      clearError: true,
    );
    notifyListeners();
  }

  void updateCourseType({
    required String courseId,
    required CourseType courseType,
  }) {
    final updatedCourses = _model.courses.map((course) {
      if (course.id != courseId) return course;
      return course.copyWith(type: courseType);
    }).toList();

    _model = _model.copyWith(
      courses: updatedCourses,
      clearError: true,
    );
    notifyListeners();
  }

  void addDish(String courseId) {
    final updatedCourses = _model.courses.map((course) {
      if (course.id != courseId) return course;

      final updatedDishes = List<EditDishModel>.from(course.dishes)
        ..add(
          EditDishModel.empty(id: _generateId()),
        );

      return course.copyWith(dishes: updatedDishes);
    }).toList();

    _model = _model.copyWith(
      courses: updatedCourses,
      clearError: true,
    );
    notifyListeners();
  }

  void removeDish({
    required String courseId,
    required String dishId,
  }) {
    final updatedCourses = _model.courses.map((course) {
      if (course.id != courseId) return course;

      final updatedDishes = course.dishes
          .where((dish) => dish.id != dishId)
          .toList();

      return course.copyWith(dishes: updatedDishes);
    }).toList();

    _model = _model.copyWith(
      courses: updatedCourses,
      clearError: true,
    );
    notifyListeners();
  }

  void updateDishName({
    required String courseId,
    required String dishId,
    required String name,
  }) {
    final updatedCourses = _updateDishInCourse(
      courseId: courseId,
      dishId: dishId,
      update: (dish) => dish.copyWith(name: name),
    );

    _model = _model.copyWith(
      courses: updatedCourses,
      clearError: true,
    );
    notifyListeners();
  }

  void updateDishDescription({
    required String courseId,
    required String dishId,
    required String description,
  }) {
    final updatedCourses = _updateDishInCourse(
      courseId: courseId,
      dishId: dishId,
      update: (dish) => dish.copyWith(description: description),
    );

    _model = _model.copyWith(
      courses: updatedCourses,
      clearError: true,
    );
    notifyListeners();
  }

  void toggleDishTag({
    required String courseId,
    required String dishId,
    required DishTag tag,
  }) {
    final updatedCourses = _updateDishInCourse(
      courseId: courseId,
      dishId: dishId,
      update: (dish) {
        final updatedTags = Set<DishTag>.from(dish.dishTags);

        if (updatedTags.contains(tag)) {
          updatedTags.remove(tag);
        } else {
          updatedTags.add(tag);
        }

        return dish.copyWith(dishTags: updatedTags);
      },
    );

    _model = _model.copyWith(
      courses: updatedCourses,
      clearError: true,
    );
    notifyListeners();
  }

  Future<bool> save() async {
    _model = _model.copyWith(
      isSaving: true,
      clearError: true,
    );
    notifyListeners();

    try {
      final menu = MenuEditorMapper.toDomain(_model);

      if (_model.isEditMode) {
        await updateMenuUC.execute(menu);
      } else {
        await createMenuUC.execute(menu);
      }

      _model = _model.copyWith(
        id: menu.id,
        isSaving: false,
      );
      notifyListeners();

      return true;
    } catch (e) {
      _model = _model.copyWith(
        isSaving: false,
        errorMessage: e.toString(),
      );
      notifyListeners();

      return false;
    }
  }

  List<EditCourseModel> _updateDishInCourse({
    required String courseId,
    required String dishId,
    required EditDishModel Function(EditDishModel dish) update,
  }) {
    return _model.courses.map((course) {
      if (course.id != courseId) return course;

      final updatedDishes = course.dishes.map((dish) {
        if (dish.id != dishId) return dish;
        return update(dish);
      }).toList();

      return course.copyWith(dishes: updatedDishes);
    }).toList();
  }

  String _generateId() {
    return DateTime.now().microsecondsSinceEpoch.toString();
  }
}