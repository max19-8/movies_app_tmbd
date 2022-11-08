import 'package:flutter/material.dart';
import 'package:movies_app_tmbd/domain/entity/movie_details_credits.dart';
import 'package:movies_app_tmbd/library/Widgets/inherited/provider.dart';
import 'package:movies_app_tmbd/movie_detail_screen/movie_details_model.dart';

import '../domain/api_client/api_client.dart';
import '../widgets/custom_wodgets/radial_percent_widget.dart';
import '../../navigation/main_navigation.dart';

class MovieDetailsMainInfoWidget extends StatelessWidget {
  const MovieDetailsMainInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        _TopPosterWidget(),
        Padding(
          padding: EdgeInsets.all(20.0),
          child: _MovieNameWidget(),
        ),
        _ScoreWidget(),
        _SummaryWidget(),
        _OverviewWidget(),
        _DescriptionWidget(),
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: _PeopleWidget(),
        )
      ],
    );
  }
}


class _TopPosterWidget extends StatelessWidget {
  const _TopPosterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    final backdropPath = model?.movieDetails?.backdropPath;
    final posterPath = model?.movieDetails?.posterPath;
    return AspectRatio(
      aspectRatio: 390 / 219,
      child: Stack(children: [

        backdropPath != null
            ? Image.network(ApiClient.imageUrl(backdropPath))
            : const SizedBox.shrink(),
        Positioned(
          top: 20,
          left: 20,
          bottom: 20,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: posterPath != null ? Image.network(
                ApiClient.imageUrl(posterPath)) : const SizedBox.shrink(),
          ),
        ),
        Positioned(
          top: 5,
            right: 5,
            child: IconButton(onPressed: () => model?.toggleFavorite(),  icon: Icon (model?.isFavorite == true ? Icons.favorite :Icons.favorite_outline ,color: Colors.red,))
        )
      ],),
    );
  }
}


class _MovieNameWidget extends StatelessWidget {
  const _MovieNameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    var year = model?.movieDetails?.releaseDate?.year.toString();
    year = year != null ? ' ($year) ' : '';
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        maxLines: 3,
        text: TextSpan(
          children: [
            TextSpan(text: model?.movieDetails?.title ?? '',
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 17)),
            TextSpan(text: year,
                style: const TextStyle(
                    fontWeight: FontWeight.w400, fontSize: 16))
          ],
        ),
        selectionRegistrar: SelectionContainer.maybeOf(context),
        selectionColor: const Color(0xAF6694e8),
      ),
    );
  }
}

class _ScoreWidget extends StatelessWidget {
  const _ScoreWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final movieDetails = NotifierProvider
        .watch<MovieDetailsModel>(context)
        ?.movieDetails;
    var voteAverage = movieDetails?.voteAverage ?? 0;
    voteAverage = voteAverage * 10;
    final videos = movieDetails?.videos.results.where((video) =>
    video.type == 'Trailer' && video.site == "YouTube");
    final trailerKey = videos?.isNotEmpty == true ? videos?.first.key : null;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(onPressed: () {}, child: Row(
          children: [
            SizedBox(width: 40, height: 40, child: RadialPercentWidget(
              percent: voteAverage / 100,
              fillColor: const Color.fromARGB(255, 10, 23, 12),
              lineColor: const Color.fromARGB(255, 37, 203, 103),
              freeColor: const Color.fromARGB(255, 25, 54, 31),
              lineWidth: 3,
              child: Text(voteAverage.toStringAsFixed(0)),
            ),),
            const SizedBox(width: 10,),
            const Text('Оценка пользователей')
          ],
        )),
        Container(width: 1, height: 15, color: Colors.grey,),
        trailerKey != null ?
        TextButton(onPressed: () => Navigator.of(context).pushNamed(MainNavigationRouteNames.movieDetailsTrailer,arguments:trailerKey),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Icon(Icons.play_arrow),
                Text('Играть трейлер',maxLines: 1,)
              ],
            ),
        )
        : const  Text('Трейлер не найден',style: TextStyle(color: Colors.blue),),


      ],);
  }
}


class _SummaryWidget extends StatelessWidget {
  const _SummaryWidget({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    if (model == null) return const SizedBox.shrink();
    var texts = <String>[];
    final releaseDate = model.movieDetails?.releaseDate;
    if (releaseDate != null) {
      texts.add(model.stringFromDate(releaseDate));
    }
    final productionCountries = model.movieDetails?.productionCountries;
    if (productionCountries != null && productionCountries.isNotEmpty) {
      texts.add('(${productionCountries.first.iso31661})');
    }
    final runtime = model.movieDetails?.runtime ?? 0;
    final duration = Duration(minutes: runtime);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    texts.add('${hours}h ${minutes}m, ');

    final genres = model.movieDetails?.genres;
    if (genres != null && genres.isNotEmpty) {
      var genresNames = <String>[];
      for (var gen in genres) {
        if (gen.name != null) {
          genresNames.add(gen.name!);
        }
      }
      texts.add(genresNames.join(', '));
    }
    return ColoredBox(
      color: const Color.fromRGBO(22, 21, 25, 1.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Text(texts.join(' '),
            maxLines: 2,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Colors.white)),
      ),
    );
  }
}


class _OverviewWidget extends StatelessWidget {
  const _OverviewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Text('Обзор', style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white)),
    );
  }
}

class _DescriptionWidget extends StatelessWidget {
  const _DescriptionWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(model?.movieDetails?.overview ?? '',
          style: const TextStyle(
              fontWeight: FontWeight.w400, fontSize: 16, color: Colors.white)),
    );
  }
}


class _PeopleWidget extends StatelessWidget {
  const _PeopleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    var crew = model?.movieDetails?.credits.crew;
    if (crew == null || crew.isEmpty) return const SizedBox.shrink();
    crew = crew.length > 4 ? crew.sublist(0, 4) : crew;
    var crewChunks = <List<Employee>>[];
    for (var i = 0; i < crew.length; i += 2) {
      crewChunks.add(
          crew.sublist(i, i + 2 > crew.length ? crew.length : i + 2));
    }

    return Column(
      children:
      crewChunks.map((chunk) =>
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: _PeopleWidgetRow(employees: chunk),
          )).toList(),

    );
  }
}


class _PeopleWidgetRow extends StatelessWidget {
  final List<Employee> employees;

  const _PeopleWidgetRow({Key? key, required this.employees}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:
      employees.map((employe) => _PeopleWidgetRowItem(employee: employe))
          .toList(),

    );
  }
}

class _PeopleWidgetRowItem extends StatelessWidget {
  final Employee employee;

  const _PeopleWidgetRowItem({Key? key, required this.employee})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const nameStyle = TextStyle(
        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16);
    const jobTitleStyle = TextStyle(
        color: Colors.white, fontWeight: FontWeight.w400, fontSize: 16);
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(employee.name, style: nameStyle),
          Text(employee.job, style: jobTitleStyle)
        ],
      ),
    );
  }
}










