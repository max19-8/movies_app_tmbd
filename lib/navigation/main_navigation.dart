import 'package:flutter/material.dart';
import 'package:movies_app_tmbd/domain/factory/screen_factory.dart';


abstract class MainNavigationRouteNames{
  static const loaderScreen = '/';
  static const auth = '/auth';
  static const mainScreen = 'main_screen';
  static const movieDetails = '/mainScreen/movie_details_screen';
  static const movieDetailsTrailer = '/mainScreen/movie_details_screen/trailer';

}

class MainNavigation {
  static final _screenFactory = ScreenFactory();

  final routes = <String, Widget Function(BuildContext)>{
    MainNavigationRouteNames.loaderScreen: (_) => _screenFactory.makeLoaderWidget(),
    MainNavigationRouteNames.auth: (_) =>  _screenFactory.makeAuthWidget(),
    MainNavigationRouteNames.mainScreen: (_) => _screenFactory.makeMainWidget(),

  };

  Route<Object> onGenerateRoute(RouteSettings settings){
    switch(settings.name){
      case MainNavigationRouteNames.movieDetails:
        final arguments = settings.arguments;
        final movieId = arguments is int ? arguments : 0;
        return MaterialPageRoute(
            builder: (context) =>_screenFactory.makeMovieDetailsWidget(movieId),
        );
      case MainNavigationRouteNames.movieDetailsTrailer:
        final arguments = settings.arguments;
        final youTubeKey = arguments is String  ? arguments : '';
        return MaterialPageRoute(
          builder: (_) => _screenFactory.makeMovieTrailerWidget(youTubeKey),
        );
      default:
        const widget = Text(" NAVIGATION ERROR!");
        return MaterialPageRoute(builder: (_) => widget);
    }
  }
  static void resetNavigation(BuildContext context){
    Navigator.of(context).
    pushNamedAndRemoveUntil(MainNavigationRouteNames.loaderScreen,
            (route) => false);
  }
}
