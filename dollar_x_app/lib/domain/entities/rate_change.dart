/// Representa el cambio de una tasa entre dos fechas.
class RateChange {
  /// Diferencia absoluta en Bs (actual - anterior).
  final double diff;

  /// Diferencia porcentual (diff / anterior * 100).
  final double percentage;

  const RateChange({required this.diff, required this.percentage});

  /// True si la tasa subi¢ respecto al d¡a anterior.
  bool get isPositive => diff > 0;

  /// True si la tasa baj¢ respecto al d¡a anterior.
  bool get isNegative => diff < 0;

  /// True si la tasa se mantuvo igual.
  bool get isNeutral => diff == 0;
}
