import 'package:dollar_x_app/Controller/MainPageController.dart';
import 'package:dollar_x_app/Utils/scrapperUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dollar_x_app/Constants/colors.dart';

double Dollar = 0.0;

Future<void> main() async {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final MainPageController _controller;
  late Future<String?> _tasaFuture;

  @override
  void initState() {
    super.initState();
    _controller = MainPageController(
      dollarController: TextEditingController(text: "1"),
      bsController: TextEditingController(),
    );
    _tasaFuture = _mostrarTasa();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<String?> _mostrarTasa() async {
    final precio = await ScrapperUtil.getDolarBcv();
    return precio?.toStringAsFixed(2);
  }

  Future<void> _copyToClipboardBs(BuildContext context) async {
    final textToCopy = _controller.bsController.text;
    if (textToCopy.isEmpty) return;

    try {
      await Clipboard.setData(ClipboardData(text: textToCopy));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Copiado al portapapeles"),
          backgroundColor: AppColors.tertiary,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error al copiar: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _copyToClipboardUSD(BuildContext context) async {
    final textToCopy = _controller.dollarController.text;
    if (textToCopy.isEmpty) return;

    try {
      await Clipboard.setData(ClipboardData(text: textToCopy));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Copiado al portapapeles"),
          backgroundColor: Colors.greenAccent,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error al copiar: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorSchemeSeed: AppColors.secondary,
        brightness: Brightness.dark,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: FutureBuilder<String?>(
            future: _tasaFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Cargando...");
              } else if (snapshot.hasError) {
                return const Text("Error al cargar");
              } else {
                Dollar = double.parse(snapshot.data ?? '0.0');
                return Text(
                  "Dollar X  Tasa: ${snapshot.data ?? 'N/A'}",
                  style: TextStyle(color: Colors.white),
                );
              }
            },
          ),
          backgroundColor: AppColors.secondary,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 30),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.neutral,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    Builder(
                      builder: (context) => TextField(
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'Dolar',
                          errorText: _controller.dollarError,
                          fillColor: Colors.red,
                          suffixIcon: IconButton(
                            onPressed: () => _copyToClipboardUSD(context),
                            icon: const Icon(Icons.copy),
                          ),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        controller: _controller.dollarController,
                        onChanged: (value) {
                          setState(() {
                            _validatorsUSD(value, _controller);
                            value = _controller.dollarController.text;
                            if (value.isNotEmpty) {
                              double newValue;
                              newValue = Dollar * (double.parse(value));
                              _controller.bsController.text = newValue
                                .toStringAsFixed(2);
                            }
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    Builder(
                      builder: (context) => TextField(
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'Bs',
                          errorText: _controller.bsError,
                          suffixIcon: IconButton(
                            onPressed: () => _copyToClipboardBs(context),
                            icon: const Icon(Icons.copy),
                          ),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        controller: _controller.bsController,
                        onChanged: (value) {
                          setState(() {
                            _validatorsBS(value, _controller);
                            value = _controller.bsController.text;
                            if (value.isNotEmpty) {
                              double newValue;
                              newValue = (double.parse(value)) / Dollar;
                              _controller.dollarController.text = newValue
                                  .toStringAsFixed(2);
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _validatorsUSD(String value, MainPageController controller) {
    // Agregado: detectar si es decimal con cero inicial
    bool hasDecimal = value.contains('.');
    bool startsWithZero = value.isNotEmpty && value[0] == '0';
    bool isDecimalWithLeadingZero = hasDecimal && startsWithZero;
    
    if ((value.length > 1) &&
        value[0].contains("0") &&
        !isDecimalWithLeadingZero) {  // ← Solo esta línea fue modificada
      controller.dollarController.text = controller.dollarController.text
          .replaceFirst("0", "");
      value = controller.dollarController.text;
    }
    if (value.isEmpty || controller.dollarController.text.isEmpty) {
      value = "0.00";
      controller.bsController.text = "0.00";
      controller.dollarController.text = "0.00";
      controller.dollarController.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.dollarController.text.length),
      );
    }
  }
  
  void _validatorsBS(String value, MainPageController controller) {
    // Agregado: detectar si es decimal con cero inicial
    bool hasDecimal = value.contains('.');
    bool startsWithZero = value.isNotEmpty && value[0] == '0';
    bool isDecimalWithLeadingZero = hasDecimal && startsWithZero;
    
    if ((value.length > 1) &&
        value[0].contains("0") &&
        !isDecimalWithLeadingZero) {  // ← Solo esta línea fue modificada
      controller.bsController.text = controller.bsController.text
          .replaceFirst("0", "");
      value = controller.bsController.text;
    }
    if (value.isEmpty || controller.bsController.text.isEmpty) {
      value = "0.00";
      controller.dollarController.text = "0.00";
      controller.bsController.text = "0.00";
      controller.bsController.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.bsController.text.length),
      );
    }
  }
}
