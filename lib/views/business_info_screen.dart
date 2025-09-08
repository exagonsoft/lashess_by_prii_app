import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lashess_by_prii_app/constants/api_config.dart';
import 'package:lashess_by_prii_app/interfaces/interfaces.dart';
import 'package:lashess_by_prii_app/l10n/app_localizations.dart';
import 'package:lashess_by_prii_app/styles/app_colors.dart';
import 'package:lashess_by_prii_app/views/base_screen_scafold.dart';

class BusinessInfoScreen extends StatelessWidget {
  const BusinessInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    final isLight = theme.brightness == Brightness.light;

    return BaseScaffold(
      currentIndex: 2,
      showBack: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Hero Banner
            Stack(
              children: [
                Container(
                  height: size.height * 0.3,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/salon_banner.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  height: size.height * 0.3,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.5),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Text(
                    "Lashess by Prii",
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: const [
                        Shadow(blurRadius: 6, color: Colors.black54)
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ✅ Services Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                t.servicesAndPrices,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isLight
                      ? AppColors.lightTextSecondary
                      : AppColors.darkTextSecondary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  for (final service in services)
                    _ExpandableServiceCard(service: service, isLight: isLight),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ✅ Contact Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                t.contactUs,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isLight
                      ? AppColors.lightTextSecondary
                      : AppColors.darkTextSecondary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _ContactCard(
                    icon: FontAwesomeIcons.whatsapp,
                    label: "WhatsApp",
                    value: "+598 92 123 456",
                    color: Colors.green,
                    isLight: isLight,
                  ),
                  _ContactCard(
                    icon: FontAwesomeIcons.instagram,
                    label: "Instagram",
                    value: "@lashess_by_prii",
                    color: Colors.purple,
                    isLight: isLight,
                  ),
                  _ContactCard(
                    icon: Icons.location_on,
                    label: t.location,
                    value: "Montevideo, Uruguay",
                    color: Colors.redAccent,
                    isLight: isLight,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

/// ✅ Clean expandable card for services
class _ExpandableServiceCard extends StatefulWidget {
  final ServiceInfo service;
  final bool isLight;

  const _ExpandableServiceCard({
    required this.service,
    required this.isLight,
  });

  @override
  State<_ExpandableServiceCard> createState() => _ExpandableServiceCardState();
}

class _ExpandableServiceCardState extends State<_ExpandableServiceCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: widget.isLight ? AppColors.lightCard : AppColors.darkCard,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => setState(() => _expanded = !_expanded),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Header row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.service.name,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: widget.isLight
                          ? AppColors.lightTextPrimary
                          : AppColors.darkTextPrimary,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        widget.service.price,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: widget.isLight
                              ? AppColors.lightPrimary
                              : AppColors.darkPrimary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      AnimatedRotation(
                        turns: _expanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: widget.isLight
                              ? AppColors.lightTextSecondary
                              : AppColors.darkTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Expanded content
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.service.description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: widget.isLight
                              ? AppColors.lightTextSecondary
                              : AppColors.darkTextSecondary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (widget.service.imagePaths.isNotEmpty)
                        SizedBox(
                          height: 100,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.service.imagePaths.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 8),
                            itemBuilder: (context, index) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  widget.service.imagePaths[index],
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
                crossFadeState: _expanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 250),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ✅ Clean contact card
class _ContactCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool isLight;

  const _ContactCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.isLight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: isLight ? AppColors.lightCard : AppColors.darkCard,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.15),
          child: Icon(icon, color: color),
        ),
        title: Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: isLight
                ? AppColors.lightTextPrimary
                : AppColors.darkTextPrimary,
          ),
        ),
        subtitle: Text(
          value,
          style: theme.textTheme.bodySmall?.copyWith(
            color: isLight
                ? AppColors.lightTextSecondary
                : AppColors.darkTextSecondary,
          ),
        ),
        onTap: () {
          // TODO: Add action (launch WhatsApp, Instagram, maps)
        },
      ),
    );
  }
}
