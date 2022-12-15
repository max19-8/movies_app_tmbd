import 'package:movies_app_tmbd/data/entity/movie_list/movies_response.dart';

abstract class MovieListService{
  Future<MovieResponse> getListMovies(int page, String locale);
}