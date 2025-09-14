import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lashess_by_prii_app/styles/app_colors.dart';
import 'package:lashess_by_prii_app/views/base_screen_scafold.dart';
import '../models/offer.dart';

class OfferDetailsScreen extends StatelessWidget {
  final Offer offer;

  const OfferDetailsScreen({super.key, required this.offer});

  String _formatDate(DateTime? date) {
    if (date == null) return "-";
    return DateFormat("dd/MM/yyyy HH:mm").format(date);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return BaseScaffold(
      currentIndex: -1,
      showBack: true,
      body: Column(
        children: [
          /// 🔝 Top image with overlay title
          Stack(
            children: [
              if (offer.imageUrl.isNotEmpty)
                Image.network(
                  offer.imageUrl,
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                )
              else
                Container(
                  width: double.infinity,
                  height: 220,
                  color: isLight ? Colors.grey[200] : Colors.grey[800],
                  child: const Icon(Icons.image, size: 60, color: Colors.grey),
                ),

              Container(
                width: double.infinity,
                height: 220,
                color: Colors.black26,
              ),

              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Text(
                  offer.title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          /// 🔽 Offer details
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description
                  Text(
                    offer.description.isNotEmpty
                        ? offer.description
                        : "Sin descripción disponible",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: isLight
                          ? AppColors.lightTextPrimary
                          : AppColors.darkTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Status + order
                  Row(
                    children: [
                      Chip(
                        label: Text(offer.active ? "Activo" : "Inactivo"),
                        backgroundColor: offer.active
                            ? Colors.green.shade100
                            : Colors.red.shade100,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "Orden: ${offer.order}",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isLight
                              ? AppColors.lightTextSecondary
                              : AppColors.darkTextSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Type-specific info
                  if (offer.type == "discount" && offer.discount != null)
                    Text(
                      "🔥 Descuento: ${offer.discount}%",
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (offer.type == "date") ...[
                    Text(
                      "📅 Inicio: ${_formatDate(offer.startsAt)}",
                      style: theme.textTheme.bodySmall,
                    ),
                    Text(
                      "⏳ Fin: ${_formatDate(offer.endsAt)}",
                      style: theme.textTheme.bodySmall,
                    ),
                  ],

                  const SizedBox(height: 24),

                  // CTA button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Acción al usar oferta
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isLight
                            ? AppColors.lightPrimary
                            : AppColors.darkPrimary,
                        foregroundColor: AppColors.lightCard,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      icon: const Icon(Icons.local_offer),
                      label: const Text("Usar esta oferta"),
                    ),
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
