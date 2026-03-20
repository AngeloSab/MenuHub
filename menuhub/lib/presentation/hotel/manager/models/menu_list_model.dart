import '../../../../domain/menu_package/menu.dart';

class MenuListModel {
  final bool isLoading;
  final List<Menu> menus;
  final Map<String, int> ordersCountByMenu;
  final String? errorMessage;

  const MenuListModel({
    required this.isLoading,
    required this.menus,
    required this.ordersCountByMenu,
    required this.errorMessage,
  });

  factory MenuListModel.initial() {
    return const MenuListModel(
      isLoading: false,
      menus: [],
      ordersCountByMenu: {},
      errorMessage: null,
    );
  }

  MenuListModel copyWith({
    bool? isLoading,
    List<Menu>? menus,
    Map<String, int>? ordersCountByMenu,
    String? errorMessage,
    bool clearError = false,
  }) {
    return MenuListModel(
      isLoading: isLoading ?? this.isLoading,
      menus: menus ?? this.menus,
      ordersCountByMenu: ordersCountByMenu ?? this.ordersCountByMenu,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}