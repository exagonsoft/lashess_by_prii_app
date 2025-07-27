import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lashess_by_prii_app/constants/api_config.dart';
import 'package:lashess_by_prii_app/interfaces/interfaces.dart';

class BusinessInfoScreen extends StatelessWidget {
  const BusinessInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Banner
            Stack(
              children: [
                Container(
                  height: size.height * 0.35,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/images/salon_banner.jpg'), // Tu imagen
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  height: size.height * 0.35,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.transparent
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: 20,
                  child: Text(
                    "Lashess by Prii",
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: const [
                        Shadow(blurRadius: 8, color: Colors.black)
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Section: Servicios
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader("💅 Servicios & Precios"),
                  const SizedBox(height: 12),
                  for (final service in services)
                    _buildExpandableServiceCard(service),
                ],
              ),
            ),

            // Section: Contacto
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader("📞 Contacto"),
                  const SizedBox(height: 12),
                  _buildContactCard(
                    icon: FontAwesomeIcons.whatsapp,
                    label: "WhatsApp",
                    value: "+598 92 123 456",
                    color: Colors.green.shade600,
                  ),
                  _buildContactCard(
                    icon: FontAwesomeIcons.instagram,
                    label: "Instagram",
                    value: "@lashess_by_prii",
                    color: Colors.purple,
                  ),
                  _buildContactCard(
                    icon: Icons.location_on,
                    label: "Ubicación",
                    value: "Montevideo, Uruguay",
                    color: Colors.redAccent,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.pinkAccent,
      ),
    );
  }

  Widget _buildExpandableServiceCard(ServiceInfo service) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        title: Text(service.name,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: Text(
          service.price,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        childrenPadding: const EdgeInsets.all(16),
        children: [
          Text(service.description, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: service.imagePaths.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    service.imagePaths[index],
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
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(label,
            style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        subtitle: Text(value),
        onTap: () {
          // TODO: Abrir link o acción
        },
      ),
    );
  }
}
