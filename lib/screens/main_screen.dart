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
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            activeIcon: const Icon(Icons.home_filled),
            label: 'Inicio',
            backgroundColor: colors.primary,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.location_city_outlined),
            activeIcon: const Icon(Icons.location_city),
            label: 'Sucursales',
            backgroundColor: colors.primary,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.car_rental_outlined),
            activeIcon: const Icon(Icons.car_rental),
            label: 'Carros',
            backgroundColor: colors.primary,
          ),
        ],
      ),
    );
  }
}