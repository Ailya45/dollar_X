import 'package:dollar_x_app/domain/entities/rate_change.dart';
import 'package:dollar_x_app/presentation/constants/colors.dart';
import 'package:dollar_x_app/presentation/providers/rate_change_provider.dart';
import 'package:dollar_x_app/presentation/providers/ui_state_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Muestra cu nto subi¢ o baj¢ la tasa de la moneda seleccionada
/// respecto al d¡a anterior (Bs y porcentaje).
class RateChangeIndicator extends ConsumerWidget {
  const RateChangeIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(selectedCurrencyProvider);
    final changesAsync = ref.watch(rateChangeProvider);
    final change = changesAsync.valueOrNull?[currency];

    if (change == null) return const SizedBox.shrink();

    return _buildIndicator(change);
  }

  Widget _buildIndicator(RateChange change) {
    final Color color;
    final IconData icon;
    final String prefix;
    final String directionText;

    if (change.isNeutral) {
      color = Colors.white.withValues(alpha: 0.4);
      icon = Icons.remove_rounded;
      prefix = '';
      directionText = 'Manteniendo';
    } else if (change.isPositive) {
      color = AppColors.success;
      icon = Icons.trending_up_rounded;
      prefix = '+';
      directionText = 'Subiendo';
    } else {
      color = AppColors.error;
      icon = Icons.trending_down_rounded;
      prefix = '';
      directionText = 'Bajando';
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Text(
            directionText,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 1,
            height: 16,
            color: Colors.white.withValues(alpha: 0.1),
          ),
          const SizedBox(width: 8),
          Text(
            '$prefix${change.diff.toStringAsFixed(2)} Bs',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '($prefix${change.percentage.toStringAsFixed(2)}%)',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
