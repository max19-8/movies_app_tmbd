import 'package:movies_app_tmbd/config/configuration.dart';
import 'network_client.dart';

enum ApiClientMediaType { movie, tv }

extension MediaTypeAsString on ApiClientMediaType {
  String asString() {
    switch (this) {
      case ApiClientMediaType.movie:
        return 'movie';
      case ApiClientMediaType.tv:
        return 'tv';
    }
  }
}

class AccountApiClient{
  final _networkClient = NetworkClient();

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
    print('bodyParameters $bodyParameters');

    final result = _networkClient.post('/account/$accountId/favorite',
        bodyParameters, parser, <String, dynamic>{
          'api_key': Configuration.apiKey,
          'session_id': sessionId,
        });

    print('markAsFavorite $isFavorite');
    return result;
  }

  Future<int> getAccountInfo(String sessionID) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final result = jsonMap['id'] as int;
      return result;
    }

    final result = _networkClient.get('/account', parser, <String, dynamic>{
      'api_key': Configuration.apiKey,
      'session_id': sessionID,
    });
    return result;
  }

}