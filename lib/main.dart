import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_theme/json_theme.dart';
import 'package:qtronapp/AlarmSettings.dart';
import 'package:qtronapp/homepage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeStr = await rootBundle.loadString("assets/appainter_theme.json");
  final themJson = jsonDecode(themeStr);
  final theme = ThemeDecoder.decodeThemeData(themJson)!;
  runApp( MyApp(theme: theme,));
}

class MyApp extends StatelessWidget {
  final ThemeData theme;
  const MyApp({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme,
      home:  HomePage(),
    );
  }
}

