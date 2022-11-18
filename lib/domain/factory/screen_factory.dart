import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app_tmbd/domain/blocs/auth_bloc.dart';
import 'package:movies_app_tmbd/domain/blocs/movie_list_bloc.dart';
import 'package:movies_app_tmbd/library/Widgets/loader_screen/loader_view_cubit.dart';
import 'package:movies_app_tmbd/library/Widgets/loader_screen/loader_widget.dart';
import 'package:movies_app_tmbd/movie_detail_screen/movie_detail_widget.dart';
import 'package:movies_app_tmbd/movie_detail_screen/movie_details_model.dart';
import 'package:movies_app_tmbd/movie_trailer/movie_trailer_widget.dart';
import 'package:movies_app_tmbd/widgets/auth_screen/auth_view_cubit.dart';
import 'package:movies_app_tmbd/widgets/auth_screen/auth_widget.dart';
import 'package:movies_app_tmbd/widgets/main_screen/main_widget.dart';
import 'package:movies_app_tmbd/widgets/movie_list_screen/movie_list_cubit.dart';
import 'package:movies_app_tmbd/widgets/movie_list_screen/movie_list_widget.dart';
import 'package:provider/provider.dart';

class ScreenFactory {

  AuthBloc? _authBloc;

  Widget makeLoaderWidget() {
   final authBloc =  _authBloc ?? AuthBloc(AuthCheckStatusInProgressState());
   _authBloc = authBloc;
    return BlocProvider<LoaderViewCubit>(
      create: (_) => LoaderViewCubit(LoaderViewCubitState.unknown,authBloc),
      child: const LoaderWidget(),
    );
  }

  Widget makeAuthWidget() {
    final authBloc =  _authBloc ?? AuthBloc(AuthCheckStatusInProgressState());
    _authBloc = authBloc;
    return BlocProvider<AuthViewCubit>(
        create: (_) => AuthViewCubit(AuthViewCubitFormFillInProgressState(),authBloc),
        child: const AuthWidget());
  }

  Widget makeMainWidget() {
    _authBloc?.close();
    _authBloc = null;
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
    return BlocProvider<MovieListCubit>(
        create: (_) => MovieListCubit(
            movieListBloc: MovieListBloc(
              const  MovieListState.initial()
            ),
        ),
        child: const MovieListWidget());
  }
}
