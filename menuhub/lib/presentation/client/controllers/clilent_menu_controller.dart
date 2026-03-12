import 'package:flutter/material.dart';
import 'package:menuhub/domain/menu_package/course.dart';
import 'package:menuhub/domain/menu_package/menu.dart';
import 'package:menuhub/domain/order_package/order.dart';
import 'package:menuhub/domain/order_package/order_selection.dart';
import '../../../application/use_cases/client/place_order_uc.dart';
import '../../../domain/client_package/client_session.dart';
import '../models/client_menu_model.dart';

class ClientMenuController extends ChangeNotifier {
  final Menu menu;
  final PlaceOrderUC placeOrderUC;

  final Map<String, ClientMenuModel> _dishStates = {};

  bool _isSubmitting = false;

  ClientMenuController({
    required this.menu,
    required this.placeOrderUC,
  }) {
    _initializeDishStates();
  }

  void _initializeDishStates() {
    for (final course in menu.courses) {
      for (final dish in course.dishes) {
        _dishStates[dish.id] = ClientMenuModel.initial(dish.id);
      }
    }
  }

  ClientMenuModel _stateOf(String dishId) {
    final state = _dishStates[dishId];
    if (state == null) {
      throw StateError('Nessuno stato trovato per il dishId: $dishId');
    }
    return state;
  }

  bool get isSubmitting => _isSubmitting;

  int quantityOf(String dishId) {
    return _stateOf(dishId).quantity;
  }

  String variationOf(String dishId) {
    return _stateOf(dishId).variation;
  }

  bool isVariationVisible(String dishId) {
    return _stateOf(dishId).isVariationVisible;
  }

  bool get hasSelections {
    return _dishStates.values.any((state) => state.quantity > 0);
  }

  void incrementDish(String dishId) {
    if (_isSubmitting) return;

    final currentState = _stateOf(dishId);

    _dishStates[dishId] = currentState.copyWith(
      quantity: currentState.quantity + 1,
    );

    notifyListeners();
  }

  void decrementDish(String dishId) {
    if (_isSubmitting) return;

    final currentState = _stateOf(dishId);

    if (currentState.quantity <= 1) {
      _dishStates[dishId] = currentState.copyWith(
        quantity: 0,
        variation: '',
        isVariationVisible: false,
      );
    } else {
      _dishStates[dishId] = currentState.copyWith(
        quantity: currentState.quantity - 1,
      );
    }

    notifyListeners();
  }

  void toggleVariation(String dishId) {
    if (_isSubmitting) return;

    final currentState = _stateOf(dishId);

    _dishStates[dishId] = currentState.copyWith(
      isVariationVisible: !currentState.isVariationVisible,
    );

    notifyListeners();
  }

  void updateVariation(String dishId, String value) {
    if (_isSubmitting) return;

    final currentState = _stateOf(dishId);
    final trimmedValue = value.trim();

    _dishStates[dishId] = currentState.copyWith(
      variation: trimmedValue,
    );

    notifyListeners();
  }

  int orderedCountForCourse(Course course) {
    int total = 0;

    for (final dish in course.dishes) {
      total += quantityOf(dish.id);
    }

    return total;
  }

  void clearOrder() {
    if (_isSubmitting) return;

    for (final entry in _dishStates.entries) {
      _dishStates[entry.key] = ClientMenuModel.initial(entry.key);
    }

    notifyListeners();
  }

  List<OrderSelection> buildSelections() {
    final List<OrderSelection> selections = [];

    for (final course in menu.courses) {
      for (final dish in course.dishes) {
        final state = _stateOf(dish.id);

        if (state.quantity <= 0) {
          continue;
        }

        final String? variations =
        state.variation.trim().isEmpty ? null : state.variation.trim();

        selections.add(
          OrderSelection(
            courseId: course.id,
            dishId: dish.id,
            variations: variations,
            quantity: state.quantity,
          ),
        );
      }
    }

    return selections;
  }

  String _generateOrderId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  Future<Order> submitOrder({
    required ClientSession clientSession,
  }) async {
    if (_isSubmitting) {
      throw StateError('Invio ordine già in corso.');
    }

    final selections = buildSelections();

    if (selections.isEmpty) {
      throw Exception('Non puoi inviare un ordine vuoto.');
    }

    _isSubmitting = true;
    notifyListeners();

    try {
      final order = await placeOrderUC.execute(
        id: _generateOrderId(),
        hotelId: clientSession.hotelId,
        clientSessionId: clientSession.id,
        reservationName: clientSession.name,
        roomNumber: clientSession.roomNumber,
        menuId: menu.id,
        selections: selections,
      );

      return order;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }
}