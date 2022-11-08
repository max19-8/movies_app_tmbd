import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movies_app_tmbd/domain/entity/movie_details.dart';

import '../domain/api_client/api_client.dart';
import '../domain/data_providers/session_data_provider.dart';

class MovieDetailsModel extends ChangeNotifier {
  final int movieId;

  MovieDetailsModel({required this.movieId});

  final _sessionDataProvider = SessionDataProvider();

  final _apiClient = ApiClient();
  String _locale = '';

  bool _isFavorite = false;

  bool get isFavorite => _isFavorite;

  late DateFormat _dateFormat;
  Future<void>? Function()? onSessionExpired;

  MovieDetails? _movieDetails;

  MovieDetails? get movieDetails => _movieDetails;

  String stringFromDate(DateTime? date) =>
      date != null ? _dateFormat.format(date) : '';

  Future<void> setupLocale(BuildContext context) async {
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (_locale == locale) return;
    _locale = locale;
    _dateFormat = DateFormat.yMMMd(locale);
    loadDetails();
  }

  Future<void> loadDetails() async {
    try {
      _movieDetails = await _apiClient.movieDetails(movieId, _locale);
      final sessionId = await _sessionDataProvider.getSessionId();
      if (sessionId != null) {
        _isFavorite = await _apiClient.isFavorite(movieId, sessionId);
      }
      notifyListeners();
    }on ApiClientException catch (e) {
      _handleApiClientException(e);
    }
  }

  Future<void> toggleFavorite() async {
    final accountId = await _sessionDataProvider.getAccountId();
    final sessionId = await _sessionDataProvider.getSessionId();
    print(sessionId);
    print(accountId);
    if (sessionId == null || accountId == null) return;
    _isFavorite = !_isFavorite;
    notifyListeners();
    try {
      await _apiClient.markAsFavorite(
          accountId: accountId,
          sessionId: sessionId,
          mediaType: ApiClientMediaType.movie,
          mediaId: movieId,
          isFavorite: _isFavorite);
    } on ApiClientException catch (e) {
      _handleApiClientException(e);
    }
  }

  void _handleApiClientException(ApiClientException exception) {
    switch (exception.type) {
      case ApiClientExceptionType.sessionExpired:
        onSessionExpired?.call();
        break;
      default:
        print(exception);
    }
  }
}
