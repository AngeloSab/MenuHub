import 'package:flutter/material.dart';
import '../../shared/hotel_colors.dart';
import '../controllers/edit_menu_controller.dart';
import '../widgets/course_card.dart';
import '../widgets/empty_courses_card.dart';
import '../widgets/error_banner.dart';
import '../widgets/header_card.dart';
import '../widgets/info_tile.dart';
import '../widgets/meal_type_dropdown.dart';
import '../widgets/section_card.dart';

class MenuEditorPage extends StatefulWidget {
  final MenuEditorController controller;
  final String hotelId;
  final String? menuId;
  final VoidCallback? onSaved;

  const MenuEditorPage({
    super.key,
    required this.controller,
    required this.hotelId,
    this.menuId,
    this.onSaved,
  });

  @override
  State<MenuEditorPage> createState() => _MenuEditorPageState();
}

class _MenuEditorPageState extends State<MenuEditorPage> {
  @override
  void initState() {
    super.initState();

    if (widget.menuId == null) {
      widget.controller.initializeCreate(hotelId: widget.hotelId);
    } else {
      widget.controller.initializeEdit(
        hotelId: widget.hotelId,
        menuId: widget.menuId!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final model = widget.controller.model;

        return Scaffold(
          backgroundColor: HotelColors.background,
          appBar: AppBar(
            backgroundColor: HotelColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            title: Text(model.isEditMode ? 'Modifica menu' : 'Nuovo menu'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: TextButton.icon(
                  onPressed: model.isSaving ? null : _onSavePressed,
                  icon: model.isSaving
                      ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Icon(Icons.save, color: Colors.white),
                  label: const Text(
                    'Salva',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          body: model.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderCard(
                    isEditMode: model.isEditMode,
                    isOpen: model.isOpen,
                  ),
                  const SizedBox(height: 16),
                  if (model.errorMessage != null) ...[
                    ErrorBanner(message: model.errorMessage!),
                    const SizedBox(height: 16),
                  ],
                  SectionCard(
                    title: 'Informazioni generali',
                    icon: Icons.info_outline,
                    iconColor: HotelColors.secondary,
                    child: Column(
                      children: [
                        InfoTile(
                          label: 'Data menu',
                          value: model.date == null
                              ? 'Seleziona data'
                              : _formatDate(model.date!),
                          icon: Icons.calendar_today_outlined,
                          onTap: _pickMenuDate,
                        ),
                        const SizedBox(height: 12),
                        MealTypeDropdown(
                          value: model.mealType,
                          onChanged: (value) {
                            if (value != null) {
                              widget.controller.setMealType(value);
                            }
                          },
                        ),
                        const SizedBox(height: 12),
                        InfoTile(
                          label: 'Deadline ordini',
                          value: model.deadline == null
                              ? 'Seleziona deadline'
                              : _formatDateTime(model.deadline!),
                          icon: Icons.schedule_outlined,
                          onTap: _pickDeadline,
                        ),
                        const SizedBox(height: 12),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Menu aperto'),
                          subtitle: Text(
                            model.isOpen
                                ? 'Il menu sarà visibile al client'
                                : 'Il menu resterà chiuso',
                          ),
                          activeColor: HotelColors.success,
                          value: model.isOpen,
                          onChanged: widget.controller.setIsOpen,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Portate',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: HotelColors.secondary,
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: HotelColors.accent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: widget.controller.addCourse,
                        icon: const Icon(Icons.add),
                        label: const Text('Aggiungi corso'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (model.courses.isEmpty)
                    EmptyCoursesCard(
                      onAddCourse: widget.controller.addCourse,
                    )
                  else
                    Column(
                      children: model.courses.map((course) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: CourseCard(
                            course: course,
                            onRemoveCourse: () {
                              widget.controller.removeCourse(course.id);
                            },
                            onCourseTypeChanged: (value) {
                              if (value != null) {
                                widget.controller.updateCourseType(
                                  courseId: course.id,
                                  courseType: value,
                                );
                              }
                            },
                            onAddDish: () {
                              widget.controller.addDish(course.id);
                            },
                            onRemoveDish: (dishId) {
                              widget.controller.removeDish(
                                courseId: course.id,
                                dishId: dishId,
                              );
                            },
                            onDishNameChanged: (dishId, value) {
                              widget.controller.updateDishName(
                                courseId: course.id,
                                dishId: dishId,
                                name: value,
                              );
                            },
                            onDishDescriptionChanged: (dishId, value) {
                              widget.controller.updateDishDescription(
                                courseId: course.id,
                                dishId: dishId,
                                description: value,
                              );
                            },
                            onToggleTag: (dishId, tag) {
                              widget.controller.toggleDishTag(
                                courseId: course.id,
                                dishId: dishId,
                                tag: tag,
                              );
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: HotelColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: model.isSaving ? null : _onSavePressed,
                      icon: model.isSaving
                          ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : const Icon(Icons.save_outlined),
                      label: Text(
                        model.isSaving ? 'Salvataggio...' : 'Salva menu',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _onSavePressed() async {
    final ok = await widget.controller.save();
    if (!mounted) return;

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Menu salvato con successo'),
        ),
      );
      widget.onSaved?.call();
    }
  }

  Future<void> _pickMenuDate() async {
    final model = widget.controller.model;
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: model.date ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 3),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: HotelColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      widget.controller.setDate(picked);
    }
  }

  Future<void> _pickDeadline() async {
    final model = widget.controller.model;
    final now = DateTime.now();

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: model.deadline ?? model.date ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 3),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: HotelColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null || !mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: model.deadline != null
          ? TimeOfDay.fromDateTime(model.deadline!)
          : const TimeOfDay(hour: 12, minute: 0),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: HotelColors.accent,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime == null) return;

    final deadline = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    widget.controller.setDeadline(deadline);
  }

  String _formatDate(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    final y = date.year.toString();
    return '$d/$m/$y';
  }

  String _formatDateTime(DateTime dateTime) {
    final date = _formatDate(dateTime);
    final h = dateTime.hour.toString().padLeft(2, '0');
    final min = dateTime.minute.toString().padLeft(2, '0');
    return '$date - $h:$min';
  }
}