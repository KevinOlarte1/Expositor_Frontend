import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'pages/dashboard_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa la configuración regional para español
  await initializeDateFormatting('es_ES', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Productos App',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: DashboardPage(),

      // 👇 Agregamos soporte para localización
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'), // 🇪🇸 Español
        Locale('en', 'US'), // 🇺🇸 Inglés (fallback)
      ],
      locale: const Locale('es', 'ES'), // Fuerza español por defecto
    );
  }
}
