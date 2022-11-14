import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:movies_app_tmbd/domain/entity/movie.dart';
import 'package:movies_app_tmbd/domain/services/movie_service.dart';
import 'package:movies_app_tmbd/library/Widgets/localized_model_storage.dart';
import 'package:movies_app_tmbd/library/paginator.dart';
import 'package:movies_app_tmbd/navigation/main_navigation.dart';

class MovieListRowData {
  final int id;
  final String title;
  final String? posterPath;
  final String releaseDate;
  final String overview;

  MovieListRowData({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.releaseDate,
    required this.overview,
  });
}

class MovieListViewModel extends ChangeNotifier {
  final _movieService = MovieService();
  late final Paginator<Movie> _popularMoviePaginator;
  late final Paginator<Movie> _searchMoviePaginator;
  final  _localeStorage = LocalizedModelStorage();

  var _movies = <MovieListRowData>[];

  List<MovieListRowData> get movies => List.unmodifiable(_movies);
  late DateFormat _dateFormat;
  String? _searchQuery;
  Timer? _searchDebounce;

  bool get isSearchMode {
    final searchQuery = _searchQuery;
    return searchQuery != null && searchQuery.isNotEmpty;
  }

  MovieListViewModel() {
    _popularMoviePaginator = Paginator((page) async {
      final result = await _movieService.popularMovie(page, _localeStorage.localeTag);
      return PaginatorLoadResult(
          data: result.movies,
          currentPage: result.page,
          totalPage: result.totalPages);
    });
    _searchMoviePaginator = Paginator((page) async {
      final result =
          await _movieService.searchMovie(page, _localeStorage.localeTag, _searchQuery ?? '');
      return PaginatorLoadResult(
          data: result.movies,
          currentPage: result.page,
          totalPage: result.totalPages);
    });
  }

  Future<void> setupLocale(Locale locale) async {
    if(!_localeStorage.updateLocale(locale)) return;
    _dateFormat = DateFormat.yMMMd(_localeStorage.localeTag);
    await _resetListMovie();
  }

  Future<void> searchMovie(String query) async {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () async {
      final searchQuery = query.isNotEmpty ? query : null;
      if (_searchQuery == searchQuery) return;
      _searchQuery = searchQuery;
      _movies.clear();
      if(isSearchMode){
        await _searchMoviePaginator.reset();
      }
      _loadNextPage();
    });
  }

  Future<void> _resetListMovie() async {
    await _popularMoviePaginator.reset();
    await _searchMoviePaginator.reset();
    _movies.clear();
    await _loadNextPage();
  }

  Future<void> _loadNextPage() async {
    if (isSearchMode) {
      await _searchMoviePaginator.loadNextPage();
      _movies = _searchMoviePaginator.data
          .map((movie) => _makeRowData(movie))
          .toList();
    } else {
      await _popularMoviePaginator.loadNextPage();
      _movies = _popularMoviePaginator.data
          .map((movie) => _makeRowData(movie))
          .toList();
    }
    notifyListeners();
  }

  MovieListRowData _makeRowData(Movie movie) {
    final releaseDate = movie.releaseDate;
    final releaseDateTitle =
        releaseDate != null ? _dateFormat.format(releaseDate) : '';
    return MovieListRowData(
        id: movie.id,
        title: movie.title,
        posterPath: movie.posterPath,
        releaseDate: releaseDateTitle,
        overview: movie.overview);
  }

  void onMovieTap(BuildContext context, int index) {
    final id = _movies[index].id;
    Navigator.of(context)
        .pushNamed(MainNavigationRouteNames.movieDetails, arguments: id);
  }

  void showMovieAtIndex(int index) {
    if (index < _movies.length - 1) return;
    _loadNextPage();
  }
}
