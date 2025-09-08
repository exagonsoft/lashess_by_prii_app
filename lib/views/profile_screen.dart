import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:lashess_by_prii_app/providers/user_provider.dart';
import 'package:lashess_by_prii_app/styles/app_colors.dart';
import 'package:lashess_by_prii_app/views/base_screen_scafold.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _showAppointments = false;

  // Dummy appointments – replace with DB fetch
  final List<Map<String, String>> _appointments = [
    {"date": "2025-09-10", "time": "10:00 AM", "service": "Lash Extension"},
    {"date": "2025-09-15", "time": "02:30 PM", "service": "Refill"},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    final user = context.watch<UserProvider>().user;

    return BaseScaffold(
      currentIndex: 4,
      showBack: true,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            // ✅ Avatar + Name (wrapped)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 44,
                  backgroundImage: user?.photoURL != null
                      ? NetworkImage(user!.photoURL!)
                      : const AssetImage("assets/images/default_user.png")
                          as ImageProvider,
                ),
                const SizedBox(width: 16),
                Flexible(
                  child: Text(
                    user?.displayName ?? "Guest",
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isLight
                          ? AppColors.lightTextPrimary
                          : AppColors.darkTextPrimary,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // ✅ Loyalty points card
            Card(
              color: isLight ? AppColors.lightCard : AppColors.darkCard,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Loyalty Points",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isLight
                                ? AppColors.lightTextPrimary
                                : AppColors.darkTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "120 points", // TODO: replace with DB value
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: isLight
                                ? AppColors.lightTextSecondary
                                : AppColors.darkTextSecondary,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.star,
                      color: isLight
                          ? AppColors.lightPrimary
                          : AppColors.darkPrimary,
                      size: 28,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // ✅ Toggle My Appointments
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                "My Appointments",
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: isLight
                      ? AppColors.lightTextPrimary
                      : AppColors.darkTextPrimary,
                ),
              ),
              trailing: Icon(
                _showAppointments
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: isLight
                    ? AppColors.lightTextSecondary
                    : AppColors.darkTextSecondary,
              ),
              onTap: () {
                setState(() => _showAppointments = !_showAppointments);
              },
            ),
            if (_showAppointments)
              ..._appointments.map((appt) {
                return ListTile(
                  contentPadding: const EdgeInsets.only(left: 20),
                  leading: Icon(
                    Icons.calendar_today,
                    color: isLight
                        ? AppColors.lightPrimary
                        : AppColors.darkPrimary,
                  ),
                  title: Text(
                    appt["service"]!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isLight
                          ? AppColors.lightTextPrimary
                          : AppColors.darkTextPrimary,
                    ),
                  ),
                  subtitle: Text(
                    "${appt["date"]} at ${appt["time"]}",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isLight
                          ? AppColors.lightTextSecondary
                          : AppColors.darkTextSecondary,
                    ),
                  ),
                );
              }),
            Divider(
              color: isLight ? AppColors.lightDivider : AppColors.darkDivider,
            ),

            // ✅ Payment Methods link
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                "Payment Methods",
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: isLight
                      ? AppColors.lightTextPrimary
                      : AppColors.darkTextPrimary,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: isLight
                    ? AppColors.lightTextSecondary
                    : AppColors.darkTextSecondary,
              ),
              onTap: () {
                context.pushNamed('payments');
              },
            ),
          ],
        ),
      ),
    );
  }
}
