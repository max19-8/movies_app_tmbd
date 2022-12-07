import 'package:flutter/material.dart';
import '../my_app.dart';
import 'main_navigation_route_names.dart';

 abstract class ScreenFactory {
  const ScreenFactory();
  Widget makeLoaderWidget();
  Widget makeAuthWidget();
  Widget makeMainWidget() ;
  Widget makeMovieDetailsWidget(int movieId);
  Widget makeMovieTrailerWidget(String youTubeKey) ;
  Widget makePopularMovieListWidget();
  Widget makeTopRatedListWidget();
}


class MainNavigation implements MyAppNavigation {
   final ScreenFactory screenFactory;
   const MainNavigation(this.screenFactory);

   @override
  Map<String, Widget Function(BuildContext)> get routes => {
    MainNavigationRouteNames.loaderScreen: (_) => screenFactory.makeLoaderWidget(),
    MainNavigationRouteNames.auth: (_) =>  screenFactory.makeAuthWidget(),
    MainNavigationRouteNames.mainScreen: (_) => screenFactory.makeMainWidget(),

  };

  @override
  Route<Object> onGenerateRoute(RouteSettings settings){
    switch(settings.name){
      case MainNavigationRouteNames.movieDetails:
        final arguments = settings.arguments;
        final movieId = arguments is int ? arguments : 0;
        return MaterialPageRoute(
            builder: (context) =>screenFactory.makeMovieDetailsWidget(movieId),
        );
      case MainNavigationRouteNames.movieDetailsTrailer:
        final arguments = settings.arguments;
        final youTubeKey = arguments is String  ? arguments : '';
        return MaterialPageRoute(
          builder: (_) => screenFactory.makeMovieTrailerWidget(youTubeKey),
        );
      default:
        const widget = Text(" NAVIGATION ERROR!");
        return MaterialPageRoute(builder: (_) => widget);
    }
  }

}
