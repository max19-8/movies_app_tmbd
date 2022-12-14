import 'package:movies_app_tmbd/data/api_client/movie_api_client.dart';
import 'package:movies_app_tmbd/data/entity/movie_list/movies_response.dart';
import 'package:movies_app_tmbd/library/config/configuration.dart';
import 'movie_list_service.dart';

class TopRatedMoviesService implements MovieListService {
  final MovieApiClient  movieApiClient;
  TopRatedMoviesService({  required this.movieApiClient});
  
   @override
  Future<MovieResponse> getListMovies(int page, String locale)async =>
       movieApiClient.topRatedMovies(page, locale, Configuration.apiKey);
 }