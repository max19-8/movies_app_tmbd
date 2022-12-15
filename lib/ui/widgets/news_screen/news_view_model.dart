import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movies_app_tmbd/data/entity/movie_list/movie.dart';
import 'package:movies_app_tmbd/data/entity/tv_show_list/tv_show.dart';
import 'package:movies_app_tmbd/data/services/news_service.dart';
import 'package:movies_app_tmbd/library/localized_model_storage.dart';
import 'package:movies_app_tmbd/library/paginator.dart';
import 'package:movies_app_tmbd/navigation/main_navigation_route_names.dart';
import 'package:movies_app_tmbd/ui/entity/result_list_row_data.dart';

class NewsViewModel extends ChangeNotifier {
  final NewsService newsProvider;

  late final Paginator<Movie> _upcomingMoviePaginator;
  var _movies = <ResultListRowData>[];
  List<ResultListRowData> get movies => List.unmodifiable(_movies);

  final _trendingMovies = <ResultListRowData>[];
  List<ResultListRowData> get trendingMovies => _trendingMovies;

  final _trendingTvShow = <ResultListRowData>[];
  List<ResultListRowData> get trendingTvShow => _trendingTvShow;

  late DateFormat _dateFormat;
  final _localeStorage = LocalizedModelStorage();

  NewsViewModel(this.newsProvider) {
    _upcomingMoviePaginator = Paginator((page) async {
      final result = await newsProvider.getUpcomingMovies(
          page, _localeStorage.localeTag);
      return PaginatorLoadResult(
          data: result.movies,
          currentPage: result.page,
          totalPage: result.totalPages);
    });
  }


  Future<void> getTrendingMovies() async {
    final result = await newsProvider.getTrendingMovies();
    final movies = result.movies.map((Movie movie) => _movieMakeToRowData(movie)).toList();
    _trendingMovies.addAll(movies);
    notifyListeners();
  }

  Future<void> getTrendingTvShows() async {
    final result = await newsProvider.getTrendingTvShow();
    final tvShows  = result.tvShows.map((TvShow movie) => _tvShowMakeToRowData(movie)).toList();
    _trendingTvShow.addAll(tvShows);
    notifyListeners();
  }

  Future<void> setupLocale(Locale locale) async {
    if (!_localeStorage.updateLocale(locale)) return;
    _dateFormat = DateFormat.yMMMd(_localeStorage.localeTag);
    await _resetListMovie();
   await  getTrendingMovies();
   await  getTrendingTvShows();
  }

  Future<void> _resetListMovie() async {
    await _upcomingMoviePaginator.reset();
    _movies.clear();
    await _loadNextPage();
  }

  Future<void> _loadNextPage() async {
    await _upcomingMoviePaginator.loadNextPage();
    _movies = _upcomingMoviePaginator.data
        .map((movie) => _movieMakeToRowData(movie))
        .toList();
    notifyListeners();
  }

  ResultListRowData _tvShowMakeToRowData(TvShow tvShow) {
    final releaseDate = tvShow.firstAirDate;
    final releaseDateTitle =
    releaseDate != null ? _dateFormat.format(releaseDate) : '';
    return ResultListRowData(
        id: tvShow.id,
        title: tvShow.name,
        posterPath: tvShow.posterPath,
        releaseDate: releaseDateTitle,
        overview: tvShow.overview);
  }

  ResultListRowData _movieMakeToRowData(Movie movie) {
    final releaseDate = movie.releaseDate;
    final releaseDateTitle =
    releaseDate != null ? _dateFormat.format(releaseDate) : '';
    return ResultListRowData(
        id: movie.id,
        title: movie.title,
        posterPath: movie.backdropPath,
        releaseDate: releaseDateTitle,
        overview: movie.overview);
  }

  void onMovieTap(BuildContext context, int index,List<ResultListRowData> data) {
    final id = data[index].id;
    Navigator.of(context)
        .pushNamed(MainNavigationRouteNames.movieDetails, arguments: id);
  }

  void onTvShowTap(BuildContext context, int index,List<ResultListRowData> data) {
    final id = data[index].id;
    Navigator.of(context)
        .pushNamed(MainNavigationRouteNames.tvShowDetails, arguments: id);
  }

  void showMovieAtIndex(int index) {
    if (index < _movies.length - 1) return;
    _loadNextPage();
  }
}