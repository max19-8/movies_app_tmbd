import 'package:flutter/material.dart';

class DetailsData {
  String title = '';
  bool isLoading = true;
  String overview = '';
  DetailsPosterData posterData = DetailsPosterData();
  DetailsMovieNameData movieNameData =
  DetailsMovieNameData(name: '', year: '');
  DetailsScoreData scoreData = DetailsScoreData(voteAverage: 0);
  String summary = '';
  List<List<DetailsMoviePeoplesData>> peopleData =
  const <List<DetailsMoviePeoplesData>>[];
  List<DetailsMovieActorsData>actorsData =
  const <DetailsMovieActorsData>[];
}


class DetailsPosterData {
  final String? backdropPath;
  final String? posterPath;
  final bool isFavorite;

  IconData get favoriteIcon =>
      isFavorite ? Icons.favorite : Icons.favorite_outline;

  DetailsPosterData(
      {this.backdropPath, this.posterPath, this.isFavorite = false});

  DetailsPosterData copyWith(
      {final String? backdropPath,
        final String? posterPath,
        final bool? isFavorite}) {
    return DetailsPosterData(
      backdropPath: backdropPath ?? this.backdropPath,
      posterPath: posterPath ?? this.posterPath,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class DetailsMovieNameData {
  final String? name;
  final String year;
  DetailsMovieNameData({required this.name, required this.year});
}

class DetailsScoreData {
  final String? trailerKey;
  final double voteAverage;

  DetailsScoreData({this.trailerKey, required this.voteAverage});
}

class DetailsMoviePeoplesData {
  final String name;
  final String job;

  DetailsMoviePeoplesData({required this.name, required this.job});
}

class DetailsMovieActorsData {
  final String name;
  final String character;
  final String? profilePath;

  DetailsMovieActorsData(
      {required this.name, required this.character, this.profilePath});
}
