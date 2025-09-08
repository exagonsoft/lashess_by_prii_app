import 'package:flutter/material.dart';
import 'package:lashess_by_prii_app/styles/app_colors.dart';

class BookingButton extends StatelessWidget {
  final String time;

  const BookingButton(this.time, {super.key});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        backgroundColor: isLight
            ? AppColors.lightCard
            : AppColors.darkCard,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: Text(
        time,
        style: TextStyle(
          color: isLight ? AppColors.lightTextPrimary : AppColors.darkTextPrimary,
        ),
      ),
    );
  }
}
