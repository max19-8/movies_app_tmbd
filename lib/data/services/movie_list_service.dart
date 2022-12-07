import 'package:movies_app_tmbd/data/entity/movies_response.dart';

abstract class MovieListService{
  Future<MovieResponse> getListMovies(int page, String locale);
}