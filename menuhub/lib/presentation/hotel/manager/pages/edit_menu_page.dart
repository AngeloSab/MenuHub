import 'package:flutter/material.dart';

import '../../shared/hotel_colors.dart';
import '../../shared/hotel_radius.dart';
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
          backgroundColor: Colors.transparent,
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  HotelColors.backgroundSecondary,
                  HotelColors.background,
                ],
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: -70,
                  right: -30,
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      color: HotelColors.glowBlue,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                Positioned(
                  top: 220,
                  left: -50,
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      color: HotelColors.glowPurple,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                Column(
                  children: [
                    AppBar(
                      backgroundColor: Colors.transparent,
                      foregroundColor: HotelColors.textPrimary,
                      elevation: 0,
                      scrolledUnderElevation: 0,
                      title: Text(
                        model.isEditMode ? 'Modifica menu' : 'Nuovo menu',
                        style: const TextStyle(
                          color: HotelColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      actions: [
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: TextButton.icon(
                            onPressed: model.isSaving ? null : _onSavePressed,
                            style: TextButton.styleFrom(
                              foregroundColor: HotelColors.primary,
                            ),
                            icon: model.isSaving
                                ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: HotelColors.primary,
                              ),
                            )
                                : const Icon(Icons.save_outlined),
                            label: const Text(
                              'Salva',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: model.isLoading
                          ? const Center(
                        child: CircularProgressIndicator(),
                      )
                          : SafeArea(
                        top: false,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(
                            16,
                            8,
                            16,
                            24,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              HeaderCard(
                                isEditMode: model.isEditMode,
                                isOpen: model.isOpen,
                              ),
                              const SizedBox(height: 18),
                              if (model.errorMessage != null) ...[
                                ErrorBanner(
                                  message: model.errorMessage!,
                                ),
                                const SizedBox(height: 18),
                              ],
                              SectionCard(
                                title: 'Informazioni generali',
                                icon: Icons.tune_rounded,
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
                                          widget.controller
                                              .setMealType(value);
                                        }
                                      },
                                    ),
                                    const SizedBox(height: 12),
                                    InfoTile(
                                      label: 'Deadline ordini',
                                      value: model.deadline == null
                                          ? 'Seleziona deadline'
                                          : _formatDateTime(
                                        model.deadline!,
                                      ),
                                      icon: Icons.schedule_outlined,
                                      onTap: _pickDeadline,
                                    ),
                                    const SizedBox(height: 12),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(
                                          0.60,
                                        ),
                                        borderRadius:
                                        BorderRadius.circular(
                                          HotelRadius.button,
                                        ),
                                        border: Border.all(
                                          color: HotelColors.borderSoft,
                                        ),
                                      ),
                                      child: SwitchListTile(
                                        contentPadding:
                                        const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 4,
                                        ),
                                        title: const Text(
                                          'Menu aperto',
                                          style: TextStyle(
                                            color: HotelColors.textPrimary,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        subtitle: Text(
                                          model.isOpen
                                              ? 'Il menu è visibile lato client'
                                              : 'Il menu resta in bozza',
                                          style: const TextStyle(
                                            color:
                                            HotelColors.textSecondary,
                                          ),
                                        ),
                                        activeColor:
                                        HotelColors.success,
                                        value: model.isOpen,
                                        onChanged:
                                        widget.controller.setIsOpen,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 22),
                              Row(
                                children: [
                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Portate del menu',
                                          style: TextStyle(
                                            color:
                                            HotelColors.textPrimary,
                                            fontSize: 21,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Organizza la struttura del menu aggiungendo portate e piatti.',
                                          style: TextStyle(
                                            color: HotelColors
                                                .textSecondary,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor:
                                      HotelColors.accent,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 14,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(
                                          HotelRadius.button,
                                        ),
                                      ),
                                    ),
                                    onPressed:
                                    widget.controller.addCourse,
                                    icon: const Icon(Icons.add),
                                    label: const Text(
                                      'Aggiungi',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              if (model.courses.isEmpty)
                                EmptyCoursesCard(
                                  onAddCourse:
                                  widget.controller.addCourse,
                                )
                              else
                                Column(
                                  children:
                                  model.courses.map((course) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 16,
                                      ),
                                      child: CourseCard(
                                        course: course,
                                        onRemoveCourse: () {
                                          widget.controller.removeCourse(
                                            course.id,
                                          );
                                        },
                                        onCourseTypeChanged: (value) {
                                          if (value != null) {
                                            widget.controller
                                                .updateCourseType(
                                              courseId: course.id,
                                              courseType: value,
                                            );
                                          }
                                        },
                                        onAddDish: () {
                                          widget.controller.addDish(
                                            course.id,
                                          );
                                        },
                                        onRemoveDish: (dishId) {
                                          widget.controller.removeDish(
                                            courseId: course.id,
                                            dishId: dishId,
                                          );
                                        },
                                        onDishNameChanged:
                                            (dishId, value) {
                                          widget.controller
                                              .updateDishName(
                                            courseId: course.id,
                                            dishId: dishId,
                                            name: value,
                                          );
                                        },
                                        onDishDescriptionChanged:
                                            (dishId, value) {
                                          widget.controller
                                              .updateDishDescription(
                                            courseId: course.id,
                                            dishId: dishId,
                                            description: value,
                                          );
                                        },
                                        onToggleTag: (dishId, tag) {
                                          widget.controller
                                              .toggleDishTag(
                                            courseId: course.id,
                                            dishId: dishId,
                                            tag: tag,
                                          );
                                        },
                                      ),
                                    );
                                  }).toList(),
                                ),
                              const SizedBox(height: 28),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    HotelRadius.card,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: HotelColors.glowBlue,
                                      blurRadius: 24,
                                      offset: Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor:
                                    HotelColors.primary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 18,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(
                                        HotelRadius.card,
                                      ),
                                    ),
                                  ),
                                  onPressed: model.isSaving
                                      ? null
                                      : _onSavePressed,
                                  icon: model.isSaving
                                      ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child:
                                    CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                      : const Icon(
                                    Icons.save_outlined,
                                  ),
                                  label: Text(
                                    model.isSaving
                                        ? 'Salvataggio in corso...'
                                        : 'Salva menu',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
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
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: HotelColors.textPrimary,
          content: const Text('Menu salvato con successo'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(HotelRadius.button),
          ),
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
    return '$date • $h:$min';
  }
}