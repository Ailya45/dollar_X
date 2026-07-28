import 'package:dollar_x_app/presentation/constants/colors.dart';
import 'package:dollar_x_app/presentation/providers/rates_provider.dart';
import 'package:dollar_x_app/presentation/providers/ui_state_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Barra de navegacion entre fechas con flechas, texto de fecha y boton calendario.
class DateNavigationBar extends ConsumerWidget {
  const DateNavigationBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final hasPrev = ref.watch(hasPreviousDateProvider);
    final hasNext = ref.watch(hasNextDateProvider);
    final today = DateTime.now();
    final isToday = isSameDay(selectedDate, today);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _ArrowButton(
            icon: Icons.chevron_left_rounded,
            enabled: hasPrev.valueOrNull ?? false,
            onTap: () => ref
                .read(selectedDateProvider.notifier)
                .state = selectedDate.subtract(const Duration(days: 1)),
          ),
          const SizedBox(width: 8),
          _DateButton(
            date: selectedDate,
            isToday: isToday,
            onDateSelected: (picked) {
              ref.read(selectedDateProvider.notifier).state = picked;
            },
          ),
          const SizedBox(width: 8),
          _ArrowButton(
            icon: Icons.chevron_right_rounded,
            enabled: (hasNext.valueOrNull ?? false) && !isToday,
            onTap: () => ref
                .read(selectedDateProvider.notifier)
                .state = selectedDate.add(const Duration(days: 1)),
          ),
        ],
      ),
    );
  }
}

/// Boton de flecha (anterior / siguiente).
class _ArrowButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _ArrowButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: enabled
                ? Colors.white.withValues(alpha: 0.06)
                : Colors.white.withValues(alpha: 0.02),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: enabled
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.white.withValues(alpha: 0.03),
            ),
          ),
          child: Icon(
            icon,
            size: 22,
            color: enabled
                ? Colors.white.withValues(alpha: 0.7)
                : Colors.white.withValues(alpha: 0.15),
          ),
        ),
      ),
    );
  }
}

/// Boton de fecha que abre un DatePicker al pulsarlo.
class _DateButton extends StatelessWidget {
  final DateTime date;
  final bool isToday;
  final ValueChanged<DateTime> onDateSelected;

  const _DateButton({
    required this.date,
    required this.isToday,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final dayNames = ['Lun', 'Mar', 'Mie', 'Jue', 'Vie', 'Sab', 'Dom'];
    final months = [
      'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic',
    ];
    final dayName = dayNames[date.weekday - 1];
    final day = date.day;
    final month = months[date.month - 1];
    final year = date.year;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showDatePicker(context),
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: isToday
                ? const LinearGradient(
                    colors: [Color(0x33203A4F), Color(0x1A1A2D42)],
                  )
                : null,
            color: isToday ? null : Colors.white.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isToday
                  ? AppColors.primary.withValues(alpha: 0.25)
                  : Colors.white.withValues(alpha: 0.06),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.calendar_today_rounded,
                size: 16,
                color: isToday
                    ? AppColors.primary
                    : Colors.white.withValues(alpha: 0.5),
              ),
              const SizedBox(width: 8),
              Text(
                '$dayName $day $month $year',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isToday
                      ? AppColors.primary
                      : Colors.white.withValues(alpha: 0.7),
                  letterSpacing: 0.3,
                ),
              ),
              if (!isToday) ...[
                const SizedBox(width: 6),
                Icon(
                  Icons.close_rounded,
                  size: 14,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: AppColors.primary,
              ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      onDateSelected(picked);
    }
  }
}
