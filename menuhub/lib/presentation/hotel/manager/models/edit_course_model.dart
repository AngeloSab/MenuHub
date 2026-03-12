import '../../../../domain/menu_package/course_type.dart';
import 'edit_dish_model.dart';

class EditCourseModel {
  final String id;
  final CourseType? type;
  final List<EditDishModel> dishes;

  const EditCourseModel({
    required this.id,
    required this.type,
    required this.dishes,
  });

  factory EditCourseModel.empty({required String id}) {
    return EditCourseModel(
      id: id,
      type: null,
      dishes: const [],
    );
  }

  EditCourseModel copyWith({
    String? id,
    CourseType? type,
    List<EditDishModel>? dishes,
    bool clearType = false,
  }) {
    return EditCourseModel(
      id: id ?? this.id,
      type: clearType ? null : (type ?? this.type),
      dishes: dishes ?? this.dishes,
    );
  }
}