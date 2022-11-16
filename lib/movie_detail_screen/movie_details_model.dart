import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movies_app_tmbd/domain/api_client/api_client_exception.dart';
import 'package:movies_app_tmbd/domain/entity/movie_details.dart';
import 'package:movies_app_tmbd/domain/services/auth_service.dart';
import 'package:movies_app_tmbd/domain/services/movie_service.dart';
import 'package:movies_app_tmbd/library/Widgets/localized_model_storage.dart';
import 'package:movies_app_tmbd/navigation/main_navigation.dart';

class MovieDetailsPosterData {
  final String? backdropPath;
  final String? posterPath;
  final bool isFavorite;

  IconData get favoriteIcon =>
      isFavorite ? Icons.favorite : Icons.favorite_outline;

  MovieDetailsPosterData(
      {this.backdropPath, this.posterPath, this.isFavorite = false});

  MovieDetailsPosterData copyWith(
      {final String? backdropPath,
      final String? posterPath,
      final bool? isFavorite}) {
    return MovieDetailsPosterData(
      backdropPath: backdropPath ?? this.backdropPath,
      posterPath: posterPath ?? this.posterPath,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class MovieDetailsMovieNameData {
  final String name;

  final String year;

  MovieDetailsMovieNameData({required this.name, required this.year});
}

class MovieDetailsScoreData {
  final String? trailerKey;
  final double voteAverage;

  MovieDetailsScoreData({this.trailerKey, required this.voteAverage});
}

class MovieDetailsMoviePeoplesData {
  final String name;
  final String job;

  MovieDetailsMoviePeoplesData({required this.name, required this.job});
}

class MovieDetailsMovieActorsData {
  final String name;
  final String character;
  final String? profilePath;

  MovieDetailsMovieActorsData(
      {required this.name, required this.character, this.profilePath});
}

class MovieDetailsData {
  String title = '';
  bool isLoading = true;
  String overview = '';
  MovieDetailsPosterData posterData = MovieDetailsPosterData();
  MovieDetailsMovieNameData movieNameData =
      MovieDetailsMovieNameData(name: '', year: '');
  MovieDetailsScoreData scoreData = MovieDetailsScoreData(voteAverage: 0);
  String summary = '';
  List<List<MovieDetailsMoviePeoplesData>> peopleData =
      const <List<MovieDetailsMoviePeoplesData>>[];
  List<MovieDetailsMovieActorsData> actorsData =
      const <MovieDetailsMovieActorsData>[];
}

class MovieDetailsViewModel extends ChangeNotifier {
  final int movieId;
  final data = MovieDetailsData();
  final movieService = MovieService();
  final _authService = AuthService();

  final  _localeStorage = LocalizedModelStorage();

  MovieDetailsViewModel(this.movieId);
  late DateFormat _dateFormat;

  Future<void> setupLocale(BuildContext context,Locale locale) async {
    if(!_localeStorage.updateLocale(locale)) return;
      _dateFormat = DateFormat.yMMMd(_localeStorage.localeTag);
      updateData(null, false);
      await loadDetails(context);
  }


  void updateData(MovieDetails? details, bool isFavorite) {
    data.title = details?.title ?? 'Загрузка...';
    data.isLoading = details == null;
    if (details == null) {
      notifyListeners();
      return;
    }
    data.overview = details.overview ?? '';
    data.posterData = MovieDetailsPosterData(
        backdropPath: details.backdropPath,
        posterPath: details.posterPath,
        isFavorite: isFavorite);
    var year = details.releaseDate?.year.toString();
    year = year != null ? ' ($year) ' : '';
    data.movieNameData =
        MovieDetailsMovieNameData(name: details.title, year: year);
    final videos = details.videos.results
        .where((video) => video.type == 'Trailer' && video.site == "YouTube");
    final trailerKey = videos.isNotEmpty == true ? videos.first.key : null;
    var voteAverage = details.voteAverage;
    voteAverage = voteAverage * 10;
    data.scoreData =
        MovieDetailsScoreData(trailerKey: trailerKey, voteAverage: voteAverage);
    data.summary = makeSummary(details);
    data.peopleData = makePeopleData(details);
    data.actorsData = details.credits.cast
        .map((e) => MovieDetailsMovieActorsData(
            name: e.name, character: e.character, profilePath: e.profilePath))
        .toList();
    notifyListeners();
  }

  String makeSummary(MovieDetails details) {
    var texts = <String>[];
    final releaseDate = details.releaseDate;
    if (releaseDate != null) {
      texts.add(_dateFormat.format(releaseDate));
    }
    final productionCountries = details.productionCountries;
    if (productionCountries.isNotEmpty) {
      texts.add('(${productionCountries.first.iso31661})');
    }
    final runtime = details.runtime ?? 0;
    final duration = Duration(minutes: runtime);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    texts.add('${hours}h ${minutes}m, ');

    final genres = details.genres;
    if (genres.isNotEmpty) {
      var genresNames = <String>[];
      for (var gen in genres) {
        if (gen.name != null) {
          genresNames.add(gen.name!);
        }
      }
      texts.add(genresNames.join(', '));
    }
    return texts.join(' ');
  }

  List<List<MovieDetailsMoviePeoplesData>> makePeopleData(
      MovieDetails details) {
    var crew = details.credits.crew
        .map((e) => MovieDetailsMoviePeoplesData(name: e.name, job: e.job))
        .toList();
    crew = crew.length > 4 ? crew.sublist(0, 4) : crew;
    var crewChunks = <List<MovieDetailsMoviePeoplesData>>[];
    for (var i = 0; i < crew.length; i += 2) {
      crewChunks
          .add(crew.sublist(i, i + 2 > crew.length ? crew.length : i + 2));
    }
    return crewChunks;
  }


  Future<void> loadDetails(BuildContext context) async {
    try {
     final data = await movieService.loadDetails(movieId: movieId, locale: _localeStorage.localeTag);
      updateData(data.movieDetails, data.isFavorite);
    } on ApiClientException catch (e) {
      _handleApiClientException(e, context);
    }
  }

  Future<void> toggleFavorite(BuildContext context) async {
    data.posterData =
        data.posterData.copyWith(isFavorite: !data.posterData.isFavorite);
    notifyListeners();
    try {
      await movieService.updateFavorite(
          movieId: movieId,
          isFavorite: data.posterData.isFavorite);
    } on ApiClientException catch (e) {
      _handleApiClientException(e, context);
    }
  }

  void _handleApiClientException(
      ApiClientException exception, BuildContext context) {
    switch (exception.type) {
      case ApiClientExceptionType.sessionExpired:
        _authService.logout();
        MainNavigation.resetNavigation(context);
        break;
      default:
        print(' _handleApiClientException $exception');
    }
  }
}
