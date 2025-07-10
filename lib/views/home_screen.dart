import 'package:flutter/material.dart';
import 'package:lashess_by_prii_app/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/user_provider.dart';
import '../services/auth_service.dart';
import 'booking_screen.dart';
import 'main_screen.dart';
import 'business_info_screen.dart';
import 'map_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    MainScreen(),
    BookingScreen(),
    BusinessInfoScreen(),
    MapScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<UserProvider>(context, listen: false).loadUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    final t = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context); // ✅ Use resolved ThemeData

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          t.appTitle,
          style: theme.appBarTheme.titleTextStyle ??
              TextStyle(
                color: theme.textTheme.bodyLarge?.color,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: CircleAvatar(
              backgroundImage: user?.photoURL != null
                  ? NetworkImage(user!.photoURL!)
                  : const AssetImage("assets/images/default_user.png")
                      as ImageProvider,
            ),
            offset: const Offset(0, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onSelected: (value) {
              if (value == "logout") _logout(context);
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: "profile",
                child: ListTile(
                  leading:
                      Icon(Icons.account_box, color: theme.iconTheme.color),
                  title: Text(t.profile),
                ),
              ),
              PopupMenuItem(
                value: "logout",
                child: ListTile(
                  leading:
                      Icon(Icons.exit_to_app, color: theme.iconTheme.color),
                  title: Text(t.logout),
                ),
              ),
            ],
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        selectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: t.home),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: t.schedule),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: t.info),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: t.map),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: t.settings),
        ],
      ),
    );
  }

  void _logout(BuildContext context) async {
    await AuthService().signOut();
    context.go('/auth');
  }
}
