import 'package:flutter/material.dart';
import 'package:movies_app_tmbd/data/api_client/account_api_client.dart';
import 'package:movies_app_tmbd/data/api_client/auth_api_client.dart';
import 'package:movies_app_tmbd/data/api_client/movie_api_client.dart';
import 'package:movies_app_tmbd/data/api_client/network_client.dart';
import 'package:movies_app_tmbd/data/api_client/news_api_client.dart';
import 'package:movies_app_tmbd/data/services/auth_service.dart';
import 'package:movies_app_tmbd/data/services/movie_list_service.dart';
import 'package:movies_app_tmbd/data/services/movie_service.dart';
import 'package:movies_app_tmbd/data/services/news_service.dart';
import 'package:movies_app_tmbd/data/services/popular_movie_service.dart';
import 'package:movies_app_tmbd/data/services/top_rated_movie_service.dart';
import 'package:movies_app_tmbd/domain/data_providers/session_data_provider.dart';
import 'package:movies_app_tmbd/library/FlutterSecureStorage/secure_storage.dart';
import 'package:movies_app_tmbd/library/HttpClient/app_http_client.dart';
import 'package:movies_app_tmbd/main.dart';
import 'package:movies_app_tmbd/my_app.dart';
import 'package:movies_app_tmbd/navigation/main_navigation.dart';
import 'package:movies_app_tmbd/navigation/main_navigation_actions.dart';
import 'package:movies_app_tmbd/ui/widgets/auth_screen/auth_model.dart';
import 'package:movies_app_tmbd/ui/widgets/auth_screen/auth_widget.dart';
import 'package:movies_app_tmbd/ui/widgets/detail_screen/movie_details/details_model.dart';
import 'package:movies_app_tmbd/ui/widgets/detail_screen/tv_show_details/tv_show_detail_widget.dart';
import 'package:movies_app_tmbd/ui/widgets/detail_screen/tv_show_details/tv_show_details_model.dart';
import 'package:movies_app_tmbd/ui/widgets/loader_screen/loader_view_model.dart';
import 'package:movies_app_tmbd/ui/widgets/loader_screen/loader_widget.dart';
import 'package:movies_app_tmbd/ui/widgets/main_screen/main_widget.dart';
import 'package:movies_app_tmbd/ui/widgets/movie_list_screen/movie_list_view_model.dart';
import 'package:movies_app_tmbd/ui/widgets/movie_list_screen/movie_list_widget.dart';
import 'package:movies_app_tmbd/ui/widgets/movie_trailer/movie_trailer_widget.dart';
import 'package:movies_app_tmbd/ui/widgets/news_screen/news_view_model.dart';
import 'package:movies_app_tmbd/ui/widgets/news_screen/news_widget.dart';
import 'package:provider/provider.dart';

import '../ui/widgets/detail_screen/movie_details/movie_detail_widget.dart';

AppFactory makeFactory() => _AppFactoryDefault();

class _AppFactoryDefault implements AppFactory {
  final _diContainer = _DiContainer();

  _AppFactoryDefault();

  @override
  Widget makeApp() => MyApp(
        navigation: _diContainer._makeMyAppNavigation(),
      );
}

class _DiContainer {
  _DiContainer();

  final _mainNavigationActions = const MainNavigationActions();
  final SecureStorage _secureStorage = const SecureStorageDefault();
  final AppHttpClient _appHttpClient = AppHttpClientDefault();

  ScreenFactory _makeScreenFactory() => ScreenFactoryDefault(this);

  MyAppNavigation _makeMyAppNavigation() =>
      MainNavigation(_makeScreenFactory());

  SessionDataProvider _makeSessionDataProvider() =>
      SessionDataProviderDefault(_secureStorage);

  NetworkClient _makeNetworkClient() => NetworkClientDefault(_appHttpClient);

  AuthApiClient _makeAuthApiClient() =>
      AuthApiClientDefault(_makeNetworkClient());

  AccountApiClient _makeAccountApiClient() =>
      AccountApiClientDefault(_makeNetworkClient());

  AuthService _makeAuthService() => AuthService(
      authApiClient: _makeAuthApiClient(),
      accountApiClient: _makeAccountApiClient(),
      sessionDataProvider: _makeSessionDataProvider());



  MovieApiClient _makeMovieApiClient() =>
      MovieApiClientDefault(_makeNetworkClient());


  NewsApiClient _makeNewsApiClient() =>
      NewsApiClientDefault(_makeNetworkClient());

  NewsService _makeNewsService() => NewsService(
     newsApiClient: _makeNewsApiClient(),accountApiClient: _makeAccountApiClient(),
      sessionDataProvider: _makeSessionDataProvider());

  MovieService _makeMovieService() => MovieService(
      movieApiClient: _makeMovieApiClient(),
      accountApiClient: _makeAccountApiClient(),
      sessionDataProvider: _makeSessionDataProvider());

  MovieListService _makePopularListMovieService() => PopularMovieService(movieApiClient: _makeMovieApiClient());
  MovieListService _makeTopRatedListMovieService() => TopRatedMoviesService(movieApiClient: _makeMovieApiClient());

  AuthViewModel _makeAuthViewModel() => AuthViewModel(
      mainNavigationActions: _mainNavigationActions,
      loginProvider: _makeAuthService());

  LoaderViewModel _makeLoaderViewModel(BuildContext context) =>
      LoaderViewModel(context: context, authStatusProvider: _makeAuthService());

  MovieDetailsModel _makeMovieDetailsViewModel(int movieId) => MovieDetailsModel(movieId,
      authProvider: _makeAuthService(),
      movieProvider: _makeMovieService(),
      navigationActions: _mainNavigationActions);

  TvShowDetailsModel _makeTvShowDetailsViewModel(int tvShowId) => TvShowDetailsModel(tvShowId,
      authProvider: _makeAuthService(),
      movieProvider: _makeNewsService(),
      navigationActions: _mainNavigationActions);

  MovieListViewModel _makePopularMovieListViewModel() => MovieListViewModel(_makeMovieService(),_makePopularListMovieService());
  MovieListViewModel _makeTopRatedMovieListViewModel() => MovieListViewModel(_makeMovieService(),_makeTopRatedListMovieService());
  NewsViewModel _makeNewsViewModel() => NewsViewModel(_makeNewsService());
}

class ScreenFactoryDefault implements ScreenFactory {
  final _DiContainer _diContainer;

  const ScreenFactoryDefault(this._diContainer);

  @override
  Widget makeLoaderWidget() {
    return Provider(
      create: (context) => _diContainer._makeLoaderViewModel(context),
      lazy: false,
      child: const LoaderWidget(),
    );
  }

  @override
  Widget makeAuthWidget() {
    return ChangeNotifierProvider(
        create: (_) => _diContainer._makeAuthViewModel(),
        child: const AuthWidget());
  }

  @override
  Widget makeMainWidget() {
    return MainMidget(
      screenFactory: this, authService: _diContainer._makeAuthService(),navigationActions: _diContainer._mainNavigationActions,
      
    );
  }
  @override
  Widget makeMovieDetailsWidget(int movieId) {
    return ChangeNotifierProvider(
      create: (_) =>  _diContainer._makeMovieDetailsViewModel(movieId),
      child: const MovieDetailWidget(),
    );
  }
  @override
  Widget makeMovieTrailerWidget(String youTubeKey) {
    return MovieTrailerWidget(youTubeKey: youTubeKey);
  }

  @override
  Widget makePopularMovieListWidget() {
    return ChangeNotifierProvider(
        create: (_) => _diContainer._makePopularMovieListViewModel(),
        child: const MovieListWidget());
  }
  @override
  Widget makeTopRatedListWidget() {
    return ChangeNotifierProvider(
        create: (_) => _diContainer._makeTopRatedMovieListViewModel(),
        child: const MovieListWidget());
  }

  @override
  Widget makeNewsWidget() {
    return ChangeNotifierProvider(
        create: (_) => _diContainer._makeNewsViewModel(),
        child: const NewsWidget());
  }

  @override
  Widget makeTvShowDetailsWidget(int tvShowId) {
    return ChangeNotifierProvider(
        create: (_) =>  _diContainer._makeTvShowDetailsViewModel(tvShowId),
    child: const TvShowDetailWidget());
  }
}