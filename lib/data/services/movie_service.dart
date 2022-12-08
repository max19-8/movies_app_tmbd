import 'package:movies_app_tmbd/data/api_client/account_api_client.dart';
import 'package:movies_app_tmbd/data/api_client/movie_api_client.dart';
import 'package:movies_app_tmbd/data/entity/movies_response.dart';
import 'package:movies_app_tmbd/domain/data_providers/session_data_provider.dart';
import 'package:movies_app_tmbd/data/entity/movie_details_local.dart';
import 'package:movies_app_tmbd/library/config/configuration.dart';
import 'package:movies_app_tmbd/ui/widgets/movie_list_screen/movie_list_view_model.dart';

class MovieService  implements  MovieListModelMoviesProvider{

  final MovieApiClient  movieApiClient;
  final AccountApiClient accountApiClient;
  final SessionDataProvider sessionDataProvider;

  MovieService(
      {required this.movieApiClient, required  this.accountApiClient, required this.sessionDataProvider});

  @override
  Future<MovieResponse> searchMovie(int page, String locale,
      String query) async =>
      movieApiClient.searchMovie(page, locale, query, Configuration.apiKey);

  Future<MovieDetailsLocal> loadDetails ({ required int movieId, required String locale}) async {
    final movieDetails = await movieApiClient.movieDetails(movieId, locale);

    final sessionId = await sessionDataProvider.getSessionId();
    var isFavorite = false;
    if (sessionId != null) {
      isFavorite = await movieApiClient.isFavorite(movieId, sessionId);
    }
   return MovieDetailsLocal(details: movieDetails, isFavorite: isFavorite);
  }

  Future<void> updateFavorite({ required int movieId, required bool isFavorite}) async {
    final accountId = await sessionDataProvider.getAccountId();
    final sessionId = await sessionDataProvider.getSessionId();
    if (sessionId == null || accountId == null) return;
      await accountApiClient.markAsFavorite(
          accountId: accountId,
          sessionId: sessionId,
          mediaType: ApiClientMediaType.movie,
          mediaId: movieId,
          isFavorite: isFavorite);
  }
}