import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:menuhub/tester/test_menu/client_test_app.dart';
import 'package:menuhub/tester/test_menu/hotel_test_app.dart';
import 'firebase_option.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MainTestApp());
}

class MainTestApp extends StatelessWidget {
  const MainTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MenuHub Test Launcher',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const _TestModeSelectorPage(),
    );
  }
}

class _TestModeSelectorPage extends StatelessWidget {
  const _TestModeSelectorPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFEEF4FF),
              Color(0xFFF6F8FD),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.restaurant_menu,
                  size: 72,
                  color: Color(0xFF305AE3),
                ),
                const SizedBox(height: 20),
                const Text(
                  'MenuHub Tester',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Scegli quale lato dell’applicazione vuoi testare.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const ClientTestApp(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.smartphone_outlined),
                    label: const Text('Test lato Client'),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const HotelTestApp(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.apartment_outlined),
                    label: const Text('Test lato Hotel'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}