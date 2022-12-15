import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movies_app_tmbd/data/api_client/api_client_exception.dart';
import 'package:movies_app_tmbd/data/entity/detail_tv_show_entity/tv_show_detail.dart';
import 'package:movies_app_tmbd/data/services/news_service.dart';
import 'package:movies_app_tmbd/library/localized_model_storage.dart';
import 'package:movies_app_tmbd/navigation/main_navigation_actions.dart';
import 'package:movies_app_tmbd/ui/widgets/detail_screen/movie_details/details_model.dart';
import 'package:movies_app_tmbd/ui/widgets/detail_screen/entity/details_data.dart';

class TvShowDetailsModel extends ChangeNotifier {
  final int tvShowId;
  final data = DetailsData();
  final  NewsService movieProvider;
  final  MovieDetailsModelLogoutProvider authProvider;
  final  MainNavigationActions navigationActions;

  final  _localeStorage = LocalizedModelStorage();

  TvShowDetailsModel(this.tvShowId,{required this.authProvider,required this.movieProvider,required this.navigationActions});
  late DateFormat _dateFormat;

  Future<void> setupLocale(BuildContext context,Locale locale) async {
    if(!_localeStorage.updateLocale(locale)) return;
    _dateFormat = DateFormat.yMMMd(_localeStorage.localeTag);
    updateData(null, false);
    await loadDetails(context);
  }

  void updateData(DetailTvShow? details, bool isFavorite) {
    data.title = details?.name ?? 'Загрузка...';
    data.isLoading = details == null;
    if (details == null) {
      notifyListeners();
      return;
    }
    data.overview = details.overview;
    data.posterData = DetailsPosterData(
        backdropPath: details.backdropPath ?? '',
        posterPath: details.posterPath?? '',
        isFavorite: isFavorite);
   var year = details.firstAirDate?.year.toString() ?? '';
   year =  ' ($year) ' ;
   data.movieNameData =
       DetailsMovieNameData(name: details.name, year: year);
   final videos = details.videos?.results
       .where((video) => video.type == 'Trailer' && video.site == "YouTube");
   final trailerKey = videos?.isNotEmpty == true ? videos?.first.key : null;
    var voteAverage = details.voteAverage;
      voteAverage = voteAverage * 10;
   data.scoreData =
       DetailsScoreData(trailerKey: trailerKey, voteAverage: voteAverage);
    data.summary = makeSummary(details);
   data.peopleData = makePeopleData(details);
   data.actorsData = details.credits.cast
        .map((e) => DetailsMovieActorsData(
       name: e.name, character: e.character,
       profilePath:e.profilePath
   ))
       .toList();
    notifyListeners();
  }

  String makeSummary(DetailTvShow details) {
    var texts = <String>[];
    final releaseDate = details.firstAirDate;
    if (releaseDate != null) {
      texts.add(_dateFormat.format(releaseDate));
    }
    final productionCountries = details.productionCountries;
    if (productionCountries!.isNotEmpty) {
      texts.add('(${productionCountries.first.iso31661})');
    }


    final genres = details.genres ;
    if (genres.isNotEmpty) {
      var genresNames = <String>[];
      for (var gen in genres) {
        genresNames.add(gen.name);
      }
      texts.add(genresNames.join(', '));
    }
    return texts.join(' ');
  }

  Future<void> loadDetails(BuildContext context) async {
    try {
      final data = await movieProvider.getTvShowDetails(tvShowId: tvShowId, locale: _localeStorage.localeTag);
      updateData(data.details, data.isFavorite);
    } on ApiClientException catch (e) {
      handleApiClientException(e, context);
    }
  }

  Future<void> toggleFavorite(BuildContext context) async {
    data.posterData =
        data.posterData.copyWith(isFavorite: !data.posterData.isFavorite);
    notifyListeners();
    try {
      await movieProvider.updateFavorite(
          tvShowId: tvShowId,
          isFavorite: data.posterData.isFavorite);
    } on ApiClientException catch (e) {
      handleApiClientException(e, context);
    }
  }

  void handleApiClientException(
      ApiClientException exception, BuildContext context) {
    switch (exception.type) {
      case ApiClientExceptionType.sessionExpired:
        authProvider.logout();
        navigationActions.resetNavigation(context);
        break;
      default:
        print(exception);
    }
  }



  List<List<DetailsMoviePeoplesData>> makePeopleData(
      DetailTvShow details) {
    var crewChunks = <List<DetailsMoviePeoplesData>>[];
    var crew = details.credits.crew
        .map((e) => DetailsMoviePeoplesData(name: e.name, job: e.job))
        .toList();
    crew = crew.length > 4 ? crew.sublist(0, 4) : crew;
    for (var i = 0; i < crew.length; i += 2) {
      crewChunks
          .add(crew.sublist(i, i + 2 > crew.length ? crew.length : i + 2));
    }
    return crewChunks;
  }
  }