import 'package:movies_app_tmbd/data/api_client/account_api_client.dart';
import 'package:movies_app_tmbd/data/api_client/auth_api_client.dart';
import 'package:movies_app_tmbd/domain/data_providers/session_data_provider.dart';
import 'package:movies_app_tmbd/ui/widgets/auth_screen/auth_model.dart';
import 'package:movies_app_tmbd/ui/widgets/detail_screen/movie_details/details_model.dart';
import 'package:movies_app_tmbd/ui/widgets/loader_screen/loader_view_model.dart';

class AuthService implements AuthViewModelLoginProvider ,LoaderViewModelAuthStatusProvider,MovieDetailsModelLogoutProvider {

  final AuthApiClient authApiClient ;
  final AccountApiClient accountApiClient;
  final SessionDataProvider sessionDataProvider;

 const AuthService(
      { required this.authApiClient,required this.accountApiClient, required this.sessionDataProvider});


  @override
  Future<bool> isAuth() async {
    final sessionId = await sessionDataProvider.getSessionId();
    final isAuth = sessionId != null;
    return isAuth;
  }

  @override
  Future<void> login(String login,String password) async {
    final sessionId =  await authApiClient.auth(userName: login, password: password);
    final accountId = await accountApiClient.getAccountInfo(sessionId);
    await sessionDataProvider.setSessionId(sessionId);
    await sessionDataProvider.setAccountId(accountId);
  }

  @override
  Future<void> logout() async {
    await sessionDataProvider.deleteSessionId();
    await sessionDataProvider.deleteAccountId();
  }
}