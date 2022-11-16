import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'Theme/AppColors.dart';
import 'navigation/main_navigation.dart';

class MyApp extends StatelessWidget {

  static final navigation = MainNavigation();
  const MyApp({super.key,}
  );
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
        appBarTheme: const AppBarTheme(backgroundColor: AppColors.mainDarkBlue,centerTitle: true),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: AppColors.mainDarkBlue,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.green
        ),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales:const  [
        Locale('ru', 'RU'),
        Locale('en', ''),
      ],

      routes: navigation.routes,
      initialRoute: MainNavigationRouteNames.loaderScreen,
      onGenerateRoute: navigation.onGenerateRoute,
    );
  }
}