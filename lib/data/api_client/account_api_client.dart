import 'package:movies_app_tmbd/library/config/configuration.dart';

import 'media_type.dart';
import 'network_client.dart';

abstract class AccountApiClient{
  Future<int> markAsFavorite({
    required int accountId,
    required String sessionId,
    required ApiClientMediaType mediaType,
    required int mediaId,
    required bool isFavorite,
  });

  Future<int> getAccountInfo(String sessionID);

}
class AccountApiClientDefault implements AccountApiClient {
  final NetworkClient networkClient;

  const AccountApiClientDefault(this.networkClient);

  @override
  Future<int> markAsFavorite({
    required int accountId,
    required String sessionId,
    required ApiClientMediaType mediaType,
    required int mediaId,
    required bool isFavorite,
  }) async {
    parser(dynamic json) {
      return 1;
    }

    final bodyParameters = <String, dynamic>{
      'media_type': mediaType.asString(),
      'media_id': mediaId,
      'favorite': isFavorite,
    };

    final result = networkClient.post('/account/$accountId/favorite',
        bodyParameters, parser, <String, dynamic>{
          'api_key': Configuration.apiKey,
          'session_id': sessionId,
        });
    return result;
  }

  @override
  Future<int> getAccountInfo(String sessionID) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final result = jsonMap['id'] as int;
      return result;
    }

    final result = networkClient.get('/account', parser, <String, dynamic>{
      'api_key': Configuration.apiKey,
      'session_id': sessionID,
    });
    return result;
  }

}