import 'package:dollar_x_app/domain/entities/currency_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Estos exports permiten que otros archivos accedan a CurrencyType y
// TextEditingController sin necesidad de imports adicionales.

// -----------------------------------------------------------------------------
// Estado de UI compartido entre widgets
// -----------------------------------------------------------------------------

/// Fecha seleccionada actualmente para visualizar tasas.
final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

/// Moneda seleccionada en el selector de divisas.
final selectedCurrencyProvider = StateProvider<CurrencyType>((ref) => CurrencyType.usd);

/// Controlador del campo de texto para la moneda de origen (USD/EUR/USDT).
final dollarControllerProvider = Provider.autoDispose<TextEditingController>((ref) {
  return TextEditingController(text: '1');
});

/// Controlador del campo de texto para Bol¡vares.
final bsControllerProvider = Provider.autoDispose<TextEditingController>((ref) {
  return TextEditingController();
});
