import '../../../../domain/menu_package/menu.dart';

class MenuListModel {
  final bool isLoading;
  final List<Menu> menus;
  final String? errorMessage;

  const MenuListModel({
    required this.isLoading,
    required this.menus,
    required this.errorMessage,
  });

  factory MenuListModel.initial() {
    return const MenuListModel(
      isLoading: false,
      menus: [],
      errorMessage: null,
    );
  }

  MenuListModel copyWith({
    bool? isLoading,
    List<Menu>? menus,
    String? errorMessage,
    bool clearError = false,
  }) {
    return MenuListModel(
      isLoading: isLoading ?? this.isLoading,
      menus: menus ?? this.menus,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}