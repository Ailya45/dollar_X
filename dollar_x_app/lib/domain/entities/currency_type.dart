import 'package:flutter/material.dart';

enum CurrencyType { usd, eur, usdt }

extension CurrencyTypeExtension on CurrencyType {
  String get code {
    switch (this) {
      case CurrencyType.usd:
        return 'USD';
      case CurrencyType.eur:
        return 'EUR';
      case CurrencyType.usdt:
        return 'USDT';
    }
  }

  String get label {
    switch (this) {
      case CurrencyType.usd:
        return 'Dólares';
      case CurrencyType.eur:
        return 'Euros';
      case CurrencyType.usdt:
        return 'USDT';
    }
  }

  IconData get icon {
    switch (this) {
      case CurrencyType.usd:
        return Icons.attach_money;
      case CurrencyType.eur:
        return Icons.euro_rounded;
      case CurrencyType.usdt:
        return Icons.currency_bitcoin;
    }
  }
}
