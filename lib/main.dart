import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/storage/hive_service.dart';
import 'core/theme/app_theme.dart';
import 'features/app/presentation/phase2_screens.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.initialize();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Wash ERP',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const Phase2Home(),
    );
  }
}
