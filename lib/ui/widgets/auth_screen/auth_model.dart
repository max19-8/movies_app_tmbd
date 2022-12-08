import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:movies_app_tmbd/data/api_client/api_client_exception.dart';
import 'package:movies_app_tmbd/navigation/main_navigation_actions.dart';

abstract class AuthViewModelLoginProvider{
  Future<void> login(String login,String password);
}

class AuthViewModel extends ChangeNotifier {
  final MainNavigationActions mainNavigationActions;
  final AuthViewModelLoginProvider loginProvider;

  final loginTextController = TextEditingController(text: 'kozyrev9797');
  final passwordTextController = TextEditingController(text: '120197max');

  String? _errorMessage;

  AuthViewModel({required this.mainNavigationActions, required this.loginProvider});

  String? get errorMessage => _errorMessage;

  bool _isAuthProgress = false;

  bool get canStartAuth => !_isAuthProgress;

  bool get isAuthProgress => _isAuthProgress;

  bool _isValid(String login, String password) =>
      login.isNotEmpty && password.isNotEmpty;

  Future<String?> _login(String login, String password) async {
    try {
      await loginProvider.login(login, password);
    } on ApiClientException catch (e) {
      switch (e.type) {
        case ApiClientExceptionType.network:
          return 'Сервер недоступен, проверьте подключение к сети интернет';
        case ApiClientExceptionType.auth:
          return 'Неправильный логин или пароль';
        case ApiClientExceptionType.sessionExpired:
        case ApiClientExceptionType.other:
          return 'Произошла непредвиденная ошибка, пожалуйста попробуйте снова';
      }
    } catch (e) {
      return '$e неизвестная ошибка попробуйте снова';
    }
    return null;
  }

  Future<void> auth(BuildContext context) async {
    final login = loginTextController.text;
    final password = passwordTextController.text;

    if (!_isValid(login, password)) {
      _updateState('Заполните поля  логин и пароль', false);
      return;
    }

    _updateState(null, true);

    _errorMessage = await _login(login, password);

    if (_errorMessage == null) {
      mainNavigationActions.resetNavigation(context);
    } else {
      _updateState(_errorMessage, false);
    }
  }

  void _updateState(String? errorMessage, bool isAuthProgress) {
    if (_errorMessage == errorMessage && _isAuthProgress == isAuthProgress) {
      return;
    }
    _errorMessage = errorMessage;
    _isAuthProgress = isAuthProgress;
    notifyListeners();
  }
}
