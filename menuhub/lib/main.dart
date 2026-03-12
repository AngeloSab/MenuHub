import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'application/repository/firebase_menu_repository.dart';
import 'application/use_cases/staff/close_menu_uc.dart';
import 'application/use_cases/staff/create_menu_uc.dart';
import 'application/use_cases/staff/get_menu_by_id_uc.dart';
import 'application/use_cases/staff/open_menu_uc.dart';
import 'application/use_cases/staff/watch_menus_by_hotel_uc.dart';
import 'firebase_option.dart';
import 'presentation/hotel/manager/controllers/menu_list_controller.dart';
import 'presentation/hotel/manager/pages/menu_list_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ManagerRefactorTestApp());
}

class ManagerRefactorTestApp extends StatelessWidget {
  const ManagerRefactorTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance;
    final menuRepository = FirebaseMenuRepository(firestore);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MenuHub Manager Refactor Test',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: MenuListPage(
        controller: MenuListController(
          watchMenusByHotelUC: WatchMenusByHotelUC(menuRepository),
          openMenuUC: OpenMenuUC(menuRepository),
          closeMenuUC: CloseMenuUC(menuRepository),
        ),
        hotelId: 'hotel_test_01',
        getMenuByIdUC: GetMenuByIdUC(menuRepository),
        createMenuUC: CreateMenuUC(menuRepository),
        updateMenuUC: CreateMenuUC(menuRepository),
      ),
    );
  }
}