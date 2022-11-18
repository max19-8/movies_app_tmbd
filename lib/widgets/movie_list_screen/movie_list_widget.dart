import 'package:flutter/material.dart';
import 'package:movies_app_tmbd/domain/api_client/image_downloader.dart';
import 'package:movies_app_tmbd/navigation/main_navigation.dart';
import 'package:movies_app_tmbd/widgets/movie_list_screen/movie_list_cubit.dart';
import 'package:provider/provider.dart';

class MovieListWidget extends StatefulWidget {
  const MovieListWidget({Key? key}) : super(key: key);

  @override
  State<MovieListWidget> createState() => _MovieListWidgetState();
}

class _MovieListWidgetState extends State<MovieListWidget> {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = Localizations.localeOf(context);
    context.read<MovieListCubit>().setupLocale(locale.toLanguageTag());
  }


  @override
  Widget build(BuildContext context) {

    return Stack(
      children: const [
        _MovieListWidget(),
        _SearchWidget(),
      ],
    );
  }
}

class _SearchWidget extends StatelessWidget {
  const _SearchWidget({
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final cubit =  context.read<MovieListCubit>();
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextField(
        onChanged: cubit.searchMovie,
        decoration: InputDecoration(
          labelText: 'Search',
          border: const OutlineInputBorder(),
          fillColor: Colors.white.withAlpha(235),
          filled: true,
        ),
      ),
    );
  }
}

class _MovieListWidget extends StatelessWidget {
  const _MovieListWidget({
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final cubit =  context.watch<MovieListCubit>();
    return ListView.builder(
        padding: const EdgeInsets.only(top: 70),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemCount: cubit.state.movies.length  ,
        itemExtent: 163,
        itemBuilder: (BuildContext context, int index) {
          cubit.showMovieAtIndex(index);
          return  _MovieListRowWidget(index: index);
        });
  }
}

class _MovieListRowWidget extends StatelessWidget {
  final int index;
  const _MovieListRowWidget({Key? key,required this.index}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final cubit =  context.read<MovieListCubit>();
    final movie = cubit.state.movies[index];
    final posterPath = movie.posterPath;
    return Padding(
      padding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
            child: Row(
              children: [
                posterPath != null ? Image.network(ImageDownloader.imageUrl(posterPath) ,width: 95,) :Image.asset('assets/images/placeholder.jpg',width: 95,),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        movie.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        movie.releaseDate,
                        style: const TextStyle(color: Colors.grey),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        movie.overview,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => _onMovieTap(context, movie.id),
            ),
          ),
        ],
      ),
    );
  }
  void _onMovieTap(BuildContext context, int movieId) {
    Navigator.of(context)
        .pushNamed(MainNavigationRouteNames.movieDetails, arguments: movieId);
  }
}
