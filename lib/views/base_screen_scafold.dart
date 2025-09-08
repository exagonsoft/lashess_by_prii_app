import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:lashess_by_prii_app/l10n/app_localizations.dart';
import 'package:lashess_by_prii_app/providers/user_provider.dart';
import 'package:lashess_by_prii_app/styles/app_colors.dart';

class BaseScaffold extends StatelessWidget {
  final Widget body;
  final int currentIndex;
  final bool showAppBar;
  final bool showBack;

  const BaseScaffold({
    super.key,
    required this.body,
    required this.currentIndex,
    this.showAppBar = true,
    this.showBack = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    final user = context.watch<UserProvider>().user;
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor:
          isLight ? AppColors.lightBackground : AppColors.darkBackground,
      appBar: showAppBar
          ? AppBar(
              elevation: 0,
              scrolledUnderElevation: 2, // ✅ Prevents color change on scroll
              surfaceTintColor: Colors.transparent,
              backgroundColor: isLight
                  ? AppColors.lightBackground
                  : AppColors.darkBackground,
              automaticallyImplyLeading: false,
              leading: showBack
                  ? IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        color: isLight
                            ? AppColors.lightTextPrimary
                            : AppColors.darkTextPrimary,
                      ),
                      onPressed: () => context.canPop()
                          ? context.pop()
                          : context
                              .pushNamed('home'), // ✅ Safe pop with fallback
                    )
                  : null,
              title: const SizedBox.shrink(),
              actions: [
                PopupMenuButton<String>(
                  icon: CircleAvatar(
                    radius: 18,
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
                    if (value == "profile") {
                      context.pushNamed('profile'); // ✅ Navigate to profile
                    } else if (value == "logout") {
                      context.read<UserProvider>().signOut();
                      context.go('/auth');
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: "profile",
                      child: ListTile(
                        leading: Icon(Icons.account_box,
                            color: isLight
                                ? AppColors.lightTextSecondary
                                : AppColors.darkTextSecondary),
                        title: Text(
                          t.profile,
                          style: TextStyle(
                            color: isLight
                                ? AppColors.lightTextPrimary
                                : AppColors.darkTextPrimary,
                          ),
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      value: "logout",
                      child: ListTile(
                        leading: Icon(Icons.exit_to_app,
                            color: isLight
                                ? AppColors.lightTextSecondary
                                : AppColors.darkTextSecondary),
                        title: Text(
                          t.logout,
                          style: TextStyle(
                            color: isLight
                                ? AppColors.lightTextPrimary
                                : AppColors.darkTextPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          : null,
      body: body,
      bottomNavigationBar: currentIndex >= 0
          ? BottomNavigationBar(
              backgroundColor:
                  isLight ? AppColors.lightCard : AppColors.darkCard,
              currentIndex: currentIndex,
              onTap: (index) {
                switch (index) {
                  case 0:
                    context.pushNamed('home');
                    break;
                  case 1:
                    context.pushNamed('bookings');
                    break;
                  case 2:
                    context.pushNamed('info');
                    break;
                  case 3:
                    context.pushNamed('map');
                    break;
                  case 4:
                    context.pushNamed('settings');
                    break;
                }
              },
              type: BottomNavigationBarType.fixed,
              selectedItemColor:
                  isLight ? AppColors.lightPrimary : AppColors.darkPrimary,
              unselectedItemColor: isLight
                  ? AppColors.lightTextSecondary
                  : AppColors.darkTextSecondary,
              showUnselectedLabels: true,
              selectedLabelStyle:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
              items: [
                BottomNavigationBarItem(
                    icon: const Icon(Icons.home_filled), label: t.home),
                BottomNavigationBarItem(
                    icon: const Icon(Icons.calendar_today), label: t.schedule),
                BottomNavigationBarItem(
                    icon: const Icon(Icons.info), label: t.info),
                BottomNavigationBarItem(
                    icon: const Icon(Icons.map), label: t.map),
                BottomNavigationBarItem(
                    icon: const Icon(Icons.settings), label: t.settings),
              ],
            )
          : null,
    );
  }
}
