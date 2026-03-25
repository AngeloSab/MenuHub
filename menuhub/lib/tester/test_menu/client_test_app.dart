import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../application/repository/firebase_client_session_repository.dart';
import '../../application/repository/firebase_menu_repository.dart';
import '../../application/repository/firebase_order_repository.dart';
import '../../application/use_cases/client/create_client_session_uc.dart';
import '../../application/use_cases/client/get_open_menus_uc.dart';
import '../../application/use_cases/client/place_order_uc.dart';
import '../../local/client_session_local_repository.dart';
import '../../presentation/client/pages/client_entry_page.dart';

class ClientTestApp extends StatelessWidget {
  const ClientTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance;

    final menuRepository = FirebaseMenuRepository(firestore);
    final orderRepository = FirebaseOrderRepository(firestore);
    final clientSessionRepository = FirebaseClientSessionRepository(firestore);
    final clientSessionLocalRepository = ClientSessionLocalRepository();

    final getOpenMenusUC = GetOpenMenusUC(menuRepository);
    final createClientSessionUC =
    CreateClientSessionUC(clientSessionRepository);
    final placeOrderUC = PlaceOrderUC(orderRepository);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MenuHub Client Tester',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: ClientEntryPage(
        getOpenMenusUC: getOpenMenusUC,
        createClientSessionUC: createClientSessionUC,
        placeOrderUC: placeOrderUC,
        localRepository: clientSessionLocalRepository,
      ),
    );
  }
}