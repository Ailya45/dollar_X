import 'package:dollar_x_app/data/database/app_database.dart';
import 'package:dollar_x_app/presentation/constants/colors.dart';
import 'package:dollar_x_app/presentation/providers/repository_providers.dart';
import 'package:dollar_x_app/presentation/screens/home_screen.dart';
import 'package:dollar_x_app/presentation/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa la base de datos Drift
  final db = await AppDatabase.create();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.neutral,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(
    // Inyecta la base de datos en el ‡rbol de providers
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dollar X',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}
