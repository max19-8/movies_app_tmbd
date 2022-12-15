import 'package:movies_app_tmbd/data/api_client/account_api_client.dart';
import 'package:movies_app_tmbd/data/api_client/media_type.dart';
import 'package:movies_app_tmbd/data/api_client/news_api_client.dart';
import 'package:movies_app_tmbd/data/api_client/time_window.dart';
import 'package:movies_app_tmbd/data/entity/detail_tv_show_entity/tv_show_details_local.dart';
import 'package:movies_app_tmbd/data/entity/movie_list/movies_response.dart';
import 'package:movies_app_tmbd/data/entity/tv_show_list/tv_show_response.dart';
import 'package:movies_app_tmbd/domain/data_providers/session_data_provider.dart';
import 'package:movies_app_tmbd/library/config/configuration.dart';

class NewsService {
  final NewsApiClient  newsApiClient;
  final SessionDataProvider sessionDataProvider;
  final AccountApiClient accountApiClient;

  NewsService({  required this.newsApiClient,required this.sessionDataProvider, required this.accountApiClient});

  Future<MovieResponse> getUpcomingMovies(
  int page, String locale)async =>
      newsApiClient.getUpcomingMovies(page, locale, Configuration.apiKey);

  Future<MovieResponse> getTrendingMovies() async => newsApiClient.getTrendingMovies(ApiClientMediaType.movie, TimeWindow.week,  Configuration.apiKey);
  Future<TvShowResponse> getTrendingTvShow() async => newsApiClient.getTrendingTvShows(ApiClientMediaType.tv, TimeWindow.week,  Configuration.apiKey);


  Future<TvShowDetailsLocal> getTvShowDetails({ required int tvShowId, required String locale}) async {
  final movieDetails = await newsApiClient.tvShowDetails(tvShowId, locale);
  final sessionId = await sessionDataProvider.getSessionId();
  var isFavorite = false;
  if (sessionId != null) {
  isFavorite = await newsApiClient.isFavorite(tvShowId, sessionId);
  await newsApiClient.isFavorite(tvShowId, sessionId);
  }
  return TvShowDetailsLocal(details: movieDetails, isFavorite: isFavorite);
}

  Future<void> updateFavorite({ required int tvShowId, required bool isFavorite}) async {
    final accountId = await sessionDataProvider.getAccountId();
    final sessionId = await sessionDataProvider.getSessionId();
    if (sessionId == null || accountId == null) return;
    await accountApiClient.markAsFavorite(
        accountId: accountId,
        sessionId: sessionId,
        mediaType: ApiClientMediaType.tv,
        mediaId: tvShowId,
        isFavorite: isFavorite);
  }
}