import 'package:flutter/material.dart';
import 'package:lashess_by_prii_app/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../providers/locale_provider.dart';
import '../../providers/theme_mode_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final themeModeProvider = Provider.of<ThemeModeProvider>(context);
    final theme = Theme.of(context);
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            t.languageLabel,
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              title: Text(t.languageLabel),
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
          ),
          const SizedBox(height: 24),
          Text(
            t.theme,
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              title: Text(t.themeMode),
              trailing: DropdownButton<ThemeMode>(
                value: themeModeProvider.themeMode,
                underline: const SizedBox(),
                onChanged: (mode) {
                  if (mode != null) {
                    themeModeProvider.setThemeMode(mode);
                  }
                },
                items: [
                  DropdownMenuItem(
                    value: ThemeMode.system,
                    child: Text(t.themeSystem),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.light,
                    child: Text(t.themeLight),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.dark,
                    child: Text(t.themeDark),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
