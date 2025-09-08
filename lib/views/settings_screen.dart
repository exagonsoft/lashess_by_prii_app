import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:lashess_by_prii_app/l10n/app_localizations.dart';
import 'package:lashess_by_prii_app/styles/app_colors.dart';
import 'package:lashess_by_prii_app/providers/locale_provider.dart';
import 'package:lashess_by_prii_app/providers/theme_mode_provider.dart';
import 'package:lashess_by_prii_app/services/auth_service.dart';
import 'base_screen_scafold.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    final localeProvider = context.watch<LocaleProvider>();
    final themeModeProvider = context.watch<ThemeModeProvider>();

    return BaseScaffold(
      currentIndex: 4,
      showBack: true,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            t.settings,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: isLight
                  ? AppColors.lightTextPrimary
                  : AppColors.darkTextPrimary,
            ),
          ),
          const SizedBox(height: 20),

          // 🔹 Account Section
          _SectionTitle(title: "Account"),
          _SettingsTile(
            icon: Icons.person_outline,
            title: "Edit Profile",
            onTap: () => context.pushNamed("profile"),
          ),
          _SettingsTile(
            icon: Icons.lock_outline,
            title: "Change Password",
            onTap: () {},
          ),

          const SizedBox(height: 24),

          // 🔹 Preferences Section
          _SectionTitle(title: "Preferences"),
          _SettingsTile(
            icon: Icons.language_outlined,
            title: t.languageLabel,
            trailing: DropdownButton<Locale>(
              value: localeProvider.locale ?? const Locale('es'),
              underline: const SizedBox(),
              onChanged: (locale) {
                if (locale != null) {
                  localeProvider.setLocale(locale);
                }
              },
              items: const [
                DropdownMenuItem(
                  value: Locale('en'),
                  child: Text('English'),
                ),
                DropdownMenuItem(
                  value: Locale('es'),
                  child: Text('Español'),
                ),
              ],
            ),
          ),
          _SettingsTile(
            icon: Icons.notifications_none,
            title: "Notifications",
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.dark_mode_outlined,
            title: "Dark Mode",
            trailing: Switch(
              value: themeModeProvider.themeMode == ThemeMode.dark,
              activeColor:
                  isLight ? AppColors.lightPrimary : AppColors.darkPrimary,
              onChanged: (enabled) {
                themeModeProvider.setThemeMode(
                  enabled ? ThemeMode.dark : ThemeMode.light,
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          // 🔹 Support Section
          _SectionTitle(title: "Support"),
          _SettingsTile(
            icon: Icons.support_agent,
            title: "Contact Us",
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.help_outline,
            title: "FAQs",
            trailing: Text(
              "Terms of Service",
              style: theme.textTheme.bodySmall?.copyWith(
                color: isLight
                    ? AppColors.lightTextSecondary
                    : AppColors.darkTextSecondary,
              ),
            ),
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.logout,
            title: "Log Out",
            onTap: () async {
              await AuthService().signOut();
              if (context.mounted) context.go('/auth');
            },
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: isLight
              ? AppColors.lightTextSecondary
              : AppColors.darkTextSecondary,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: isLight ? AppColors.lightCard : AppColors.darkCard,
      child: ListTile(
        leading: Icon(icon,
            color: isLight ? AppColors.lightPrimary : AppColors.darkPrimary),
        title: Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isLight
                ? AppColors.lightTextPrimary
                : AppColors.darkTextPrimary,
          ),
        ),
        trailing: trailing ??
            Icon(Icons.arrow_forward_ios,
                size: 16,
                color: isLight
                    ? AppColors.lightTextSecondary
                    : AppColors.darkTextSecondary),
        onTap: onTap,
      ),
    );
  }
}
