import 'package:flutter/material.dart';
import 'pages/dashboard_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Productos App',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: DashboardPage(),
    );
  }
}
