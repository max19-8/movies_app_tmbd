import 'package:flutter/material.dart';
import 'package:movies_app_tmbd/library/Widgets/inherited/provider.dart';
import 'package:movies_app_tmbd/movie_detail_screen/movie_details_model.dart';
import 'package:movies_app_tmbd/movie_trailer/movie_trailer_widget.dart';
import 'package:movies_app_tmbd/widgets/main_screen/main_screen_model.dart';
import '../movie_detail_screen/movie_detail_widget.dart';
import '../widgets/auth_screen/auth_model.dart';
import '../widgets/auth_screen/auth_widget.dart';
import '../widgets/main_screen/main_widget.dart';

abstract class MainNavigationRouteNames{
  static const auth = 'auth';
  static const mainScreen = '/';
  static const movieDetails = '/movie_details_screen';
  static const movieDetailsTrailer = '/movie_details_screen/trailer';
}

class MainNavigation {

  String initialRoute(bool isAuth) => isAuth ? MainNavigationRouteNames.mainScreen : MainNavigationRouteNames.auth;
  final routes = <String, Widget Function(BuildContext)>{
    MainNavigationRouteNames.auth: (context) => NotifierProvider(
      create: () => AuthModel(), child: const AuthWidget(),),
    MainNavigationRouteNames.mainScreen: (context) => NotifierProvider(
      create: () => MainScreenModel(), child: const MainMidget(),),

  };

  Route<Object> onGenerateRoute(RouteSettings settings){
    switch(settings.name){
      case MainNavigationRouteNames.movieDetails:
        final arguments = settings.arguments;
        final movieId = arguments is int ? arguments : 0;
        return MaterialPageRoute(
            builder: (context) => NotifierProvider(create: () => 
                MovieDetailsModel(movieId: movieId),
              child:  const MovieDetailWidget(),),
        );
      case MainNavigationRouteNames.movieDetailsTrailer:
        final arguments = settings.arguments;
        final youTubeKey = arguments is String  ? arguments : '';
        return MaterialPageRoute(
          builder: (context) =>  MovieTrailerWidget(youTubeKey: youTubeKey),
        );
      default:
        const widget = Text(" NAVIGATION ERROR!");
        return MaterialPageRoute(builder: (context) => widget);
    }

  }
}
