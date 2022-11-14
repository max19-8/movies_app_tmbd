import 'package:movies_app_tmbd/config/configuration.dart';
import 'package:movies_app_tmbd/domain/api_client/account_api_client.dart';
import 'package:movies_app_tmbd/domain/api_client/movie_api_client.dart';
import 'package:movies_app_tmbd/domain/data_providers/session_data_provider.dart';
import 'package:movies_app_tmbd/domain/entity/popular_movie_response.dart';
import 'package:movies_app_tmbd/domain/local_entity/movie_details_local.dart';

class MovieService {

  final _movieApiClient = MovieApiClient();
  final _accountApiClient = AccountApiClient();
  final _sessionDataProvider = SessionDataProvider();

  Future<PopularMovieResponse> popularMovie(int page, String locale) async =>
      _movieApiClient.popularMovie(page, locale, Configuration.apiKey);

  Future<PopularMovieResponse> searchMovie(int page, String locale,
      String query) async =>
      _movieApiClient.searchMovie(page, locale, query, Configuration.apiKey);


  Future<MovieDetailsLocal> loadDetails(
      { required int movieId, required String locale}) async {
    final movieDetails = await _movieApiClient.movieDetails(movieId, locale);
    final sessionId = await _sessionDataProvider.getSessionId();
    var isFavorite = false;
    if (sessionId != null) {
      isFavorite = await _movieApiClient.isFavorite(movieId, sessionId);
    }
   return MovieDetailsLocal(movieDetails: movieDetails, isFavorite: isFavorite);
  }

  Future<void> updateFavorite({ required int movieId, required bool isFavorite}) async {
    final accountId = await _sessionDataProvider.getAccountId();
    final sessionId = await _sessionDataProvider.getSessionId();
    if (sessionId == null || accountId == null) return;
      await _accountApiClient.markAsFavorite(
          accountId: accountId,
          sessionId: sessionId,
          mediaType: ApiClientMediaType.movie,
          mediaId: movieId,
          isFavorite: isFavorite);

  }
}