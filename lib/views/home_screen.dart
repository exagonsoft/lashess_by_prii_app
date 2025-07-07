// ignore_for_file: unused_import, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/user_provider.dart';
import '../services/auth_service.dart';
import 'booking_screen.dart';
import 'main_screen.dart';
import 'business_info_screen.dart';
import 'map_screen.dart';
import 'settings_screen.dart';
import '../controllers/main_controller.dart';
import '../repositories/events_repository.dart';
import '../repositories/offers_repository.dart';
import '../repositories/styles_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Screens for navigation
  final List<Widget> _screens = [
    const MainScreen(),
    const BookingScreen(),
    const BusinessInfoScreen(),
    const MapScreen(),
    const SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<UserProvider>(context, listen: false).loadUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      backgroundColor: Colors.pink.shade100,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Lashess by Prii"),
        actions: [
          PopupMenuButton<String>(
            icon: CircleAvatar(
              backgroundImage: user?.photoURL != null
                  ? NetworkImage(user!.photoURL!)
                  : AssetImage("assets/images/default_user.png")
                      as ImageProvider,
            ),
            offset: Offset(0, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onSelected: (value) {
              if (value == "logout") {
                _logout(context);
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: "profile",
                child: ListTile(
                  leading: Icon(Icons.account_box, color: Colors.red),
                  title: Text("Profile"),
                ),
              ),
              PopupMenuItem(
                value: "logout",
                child: ListTile(
                  leading: Icon(Icons.exit_to_app, color: Colors.red),
                  title: Text("Logout"),
                ),
              ),
            ],
          ),
        ],
      ),
      body: _screens[_selectedIndex], // Show selected screen

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.pink.shade600,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "Schedule",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: "Info",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: "Map",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context) async {
    await AuthService().signOut();
    context.go('/auth'); // Redirect to Login
  }
}
