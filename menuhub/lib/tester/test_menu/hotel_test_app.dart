import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../application/repository/firebase_menu_repository.dart';
import '../../application/repository/firebase_order_repository.dart';
import '../../application/use_cases/staff/archive_menu_uc.dart';
import '../../application/use_cases/staff/close_menu_uc.dart';
import '../../application/use_cases/staff/create_menu_uc.dart';
import '../../application/use_cases/staff/delete_menu_uc.dart';
import '../../application/use_cases/staff/get_menu_by_id_uc.dart';
import '../../application/use_cases/staff/get_menu_orders_count_uc.dart';
import '../../application/use_cases/staff/open_menu_uc.dart';
import '../../application/use_cases/staff/watch_menus_by_hotel_uc.dart';
import '../../presentation/hotel/manager/controllers/menu_list_controller.dart';
import '../../presentation/hotel/manager/pages/menu_list_page.dart';

class HotelTestApp extends StatelessWidget {
  const HotelTestApp({super.key});

  static const String testHotelId = 'hotel_test_01';

  @override
  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance;

    final menuRepository = FirebaseMenuRepository(firestore);
    final orderRepository = FirebaseOrderRepository(firestore);

    final controller = MenuListController(
      watchMenusByHotelUC: WatchMenusByHotelUC(menuRepository),
      openMenuUC: OpenMenuUC(menuRepository),
      closeMenuUC: CloseMenuUC(menuRepository),
      deleteMenuUC: DeleteMenuUC(menuRepository),
      archiveMenuUC: ArchiveMenuUC(menuRepository),
      getMenuOrdersCountUC: GetMenuOrdersCountUC(orderRepository),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MenuHub Hotel Tester',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: MenuListPage(
        controller: controller,
        hotelId: testHotelId,
        getMenuByIdUC: GetMenuByIdUC(menuRepository),
        createMenuUC: CreateMenuUC(menuRepository),
        updateMenuUC: CreateMenuUC(menuRepository),
      ),
    );
  }
}