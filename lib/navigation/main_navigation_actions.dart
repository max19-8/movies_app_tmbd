import 'package:flutter/material.dart';

import 'main_navigation_route_names.dart';

class MainNavigationActions {
  const MainNavigationActions();

   void resetNavigation(BuildContext context){
    Navigator.of(context).
    pushNamedAndRemoveUntil(MainNavigationRouteNames.loaderScreen,
            (route) => false);
  }
}