// import 'package:flutter/material.dart';
// import 'package:flutter_apps/features/movies/data/models/movie_hive_model.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:hive_flutter/hive_flutter.dart';
//
// import 'core/router/app_router.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   await Hive.initFlutter();
//   //await Hive.openBox('movies');
//   Hive.registerAdapter(MovieHiveModelAdapter());
//
//   runApp(const ProviderScope(child: MyApp()));
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp.router(
//       debugShowCheckedModeBanner: false,
//       routerConfig: appRouter,
//       theme: ThemeData.dark(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_apps/core/theme/app_theme.dart';
import 'package:flutter_apps/features/movies/data/models/movie_hive_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(MovieHiveModelAdapter());
  }

  try {
    await Hive.openBox<MovieHiveModel>('movies_box');
  } catch (e) {
    debugPrint('Hive openBox error: $e');
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData.light(),
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
    );
  }
}
