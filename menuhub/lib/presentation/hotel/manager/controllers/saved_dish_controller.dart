import 'dart:async';

import 'package:flutter/material.dart';
import '../../../../application/use_cases/staff/delete_saved_dish_uc.dart';
import '../../../../application/use_cases/staff/save_saved_dish_uc.dart';
import '../../../../application/use_cases/staff/watch_saved_dishes_uc.dart';
import '../../../../domain/menu_package/saved_dish.dart';
import '../models/saved_dish_model.dart';

class SavedDishController extends ChangeNotifier {
  final WatchSavedDishesUC watchSavedDishesUC;
  final SaveSavedDishUC saveSavedDishUC;
  final DeleteSavedDishUC deleteSavedDishUC;

  SavedDishModel _model = SavedDishModel.initial();
  SavedDishModel get model => _model;

  StreamSubscription<List<SavedDish>>? _subscription;

  SavedDishController({
    required this.watchSavedDishesUC,
    required this.saveSavedDishUC,
    required this.deleteSavedDishUC,
  });

  /// 🔹 START STREAM
  void startWatching(String hotelId) {
    _subscription?.cancel();

    _model = _model.copyWith(isLoading: true, errorMessage: null);
    notifyListeners();

    _subscription = watchSavedDishesUC.execute(hotelId).listen(
          (dishes) {
        _model = _model.copyWith(
          isLoading: false,
          dishes: dishes,
          errorMessage: null,
        );
        notifyListeners();
      },
      onError: (error) {
        _model = _model.copyWith(
          isLoading: false,
          errorMessage: error.toString(),
        );
        notifyListeners();
      },
    );
  }

  /// 🔹 SAVE (create/update)
  Future<void> saveDish(SavedDish dish) async {
    try {
      await saveSavedDishUC.execute(dish);
    } catch (e) {
      _model = _model.copyWith(errorMessage: e.toString());
      notifyListeners();
    }
  }

  /// 🔹 DELETE
  Future<void> deleteDish({
    required String hotelId,
    required String dishId,
  }) async {
    try {
      await deleteSavedDishUC.execute(
        hotelId: hotelId,
        dishId: dishId,
      );
    } catch (e) {
      _model = _model.copyWith(errorMessage: e.toString());
      notifyListeners();
    }
  }

  /// 🔹 CLEAR ERROR
  void clearError() {
    _model = _model.copyWith(errorMessage: null);
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}