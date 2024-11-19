import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:myapp/providers/admin_provider.dart';
import 'package:myapp/providers/lost_objects_provider.dart';
import 'package:myapp/services/db_service.dart';
import 'package:myapp/utils/theme.dart';
import 'package:myapp/views/pages/home_page.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LostObjectsProvider()),
        ChangeNotifierProvider(create: (context) => AdminProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      initTheme: Themes.normalTheme,
      builder: (p0, theme) => MaterialApp(
        title: 'Objets perdus',
        debugShowCheckedModeBanner: false,
        theme: theme,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('fr', ''),
        ],
        home: FutureBuilder<Database>(
          future: initializeDB(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(child: Text('Erreur : ${snapshot.error}'));
              } else {
                return HomePage();
              }
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
