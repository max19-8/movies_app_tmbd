import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:movies_app_tmbd/domain/api_client/api_client.dart';
import 'package:movies_app_tmbd/domain/data_providers/session_data_provider.dart';

import '../../navigation/main_navigation.dart';

class AuthModel extends ChangeNotifier {
  final _apiClient = ApiClient();
  final _sessionDataProvider = SessionDataProvider();

  final loginTextController = TextEditingController(text: 'kozyrev9797');
  final passwordTextController = TextEditingController(text: '120197max');

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isAuthProgress = false;
  bool get canStartAuth => !_isAuthProgress;
  bool get isAuthProgress => _isAuthProgress;

  Future<void> auth(BuildContext context) async {
    final login = loginTextController.text;
    final password = passwordTextController.text;

    if (login.isEmpty || password.isEmpty) {
      _errorMessage = 'Заполните поля  логин и пароль';
      notifyListeners();
      return;
    }
    _errorMessage = null;
    _isAuthProgress = true;
    notifyListeners();

    String? sessionID;
    int? accountID;

    try{
      sessionID = await _apiClient.auth(userName: login, password: password);
      accountID = await _apiClient.getAccountInfo(sessionID);
    }on ApiClientException catch(e){
      switch(e.type){
        case ApiClientExceptionType.network:
          _errorMessage = 'Сервер недоступен, проверьте подключение к сети интернет';
          break;
        case ApiClientExceptionType.auth:
          _errorMessage = 'Неправильный логин или пароль';
          break;
        case ApiClientExceptionType.other:
          _errorMessage = 'Произошла непредвиденная ошибка, пожалуйста попробуйте снова';
          break;
      }
    }
    _isAuthProgress = false;

    if(_errorMessage != null){
      notifyListeners();
      return;
    }

    if(sessionID == null || accountID == null){
      _errorMessage = 'неизвестная ошибка попробуйте снова';
      notifyListeners();
      return;
    }

   await _sessionDataProvider.setSessionId(sessionID);
   await _sessionDataProvider.setAccountId(accountID);
  unawaited(Navigator.of(context).pushReplacementNamed(MainNavigationRouteNames.mainScreen));
  }
}