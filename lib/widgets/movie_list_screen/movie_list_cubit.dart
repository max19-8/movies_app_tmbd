import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:movies_app_tmbd/domain/blocs/movie_list_bloc.dart';
import 'package:movies_app_tmbd/domain/entity/movie.dart';

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

class MovieListCubitState {
  final List<MovieListRowData> movies;
  final String localeTag;

  MovieListCubitState({required this.movies, required this.localeTag});

  MovieListCubitState copyWith({
    List<MovieListRowData>? movies,
    String? localeTag,
    String? searchQuery,
  }) {
    return MovieListCubitState(
      movies: movies ?? this.movies,
      localeTag: localeTag ?? this.localeTag,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieListCubitState &&
          runtimeType == other.runtimeType &&
          movies == other.movies &&
          localeTag == other.localeTag;

  @override
  int get hashCode => movies.hashCode ^ localeTag.hashCode;
}

class MovieListCubit extends Cubit<MovieListCubitState> {
  final MovieListBloc movieListBloc;
  late final StreamSubscription<MovieListState> movieListSubscription;
  late DateFormat _dateFormat;
  Timer? _searchDebounce;

  MovieListCubit({required this.movieListBloc})
      : super(
          MovieListCubitState(movies: <MovieListRowData>[], localeTag: ''),
        ) {
    Future.microtask(() {
      _onState(movieListBloc.state);
      movieListSubscription = movieListBloc.stream.listen(_onState);
    });
  }

  void _onState(MovieListState state) {
    final movies =
        state.movies.map((Movie movie) => _makeRowData(movie)).toList();
    print(movies.length);
    final newState = this.state.copyWith(movies: movies);
    emit(newState);
  }

  void setupLocale(String localeTag) {
    if (state.localeTag == localeTag) return;
    final newState = state.copyWith(localeTag: localeTag);
    emit(newState);
    _dateFormat = DateFormat.yMMMd(localeTag);
    movieListBloc.add(MovieListEventLoadReset());
    movieListBloc.add(MovieListEventLoadNextPage(localeTag));
  }

  @override
  Future<void> close() {
    movieListSubscription.cancel();
    return super.close();
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

  void searchMovie(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () async {
      movieListBloc.add(MovieListEventLoadSearchMovie(query));
      movieListBloc.add(MovieListEventLoadNextPage(state.localeTag));
    });
  }

  void showMovieAtIndex(int index) {
    if(index < state.movies.length - 2) return;
    movieListBloc.add(MovieListEventLoadNextPage(state.localeTag));
  }
}
