import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:movies_app_tmbd/domain/api_client/api_client.dart';
import 'package:movies_app_tmbd/domain/entity/movie.dart';
import 'package:movies_app_tmbd/domain/entity/popular_movie_response.dart';
import 'package:movies_app_tmbd/navigation/main_navigation.dart';

class MovieListModel extends ChangeNotifier {
  final _apiClient = ApiClient();
  final _movies = <Movie>[];

  List<Movie> get movies => List.unmodifiable(_movies);
  late DateFormat _dateFormat;
  String _locale = '';
  late int _currentPage;
  late int _totalPage;
  var _isLoadingInProgress = false;
  String? _searchQuery;
  Timer? _searchDebounce;

  String stringFromDate(DateTime? date) =>
      date != null ? _dateFormat.format(date) : '';

  Future<void> setupLocale(BuildContext context)async {
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (_locale == locale) return;
    _locale = locale;
    _dateFormat = DateFormat.yMMMd(locale);
    _resetListMovie();
  }


  Future<void>searchMovie(String query) async{
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), ()  async{
    final  searchQuery = query.isNotEmpty ? query :null;
    if(_searchQuery == searchQuery) return;
    _searchQuery = searchQuery;
    await _resetListMovie();
    });


  }


  Future<void> _resetListMovie()async{
    _currentPage = 0;
    _totalPage = 1;
    _movies.clear();
   await  _loadNextPage();
  }

  Future<PopularMovieResponse> _loadMovies(int nextPage, String locale) async {
    final query  = _searchQuery;
    if(query == null){
       return await _apiClient.popularMovie(nextPage, _locale);
    } else{
      return await _apiClient.searchMovie(nextPage, _locale,query);
    }

}

  Future<void> _loadNextPage() async {
    if(_isLoadingInProgress || _currentPage >= _totalPage) return;
    _isLoadingInProgress = true;
    final nextPage = _currentPage + 1;

    try{
      final response = await _loadMovies(nextPage, _locale);
      _movies.addAll(response.movies);
      _currentPage = response.page;
      _totalPage = response.totalPages;

      notifyListeners();
    }catch(e){
   print(e.toString());
    }finally{
      _isLoadingInProgress = false;
    }
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
