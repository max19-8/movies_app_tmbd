import 'package:movies_app_tmbd/library/config/configuration.dart';

import 'network_client.dart';

 abstract class AuthApiClient{
   Future<String> auth(
       {required String userName, required String password});
 }



class AuthApiClientDefault implements AuthApiClient {
  final  NetworkClient networkClient;

   const AuthApiClientDefault(this.networkClient);

  @override
  Future<String> auth(
      {required String userName, required String password}) async {
    final token = await _makeToken();
    final validToken = await _validateUser(
        userName: userName, password: password, requestToken: token);

    final sessionId = await _makeSession(requestToken: validToken);
    return sessionId;
  }

  Future<String> _makeToken() async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final token = jsonMap['request_token'] as String;
      return token;
    }

    final result = networkClient.get('/authentication/token/new', parser,
        <String, dynamic>{'api_key': Configuration.apiKey});

    return result;
  }

  Future<String> _validateUser(
      {required String userName,
      required String password,
      required String requestToken}) async {
    final bodyParameters = <String, dynamic>{
      'username': userName,
      'password': password,
      'request_token': requestToken,
    };
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final token = jsonMap['request_token'] as String;
      return token;
    }

    final result = networkClient.post(
        '/authentication/token/validate_with_login',
        bodyParameters,
        parser,
        <String, dynamic>{'api_key': Configuration.apiKey});
    return result;
  }

  Future<String> _makeSession({required String requestToken}) async {
    final bodyParameters = <String, dynamic>{
      'request_token': requestToken,
    };
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final sessionID = jsonMap['session_id'] as String;
      return sessionID;
    }

    final result = networkClient.post(
        '/authentication/session/new',
        bodyParameters,
        parser,
        <String, dynamic>{'api_key': Configuration.apiKey});
    return result;
  }
}
