import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'application/repository/firebase_order_repository.dart';
import 'domain/order_package/order.dart' as domain;
import 'domain/order_package/order_status.dart';
import 'firebase_option.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: OrderRepositoryTestPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class OrderRepositoryTestPage extends StatefulWidget {
  const OrderRepositoryTestPage({super.key});

  @override
  State<OrderRepositoryTestPage> createState() => _OrderRepositoryTestPageState();
}

class _OrderRepositoryTestPageState extends State<OrderRepositoryTestPage> {
  late final FirebaseOrderRepository repo;

  final ValueNotifier<String> log = ValueNotifier<String>("");

  StreamSubscription<List<domain.Order>>? menuOrdersSub;
  StreamSubscription<List<domain.Order>>? clientOrdersSub;

  final String hotelId = "hotel_test_01";
  final String menuId = "menu_test_01";
  final String clientId = "client_test_01";

  @override
  void initState() {
    super.initState();
    repo = FirebaseOrderRepository(FirebaseFirestore.instance);
  }

  @override
  void dispose() {
    menuOrdersSub?.cancel();
    clientOrdersSub?.cancel();
    log.dispose();
    super.dispose();
  }

  void _append(String message) {
    final previous = log.value;
    log.value = previous.isEmpty ? message : "$previous\n$message";
  }

  domain.Order _buildTestOrder(String orderId) {
    return domain.Order(
      id: orderId,
      hotelId: hotelId,
      clientId: clientId,
      menuId: menuId,
      status: OrderStatus.confirmed,
      selections: const {
        "course_1": ["dish_a", "dish_b"],
        "course_2": ["dish_c"],
      },
    );
  }

  String _statusLabel(OrderStatus status) {
    switch (status) {
      case OrderStatus.confirmed:
        return "confirmed";
      case OrderStatus.received:
        return "received";
    }
  }

  Future<void> _saveOrder() async {
    try {
      final orderId = DateTime.now().millisecondsSinceEpoch.toString();
      final order = _buildTestOrder(orderId);

      await repo.save(order);

      _append(
        "✅ Salvato ordine: id=${order.id} hotelId=${order.hotelId} menuId=${order.menuId} status=${_statusLabel(order.status)}",
      );
    } catch (e) {
      _append("❌ Errore save(order): $e");
    }
  }

  Future<void> _readOrdersByMenu() async {
    try {
      final orders = await repo.getByMenu(
        hotelId: hotelId,
        menuId: menuId,
      );

      _append("📚 Letti ${orders.length} ordini per menuId=$menuId");

      for (final order in orders) {
        _append(
          "- orderId=${order.id} clientId=${order.clientId} status=${_statusLabel(order.status)} selections=${order.selections}",
        );
      }
    } catch (e) {
      _append("❌ Errore getByMenu: $e");
    }
  }

  Future<void> _readOrdersByClient() async {
    try {
      final orders = await repo.getByClient(
        hotelId: hotelId,
        clientId: clientId,
      );

      _append("👤 Letti ${orders.length} ordini per clientId=$clientId");

      for (final order in orders) {
        _append(
          "- orderId=${order.id} menuId=${order.menuId} status=${_statusLabel(order.status)}",
        );
      }
    } catch (e) {
      _append("❌ Errore getByClient: $e");
    }
  }

  Future<void> _markLastOrderAsReceived() async {
    try {
      final orders = await repo.getByMenu(
        hotelId: hotelId,
        menuId: menuId,
      );

      if (orders.isEmpty) {
        _append("⚠️ Nessun ordine da aggiornare.");
        return;
      }

      final lastOrder = orders.last;

      await repo.updateStatus(
        hotelId: hotelId,
        menuId: menuId,
        orderId: lastOrder.id,
        status: OrderStatus.received,
      );

      _append("📩 Ordine aggiornato a received: id=${lastOrder.id}");
    } catch (e) {
      _append("❌ Errore updateStatus: $e");
    }
  }

  void _startWatchByMenu() {
    menuOrdersSub?.cancel();

    _append("👀 Avvio watchByMenu(hotelId=$hotelId, menuId=$menuId)...");

    menuOrdersSub = repo.watchByMenu(
      hotelId: hotelId,
      menuId: menuId,
    ).listen(
          (orders) {
        _append("🔄 Stream menu update: ${orders.length} ordini");
      },
      onError: (e) {
        _append("❌ Stream watchByMenu error: $e");
      },
    );
  }

  Future<void> _stopWatchByMenu() async {
    await menuOrdersSub?.cancel();
    menuOrdersSub = null;
    _append("⏹️ WatchByMenu fermato.");
  }

  void _startWatchByClient() {
    clientOrdersSub?.cancel();

    _append("👀 Avvio watchByClient(hotelId=$hotelId, clientId=$clientId)...");

    clientOrdersSub = repo.watchByClient(
      hotelId: hotelId,
      clientId: clientId,
    ).listen(
          (orders) {
        _append("👤 Stream client update: ${orders.length} ordini");
      },
      onError: (e) {
        _append("❌ Stream watchByClient error: $e");
      },
    );
  }

  Future<void> _stopWatchByClient() async {
    await clientOrdersSub?.cancel();
    clientOrdersSub = null;
    _append("⏹️ WatchByClient fermato.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test Order Status Management"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ElevatedButton(
                  onPressed: _saveOrder,
                  child: const Text("1) Salva ordine test"),
                ),
                ElevatedButton(
                  onPressed: _readOrdersByMenu,
                  child: const Text("2) Leggi ordini per menu"),
                ),
                ElevatedButton(
                  onPressed: _readOrdersByClient,
                  child: const Text("3) Leggi ordini per client"),
                ),
                ElevatedButton(
                  onPressed: _markLastOrderAsReceived,
                  child: const Text("4) Segna ultimo come received"),
                ),
                ElevatedButton(
                  onPressed: _startWatchByMenu,
                  child: const Text("5) Avvia watch menu"),
                ),
                ElevatedButton(
                  onPressed: _stopWatchByMenu,
                  child: const Text("6) Ferma watch menu"),
                ),
                ElevatedButton(
                  onPressed: _startWatchByClient,
                  child: const Text("7) Avvia watch client"),
                ),
                ElevatedButton(
                  onPressed: _stopWatchByClient,
                  child: const Text("8) Ferma watch client"),
                ),
                OutlinedButton(
                  onPressed: () => log.value = "",
                  child: const Text("Pulisci log"),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ValueListenableBuilder<String>(
                valueListenable: log,
                builder: (_, value, __) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        value.isEmpty ? "Log vuoto" : value,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}