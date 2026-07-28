import 'package:dollar_x_app/domain/entities/currency_type.dart';
import 'package:dollar_x_app/presentation/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Chip que muestra la tasa actual de la moneda seleccionada en el AppBar.
/// Recibe el rate directamente para evitar depender de un provider espec¡fico.
class RateChip extends StatelessWidget {
  final AsyncValue<double?> rateAsync;
  final CurrencyType selectedCurrency;
  final VoidCallback onRefresh;

  const RateChip({
    super.key,
    required this.rateAsync,
    required this.selectedCurrency,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return rateAsync.when(
      loading: () => _buildChip(
        color: Colors.white.withValues(alpha: 0.15),
        label: 'Cargando...',
        icon: Icons.hourglass_top_rounded,
        showRefresh: false,
      ),
      error: (_, _) => _buildChip(
        color: AppColors.error.withValues(alpha: 0.2),
        label: 'Error al cargar',
        icon: Icons.error_outline_rounded,
        showRefresh: true,
      ),
      data: (rate) {
        if (rate == null || rate <= 0) {
          return _buildChip(
            color: AppColors.error.withValues(alpha: 0.2),
            label: 'Error al cargar',
            icon: Icons.error_outline_rounded,
            showRefresh: true,
          );
        }
        return _buildChip(
          color: AppColors.success.withValues(alpha: 0.15),
          label: 'Bs ${rate.toStringAsFixed(2)} / ${selectedCurrency.code}',
          icon: Icons.trending_up_rounded,
          showRefresh: true,
        );
      },
    );
  }

  Widget _buildChip({
    required Color color,
    required String label,
    required IconData icon,
    required bool showRefresh,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white.withValues(alpha: 0.7)),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.85),
              letterSpacing: 0.3,
            ),
          ),
          if (showRefresh) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onRefresh,
              child: Icon(
                Icons.refresh_rounded,
                size: 16,
                color: AppColors.primary.withValues(alpha: 0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
