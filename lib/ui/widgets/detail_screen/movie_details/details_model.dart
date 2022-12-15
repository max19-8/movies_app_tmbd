import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movies_app_tmbd/data/api_client/api_client_exception.dart';
import 'package:movies_app_tmbd/data/entity/details_movie_entity/details_result.dart';
import 'package:movies_app_tmbd/data/entity/details_movie_entity/movie_details_local.dart';
import 'package:movies_app_tmbd/data/services/movie_service.dart';
import 'package:movies_app_tmbd/library/localized_model_storage.dart';
import 'package:movies_app_tmbd/navigation/main_navigation_actions.dart';
import '../entity/details_data.dart';

abstract class MovieDetailsModelLogoutProvider{
   Future<void> logout();
}

abstract class MovieDetailsModelMovieProvider{
   updateFavorite({ required int movieId, required bool isFavorite});
   Future<MovieDetailsLocal> loadDetails(
       { required int movieId, required String locale});
}

class MovieDetailsModel extends ChangeNotifier {
   final int movieId;
   final data = DetailsData();
   final  MovieService movieProvider;
   final  MovieDetailsModelLogoutProvider authProvider;
   final  MainNavigationActions navigationActions;

   final  _localeStorage = LocalizedModelStorage();

   MovieDetailsModel(this.movieId,{required this.authProvider,required this.movieProvider,required this.navigationActions});
   late DateFormat _dateFormat;

   Future<void> setupLocale(BuildContext context,Locale locale) async {
      if(!_localeStorage.updateLocale(locale)) return;
      _dateFormat = DateFormat.yMMMd(_localeStorage.localeTag);
      updateData(null, false);
      await loadDetails(context);
   }

   void updateData(MovieDetailsResult? details, bool isFavorite) {
      data.title = details?.title ?? 'Загрузка...';
      data.isLoading = details == null;
      if (details == null) {
         notifyListeners();
         return;
      }
       data.overview = details.overview ?? '';
      data.posterData = DetailsPosterData(
          backdropPath: details.backdropPath ?? '',
          posterPath: details.posterPath?? '',
          isFavorite: isFavorite);
      var year = details.releaseDate?.year.toString() ?? '';
      year =  ' ($year) ';
      data.movieNameData =
          DetailsMovieNameData(name: details.title, year: year);
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

   String makeSummary(MovieDetailsResult details) {
      var texts = <String>[];
      final releaseDate = details.releaseDate;
      if (releaseDate != null) {
         texts.add(_dateFormat.format(releaseDate));
      }
      final productionCountries = details.productionCountries;
      if (productionCountries!.isNotEmpty) {
         texts.add('(${productionCountries.first.iso31661})');
      }
      final runtime = details.runtime ?? 0;
      final duration = Duration(minutes: runtime);
      final hours = duration.inHours;
      final minutes = duration.inMinutes.remainder(60) ;
      texts.add('${hours}h ${minutes}m, ');

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
         final data = await movieProvider.loadDetails(movieId: movieId, locale: _localeStorage.localeTag);
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
             movieId: movieId,
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
       MovieDetailsResult details) {
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