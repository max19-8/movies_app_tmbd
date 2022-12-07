import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:movies_app_tmbd/navigation/main_navigation_route_names.dart';
import 'ui/Theme/AppColors.dart';

abstract class MyAppNavigation{
  Map<String, Widget Function(BuildContext)> get routes;
  Route<Object> onGenerateRoute(RouteSettings settings);
}

class MyApp extends StatelessWidget {

  final  MyAppNavigation navigation;
  const MyApp({super.key, required this.navigation,});

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
        Locale('en', 'EN'),
      ],

      routes: navigation.routes,
      initialRoute: MainNavigationRouteNames.loaderScreen,
      onGenerateRoute: navigation.onGenerateRoute,
    );
  }
}