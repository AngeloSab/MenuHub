import 'package:flutter/material.dart';
import '../../../../application/use_cases/staff/create_menu_uc.dart';
import '../../../../application/use_cases/staff/get_menu_by_id_uc.dart';
import '../../shared/hotel_colors.dart';
import '../controllers/edit_menu_controller.dart';
import '../controllers/menu_list_controller.dart';
import '../widgets/menu_list_item_card.dart';
import 'edit_menu_page.dart';

class MenuListPage extends StatefulWidget {
  final MenuListController controller;
  final String hotelId;
  final GetMenuByIdUC getMenuByIdUC;
  final CreateMenuUC createMenuUC;
  final CreateMenuUC updateMenuUC;

  const MenuListPage({
    super.key,
    required this.controller,
    required this.hotelId,
    required this.getMenuByIdUC,
    required this.createMenuUC,
    required this.updateMenuUC,
  });

  @override
  State<MenuListPage> createState() => _MenuListPageState();
}

class _MenuListPageState extends State<MenuListPage> {
  @override
  void initState() {
    super.initState();
    widget.controller.startWatching(widget.hotelId);
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
            title: const Text('Gestione Menu'),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: HotelColors.accent,
            foregroundColor: Colors.white,
            onPressed: _openCreateMenu,
            child: const Icon(Icons.add),
          ),
          body: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                decoration: const BoxDecoration(
                  color: HotelColors.primary,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(24),
                  ),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Menu manager',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Crea, modifica, apri e chiudi i menu del tuo hotel.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (model.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (model.errorMessage != null) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                size: 48,
                                color: HotelColors.warning,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                model.errorMessage!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 15),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: HotelColors.secondary,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () {
                                  widget.controller.clearError();
                                  widget.controller.startWatching(widget.hotelId);
                                },
                                child: const Text('Riprova'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    if (model.menus.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.restaurant_menu,
                                size: 56,
                                color: HotelColors.secondary,
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Nessun menu disponibile',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Crea il primo menu per iniziare.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: HotelColors.accent,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: _openCreateMenu,
                                icon: const Icon(Icons.add),
                                label: const Text('Nuovo menu'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: model.menus.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final menu = model.menus[index];

                        return MenuListItemCard(
                          menu: menu,
                          onEdit: () => _openEditMenu(menu.id),
                          onToggleOpen: () async {
                            if (menu.isOpen) {
                              await widget.controller.closeMenu(
                                hotelId: widget.hotelId,
                                menuId: menu.id,
                              );
                            } else {
                              await widget.controller.openMenu(
                                hotelId: widget.hotelId,
                                menuId: menu.id,
                              );
                            }
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openCreateMenu() async {
    final editorController = MenuEditorController(
      getMenuByIdUC: widget.getMenuByIdUC,
      createMenuUC: widget.createMenuUC,
      updateMenuUC: widget.updateMenuUC,
      hotelId: widget.hotelId,
    );

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MenuEditorPage(
          controller: editorController,
          hotelId: widget.hotelId,
          onSaved: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  Future<void> _openEditMenu(String menuId) async {
    final editorController = MenuEditorController(
      getMenuByIdUC: widget.getMenuByIdUC,
      createMenuUC: widget.createMenuUC,
      updateMenuUC: widget.updateMenuUC,
      hotelId: widget.hotelId,
    );

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MenuEditorPage(
          controller: editorController,
          hotelId: widget.hotelId,
          menuId: menuId,
          onSaved: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}