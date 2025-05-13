import 'package:syta_client/screens/home_screen.dart';
import 'package:syta_client/screens/locations_screen.dart';
import 'package:flutter/material.dart';
import 'package:syta_client/screens/user_cars.dart';
import 'package:syta_client/screens/user_info_display.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final screens = [const HomeScreen(), const LocationsScreen(), const UserScreen(), ];

    return Scaffold(

      body: IndexedStack(
        index: selectedIndex,
        children: screens,
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        currentIndex: selectedIndex,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        elevation: 0,
        selectedItemColor: const Color(0xFF1A1A77),
        unselectedItemColor: const Color(0xFF333333),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.directions_car),
            activeIcon: const Icon(Icons.directions_car_filled),
            label: 'Revisiones',
            backgroundColor: const Color(0xFFF5F5F5),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.store_outlined),
            activeIcon: const Icon(Icons.store),
            label: 'Sucursales',
            backgroundColor: const Color(0xFFF5F5F5),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.account_circle_outlined),
            activeIcon: const Icon(Icons.account_circle),
            label: 'Perfil',
            backgroundColor: const Color(0xFFF5F5F5),
          ),
        ],
      ),
    );
  }
}