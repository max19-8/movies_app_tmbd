import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:movies_app_tmbd/domain/api_client/api_client_exception.dart';
import 'package:movies_app_tmbd/domain/blocs/auth_bloc.dart';

abstract class AuthViewCubitState {}

class AuthViewCubitFormFillInProgressState extends AuthViewCubitState {
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthViewCubitFormFillInProgressState &&
          runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class AuthViewCubitErrorState extends AuthViewCubitState {
  final String errorMessage;

  AuthViewCubitErrorState(this.errorMessage);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthViewCubitErrorState &&
          runtimeType == other.runtimeType &&
          errorMessage == other.errorMessage;

  @override
  int get hashCode => errorMessage.hashCode;
}

class AuthViewCubitAuthProgressState extends AuthViewCubitState {
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthViewCubitAuthProgressState &&
          runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class AuthViewCubitAuthSuccessAuthState extends AuthViewCubitState {
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthViewCubitAuthSuccessAuthState &&
          runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class AuthViewCubit extends Cubit<AuthViewCubitState> {
  final AuthBloc authBloc;
  late final StreamSubscription<AuthState> authBlocSubscription;

  AuthViewCubit(AuthViewCubitState initializeState, this.authBloc)
      : super(initializeState){

    _onState(authBloc.state);
    authBlocSubscription = authBloc.stream.listen(_onState);
  }
    bool _isValid(String login, String password) =>
        login.isNotEmpty && password.isNotEmpty;

    void auth({required String login, required String password}) async {
      if (!_isValid(login, password)) {
        final state = AuthViewCubitErrorState('Заполните поля  логин и пароль');
        emit(state);
        return;
      }
      authBloc.add(AuthLoginEvent(login: login, password: password));
    }


  void _onState(AuthState state) {
    if (state is AuthNoAuthorizedState) {
      emit(AuthViewCubitFormFillInProgressState());
    } else if (state is AuthAuthorizedState) {
      authBlocSubscription.cancel();
      emit(AuthViewCubitAuthSuccessAuthState());
    } else if (state is AuthFailureState) {
      final message = _mapErrorToMessage(state.error);
      final newState = AuthViewCubitErrorState(message);
      emit(newState);
    } else if (state is AuthInProgressState) {
      emit(AuthViewCubitAuthProgressState());
    }else if (state is AuthCheckStatusInProgressState) {
      emit(AuthViewCubitAuthProgressState());
    }
  }

  String _mapErrorToMessage(Object error) {
    if (error is! ApiClientException) {
      return '$error неизвестная ошибка попробуйте снова';
    }
    switch (error.type) {
      case ApiClientExceptionType.network:
        return 'Сервер недоступен, проверьте подключение к сети интернет';
      case ApiClientExceptionType.auth:
        return 'Неправильный логин или пароль';
      case ApiClientExceptionType.sessionExpired:
        return 'sessionExpired';
      case ApiClientExceptionType.other:
        return 'Произошла непредвиденная ошибка, пожалуйста попробуйте снова';
    }
  }

  @override
  Future<void> close() {
    authBlocSubscription.cancel();
    return super.close();
  }
}
//
// class AuthViewModel extends ChangeNotifier {
//   final _authService = AuthService();
//
//   final loginTextController = TextEditingController(text: 'kozyrev9797');
//   final passwordTextController = TextEditingController(text: '120197max');
//
//   String? _errorMessage;
//
//   String? get errorMessage => _errorMessage;
//
//   bool _isAuthProgress = false;
//
//   bool get canStartAuth => !_isAuthProgress;
//
//   bool get isAuthProgress => _isAuthProgress;
//
//   bool _isValid(String login, String password) =>
//       login.isNotEmpty && password.isNotEmpty;
//
//   Future<String?> _login(String login, String password) async {
//     try {
//       await _authService.login(login, password);
//     } on ApiClientException catch (e) {
//       switch (e.type) {
//         case ApiClientExceptionType.network:
//           return 'Сервер недоступен, проверьте подключение к сети интернет';
//         case ApiClientExceptionType.auth:
//           return 'Неправильный логин или пароль';
//         case ApiClientExceptionType.sessionExpired:
//           return 'sessionExpired';
//         case ApiClientExceptionType.other:
//           return 'Произошла непредвиденная ошибка, пожалуйста попробуйте снова';
//       }
//     } catch (e) {
//       return '$e неизвестная ошибка попробуйте снова';
//     }
//     return null;
//   }
//
//   Future<void> auth(BuildContext context) async {
//     final login = loginTextController.text;
//     final password = passwordTextController.text;
//
//     if (!_isValid(login, password)) {
//       _updateState('Заполните поля  логин и пароль', false);
//       return;
//     }
//
//     _updateState(null, true);
//
//     _errorMessage = await _login(login, password);
//
//     if (_errorMessage == null) {
//       MainNavigation.resetNavigation(context);
//     } else {
//       _updateState(_errorMessage, false);
//     }
//   }
//
//   void _updateState(String? errorMessage, bool isAuthProgress) {
//     if (_errorMessage == errorMessage && _isAuthProgress == isAuthProgress) {
//       return;
//     }
//     _errorMessage = errorMessage;
//     _isAuthProgress = isAuthProgress;
//     notifyListeners();
//   }
// }
