import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Proveedor de utilidad para copiar texto al portapapeles.
/// No es un provider de estado, sino una funci¢n helper.
class ClipboardProvider {
  /// Copia [text] al portapapeles y muestra un SnackBar.
  static Future<void> copy(BuildContext context, String text) async {
    if (text.isEmpty) return;
    try {
      await Clipboard.setData(ClipboardData(text: text));
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Copiado al portapapeles'),
          backgroundColor: Colors.greenAccent,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al copiar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
