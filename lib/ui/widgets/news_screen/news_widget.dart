import 'package:flutter/material.dart';
import 'package:movies_app_tmbd/data/api_client/image_downloader.dart';
import 'package:movies_app_tmbd/ui/entity/result_list_row_data.dart';
import 'package:movies_app_tmbd/ui/widgets/news_screen/news_view_model.dart';
import 'package:provider/provider.dart';
class NewsWidget extends StatefulWidget {
  const NewsWidget({Key? key}) : super(key: key);

  @override
  State<NewsWidget> createState() => _NewsWidgetState();
}

class _NewsWidgetState extends State<NewsWidget> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final locale = Localizations.localeOf(context);
    context.read<NewsViewModel>().setupLocale(locale);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10,left: 20,bottom: 6),
            child: Text('Предстоящие фильмы',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.left,),
          ),
        SizedBox(height: 250, child: _UpcomingMoviesWidget()),
          Padding(
            padding: EdgeInsets.only(top: 10,left: 20,bottom: 6),
            child: Text('Сериалы в тренде',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.left,),
          ),
          SizedBox(height: 250, child: _TrendingTvShowWidget()),
          Padding(
            padding: EdgeInsets.only(top: 10,left: 20,bottom: 6),
            child: Text('Фильмы в тренде',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.left,),
          ),
          SizedBox(height: 250, child: _TrendingMoviesWidget()),

    ]
      ),
    );
  }
}



class _UpcomingMoviesWidget extends StatelessWidget {
  const _UpcomingMoviesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model =  context.watch<NewsViewModel>();
    var movies = model.movies;
    return ListView.builder(
        scrollDirection: Axis.horizontal,
      //  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemCount: movies.length,
        itemExtent: 300,
        itemBuilder: (BuildContext context, int index) {
          model.showMovieAtIndex(index);
          return  _MoviesItemWidget(index: index,movies: movies,);
        });
  }
}

class _TrendingMoviesWidget extends StatelessWidget {
  const _TrendingMoviesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model =  context.watch<NewsViewModel>();
    final movies = model.trendingMovies;
    return ListView.builder(
    //    padding: const EdgeInsets.only(top: 10),
        scrollDirection: Axis.horizontal,
        //keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemCount: movies.length ,
        itemExtent: 300,
        itemBuilder: (BuildContext context, int index) {
          return  _MoviesItemWidget(index: index,movies: movies,);
        });
  }
}

class _TrendingTvShowWidget extends StatelessWidget {
  const _TrendingTvShowWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model =  context.watch<NewsViewModel>();
    final tvShows = model.trendingTvShow;
    return ListView.builder(
       // padding: const EdgeInsets.only(top: 70),
        scrollDirection: Axis.horizontal,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemCount: tvShows.length,
        itemExtent: 200,
        itemBuilder: (BuildContext context, int index) {
          return  _TvShowItemWidget(index: index,tvShows: tvShows,);
        });
  }
}

class _MoviesItemWidget extends StatelessWidget {
  final int index;
  final List<ResultListRowData> movies;

  const _MoviesItemWidget({Key? key, required this.index,required this.movies}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final movie = movies[index];
    final posterPath = movie.posterPath;
    final model =  context.watch<NewsViewModel>();
    return Padding(
      padding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border:
              Border.all(color: Colors.black.withOpacity(0.2)),
              borderRadius:
              const BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, 2),
                  blurRadius: 8,
                ),
              ],
            ),
            clipBehavior: Clip.hardEdge,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                posterPath != null ? Image.network(ImageDownloader.imageUrl(posterPath)) :Image.asset('assets/images/placeholder.jpg'),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          movie.title ,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          movie.overview ?? "Описание недоступно",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: ()  => model.onMovieTap(context, index,movies),
            ),
          ),
        ],
      ),
    );
  }
  }

class _TvShowItemWidget extends StatelessWidget {
  final int index;
  final List<ResultListRowData> tvShows;
  const _TvShowItemWidget({Key? key, required this.index,required this.tvShows}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tvShow = tvShows[index];
    final posterPath = tvShow.posterPath;
    final model =  context.watch<NewsViewModel>();
    return Padding(
      padding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border:
              Border.all(color: Colors.black.withOpacity(0.2)),
              borderRadius:
              const BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, 2),
                  blurRadius: 8,
                ),
              ],
            ),
            clipBehavior: Clip.hardEdge,
            child: posterPath != null ? Image.network(ImageDownloader.imageUrl(posterPath) ) :Image.asset('assets/images/placeholder.jpg'),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => model.onTvShowTap(context, index,tvShows),
            ),
          ),
        ],
      ),
    );
  }
  }