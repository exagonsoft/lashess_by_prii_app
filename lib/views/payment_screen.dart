import 'package:flutter/material.dart';
import 'package:lashess_by_prii_app/styles/app_colors.dart';
import 'package:lashess_by_prii_app/views/base_screen_scafold.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  // Dummy payment methods – replace with real DB
  final List<Map<String, String>> _methods = const [
    {"type": "Visa", "last4": "1234"},
    {"type": "Mastercard", "last4": "5678"},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return BaseScaffold(
      currentIndex: -1,
      showBack: true,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Payment Methods",
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: isLight
                    ? AppColors.lightTextPrimary
                    : AppColors.darkTextPrimary,
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: _methods.length,
                itemBuilder: (context, index) {
                  final method = _methods[index];
                  return Card(
                    color: isLight ? AppColors.lightCard : AppColors.darkCard,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.credit_card,
                        color: isLight
                            ? AppColors.lightPrimary
                            : AppColors.darkPrimary,
                      ),
                      title: Text(
                        method["type"]!,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: isLight
                              ? AppColors.lightTextPrimary
                              : AppColors.darkTextPrimary,
                        ),
                      ),
                      subtitle: Text(
                        "•••• ${method["last4"]}",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isLight
                              ? AppColors.lightTextSecondary
                              : AppColors.darkTextSecondary,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: isLight
                              ? AppColors.lightTextSecondary
                              : AppColors.darkTextSecondary,
                        ),
                        onPressed: () {
                          // TODO: implement remove card
                        },
                      ),
                    ),
                  );
                },
              ),
            ),

            ElevatedButton.icon(
              onPressed: () {
                // TODO: implement add new card
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isLight ? AppColors.lightPrimary : AppColors.darkPrimary,
                foregroundColor: AppColors.lightCard,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              icon: const Icon(Icons.add),
              label: const Text("Add Payment Method"),
            ),
          ],
        ),
      ),
    );
  }
}
