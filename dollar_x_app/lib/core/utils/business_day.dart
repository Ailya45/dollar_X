/// Utilidades para tratar fechas h biles (lunes-viernes).
///
/// El BCV s¢lo publica tasas de lunes a viernes. Los s bados y domingos
/// "heredan" el precio del viernes, por lo que usamos este helper para:
/// - Determinar la fecha h bil "oficial" de una tasa ([getEffectiveRateDate]).
/// - Mover entre d¡as h biles (salta el fin de semana).
/// - Formatear y parsear fechas en formato SQL YYYY-MM-DD.
library;

/// Indica si [date] es un d¡a h bil (lunes a viernes).
bool isBusinessDay(DateTime date) => date.weekday <= 5;

/// Retorna el `ltimo d¡a h bil <= [date]`.
///
/// Si [date] es sabado o domingo, retrocede hasta el viernes anterior.
/// Las fechas de lunes a viernes se devuelven tal cual.
DateTime getEffectiveRateDate(DateTime date) {
  var result = DateTime(date.year, date.month, date.day);
  while (!isBusinessDay(result)) {
    result = result.subtract(const Duration(days: 1));
  }
  return result;
}

/// Retorna el d¡a h bil anterior a [date], saltando el fin de semana.
/// Ejemplo: lunes -> viernes, viernes -> jueves.
DateTime previousBusinessDay(DateTime date) {
  var result = DateTime(date.year, date.month, date.day)
      .subtract(const Duration(days: 1));
  while (!isBusinessDay(result)) {
    result = result.subtract(const Duration(days: 1));
  }
  return result;
}

/// Retorna el d¡a h bil siguiente a [date], saltando el fin de semana.
/// Ejemplo: viernes -> lunes, s bado -> lunes.
DateTime nextBusinessDay(DateTime date) {
  var result = DateTime(date.year, date.month, date.day)
      .add(const Duration(days: 1));
  while (!isBusinessDay(result)) {
    result = result.add(const Duration(days: 1));
  }
  return result;
}

/// Formatea una fecha como YYYY-MM-DD (formato usado en la base de datos).
String formatSqlDate(DateTime date) {
  return '${date.year}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}

/// Parsea una fecha YYYY-MM-DD a [DateTime], o `null` si no es v lida.
DateTime? parseSqlDate(String value) => DateTime.tryParse(value);

/// Indica si dos fechas son el mismo d¡a (sin importar la hora).
bool isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}
