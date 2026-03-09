import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'application/use_cases/client/create_client_session_uc.dart';
import 'application/use_cases/client/place_order_uc.dart';

import 'application/repository/firebase_client_session_repository.dart';
import 'application/repository/firebase_order_repository.dart';
import 'local/client_session_local_repository.dart';

import 'presentation/client/pages/client_entry_page.dart';

import 'domain/menu_package/menu.dart';

void main() {
  runApp(const MenuHubApp());
}

class MenuHubApp extends StatelessWidget {
  const MenuHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance;

    final clientSessionRepository = FirebaseClientSessionRepository(firestore);
    final orderRepository = FirebaseOrderRepository(firestore);

    final createClientSessionUC = CreateClientSessionUC(clientSessionRepository);
    final placeOrderUC = PlaceOrderUC(orderRepository);

    final localSessionRepository = ClientSessionLocalRepository();

    final Menu testMenu = createTestMenu();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ClientEntryPage(
        menu: testMenu,
        placeOrderUC: placeOrderUC,
        createClientSessionUC: createClientSessionUC,
        localRepository: localSessionRepository,
      ),
    );
  }
}
