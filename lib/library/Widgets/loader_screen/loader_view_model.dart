import 'package:flutter/material.dart';
import 'package:movies_app_tmbd/domain/services/auth_service.dart';
import 'package:movies_app_tmbd/navigation/main_navigation.dart';

class LoaderViewModel {
  final BuildContext context;
  final authService = AuthService();

  LoaderViewModel(this.context) {
    asyncInit();
  }

  Future<void> asyncInit() async {
    await checkAuth();
  }

  Future<void> checkAuth() async {
    final isAuth =  await authService.isAuth();
    final nextScreen = isAuth ? MainNavigationRouteNames.mainScreen : MainNavigationRouteNames.auth;
    Navigator.of(context).pushReplacementNamed(nextScreen);
  }
}
