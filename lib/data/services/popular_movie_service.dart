import 'package:movies_app_tmbd/data/api_client/movie_api_client.dart';
import 'package:movies_app_tmbd/data/entity/movies_response.dart';
import 'package:movies_app_tmbd/library/config/configuration.dart';

import 'movie_list_service.dart';

class PopularMovieService implements MovieListService{
  final MovieApiClient  movieApiClient;
  PopularMovieService({  required this.movieApiClient});

  @override
  Future<MovieResponse> getListMovies(int page, String locale)async =>
      movieApiClient.popularMovie(page, locale, Configuration.apiKey);
}