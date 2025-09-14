import 'package:flutter/material.dart';
import 'package:lashess_by_prii_app/widgets/custom_button_input.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:lashess_by_prii_app/styles/app_colors.dart';
import 'package:lashess_by_prii_app/views/base_screen_scafold.dart';
import 'package:lashess_by_prii_app/l10n/app_localizations.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  String? _selectedStylist;
  String? _selectedTime;

  final List<String> times = ["10:00 AM", "11:00 AM", "12:00 PM"];

  final Set<DateTime> reservedDates = {
    DateTime.utc(2025, 9, 10),
    DateTime.utc(2025, 9, 15),
    DateTime.utc(2025, 9, 20),
  };

  final Set<DateTime> scheduledDates = {
    DateTime.utc(2025, 9, 12),
    DateTime.utc(2025, 9, 18),
  };

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  void _bookAppointment() {
    if (_selectedDay == null ||
        _selectedStylist == null ||
        _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("⚠️ Please select date, stylist and time"),
        ),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("✅ Appointment booked on $_selectedDay")),
    );
  }

  void _bookAndPay() {
    _bookAppointment();
    // TODO: Navigate to payment screen
  }

  Widget _buildDayCell(DateTime day, Color bg, Color fg) {
    return Container(
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text('${day.day}', style: TextStyle(color: fg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return BaseScaffold(
      currentIndex: 1,
      showBack: true,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ✅ Expandable content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Calendar
                    Text(
                      t.selectDate,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TableCalendar(
                          firstDay: DateTime.now(),
                          lastDay: DateTime.utc(2030, 12, 31),
                          focusedDay: _focusedDay,
                          selectedDayPredicate: (day) =>
                              _selectedDay != null &&
                              _isSameDay(day, _selectedDay!),
                          onDaySelected: (selectedDay, focusedDay) {
                            if (!reservedDates
                                .any((d) => _isSameDay(d, selectedDay))) {
                              setState(() {
                                _selectedDay = selectedDay;
                                _focusedDay = focusedDay;
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("⚠️ This date is unavailable"),
                                ),
                              );
                            }
                          },
                          headerStyle: const HeaderStyle(
                            formatButtonVisible: false, // ✅ hide format button
                            titleCentered: true,
                          ),
                          calendarStyle: CalendarStyle(
                            outsideDaysVisible: false,
                            todayDecoration: BoxDecoration(
                              color: isLight
                                  ? AppColors.lightPrimary.withOpacity(0.4)
                                  : AppColors.darkPrimary.withOpacity(0.4),
                              shape: BoxShape.circle,
                            ),
                            selectedDecoration: BoxDecoration(
                              color: isLight
                                  ? AppColors.lightPrimary
                                  : AppColors.darkPrimary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          calendarBuilders: CalendarBuilders(
                            defaultBuilder: (context, day, focusedDay) {
                              if (reservedDates
                                  .any((d) => _isSameDay(d, day))) {
                                return _buildDayCell(
                                  day,
                                  AppColors.darkAccent,
                                  AppColors.darkTextPrimary,
                                );
                              }
                              if (scheduledDates
                                  .any((d) => _isSameDay(d, day))) {
                                return _buildDayCell(
                                  day,
                                  AppColors.lightAccent,
                                  AppColors.lightCard,
                                );
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Stylists
                    Text(
                      t.selectStylist,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _StylistCard(
                          name: "Emma",
                          image: "assets/images/stylist1.png",
                          isSelected: _selectedStylist == "Emma",
                          onTap: () =>
                              setState(() => _selectedStylist = "Emma"),
                        ),
                        _StylistCard(
                          name: "Sophia",
                          image: "assets/images/stylist2.png",
                          isSelected: _selectedStylist == "Sophia",
                          onTap: () =>
                              setState(() => _selectedStylist = "Sophia"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Time slots
                    Text(
                      t.selectTime,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      children: times.map((time) {
                        final isSelected = _selectedTime == time;
                        return ChoiceChip(
                          label: Text(time),
                          selected: isSelected,
                          onSelected: (_) => setState(
                            () => _selectedTime = isSelected ? null : time,
                          ),
                          selectedColor: isLight
                              ? AppColors.lightPrimary.withOpacity(0.2)
                              : AppColors.darkPrimary.withOpacity(0.2),
                          labelStyle: TextStyle(
                            color: isSelected
                                ? (isLight
                                    ? AppColors.lightPrimary
                                    : AppColors.darkPrimary)
                                : theme.textTheme.bodyMedium?.color,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            // ✅ Buttons pinned at bottom
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: t.book,
                    onPressed: _bookAppointment,
                    type: ButtonType.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    text: t.senar,
                    onPressed: _bookAndPay,
                    type: ButtonType.outlined,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StylistCard extends StatelessWidget {
  final String name;
  final String image;
  final bool isSelected;
  final VoidCallback onTap;

  const _StylistCard({
    required this.name,
    required this.image,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isSelected ? theme.colorScheme.primary : AppColors.lightDivider,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(image, height: 100, fit: BoxFit.cover),
            ),
            const SizedBox(height: 8),
            Text(name, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
