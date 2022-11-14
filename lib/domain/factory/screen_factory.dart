import 'package:flutter/material.dart';
import 'package:movies_app_tmbd/library/Widgets/loader_screen/loader_view_model.dart';
import 'package:movies_app_tmbd/library/Widgets/loader_screen/loader_widget.dart';
import 'package:movies_app_tmbd/movie_detail_screen/movie_detail_widget.dart';
import 'package:movies_app_tmbd/movie_detail_screen/movie_details_model.dart';
import 'package:movies_app_tmbd/movie_trailer/movie_trailer_widget.dart';
import 'package:movies_app_tmbd/widgets/auth_screen/auth_model.dart';
import 'package:movies_app_tmbd/widgets/auth_screen/auth_widget.dart';
import 'package:movies_app_tmbd/widgets/main_screen/main_widget.dart';
import 'package:movies_app_tmbd/widgets/movie_list_screen/movie_list_model.dart';
import 'package:movies_app_tmbd/widgets/movie_list_screen/movie_list_widget.dart';
import 'package:provider/provider.dart';

class ScreenFactory {
  Widget makeLoaderWidget() {
    return Provider(
      create: (context) => LoaderViewModel(context),
      lazy: false,
      child: const LoaderWidget(),
    );
  }

  Widget makeAuthWidget() {
    return ChangeNotifierProvider(
        create: (_) => AuthViewModel(),
        child: const AuthWidget());
  }

  Widget makeMainWidget() {
    return  const MainMidget();
  }

  Widget makeMovieDetailsWidget(int movieId) {
    return ChangeNotifierProvider(
      create: (_) => MovieDetailsViewModel(movieId),
      child:  const MovieDetailWidget(),);
  }

  Widget makeMovieTrailerWidget(String youTubeKey) {
    return  MovieTrailerWidget(youTubeKey: youTubeKey);
  }

  Widget makeMovieListWidget() {
    return ChangeNotifierProvider(
        create: (_) => MovieListViewModel(),
        child: const MovieListWidget());
  }
}