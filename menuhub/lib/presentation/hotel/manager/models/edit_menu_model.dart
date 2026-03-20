import '../../../../domain/menu_package/meal_type.dart';
import 'edit_course_model.dart';

class MenuEditorModel {
  final String? id;
  final String hotelId;
  final DateTime? date;
  final MealType? mealType;
  final DateTime? deadline;
  final bool isOpen;
  final bool isArchived;
  final List<EditCourseModel> courses;

  final bool isLoading;
  final bool isSaving;
  final String? errorMessage;

  const MenuEditorModel({
    required this.id,
    required this.hotelId,
    required this.date,
    required this.mealType,
    required this.deadline,
    required this.isOpen,
    required this.isArchived,
    required this.courses,
    required this.isLoading,
    required this.isSaving,
    required this.errorMessage,
  });

  factory MenuEditorModel.create({
    required String hotelId,
  }) {
    return MenuEditorModel(
      id: null,
      hotelId: hotelId,
      date: null,
      mealType: null,
      deadline: null,
      isOpen: false,
      isArchived: false,
      courses: const [],
      isLoading: false,
      isSaving: false,
      errorMessage: null,
    );
  }

  MenuEditorModel copyWith({
    String? id,
    String? hotelId,
    DateTime? date,
    MealType? mealType,
    DateTime? deadline,
    bool? isOpen,
    bool? isArchived,
    List<EditCourseModel>? courses,
    bool? isLoading,
    bool? isSaving,
    String? errorMessage,
    bool clearDate = false,
    bool clearMealType = false,
    bool clearDeadline = false,
    bool clearError = false,
  }) {
    return MenuEditorModel(
      id: id ?? this.id,
      hotelId: hotelId ?? this.hotelId,
      date: clearDate ? null : (date ?? this.date),
      mealType: clearMealType ? null : (mealType ?? this.mealType),
      deadline: clearDeadline ? null : (deadline ?? this.deadline),
      isOpen: isOpen ?? this.isOpen,
      isArchived: isOpen ?? this.isArchived,
      courses: courses ?? this.courses,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  bool get isEditMode => id != null;
}