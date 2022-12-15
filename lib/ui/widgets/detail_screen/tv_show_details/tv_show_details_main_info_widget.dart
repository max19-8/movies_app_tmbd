import 'package:flutter/material.dart';
import 'package:movies_app_tmbd/data/api_client/image_downloader.dart';
import 'package:movies_app_tmbd/navigation/main_navigation_route_names.dart';
import 'package:movies_app_tmbd/ui/widgets/custom_widgets/radial_percent_widget.dart';
import 'package:movies_app_tmbd/ui/widgets/detail_screen/entity/details_data.dart';
import 'package:provider/provider.dart';

import 'tv_show_details_model.dart';


class TvShowDetailsMainInfoWidget extends StatelessWidget {
  const TvShowDetailsMainInfoWidget({Key? key}) : super(key: key);

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
    final model = context.read<TvShowDetailsModel>();
    final posterData = context.select((TvShowDetailsModel model) => model.data.posterData);
    final backdropPath = posterData.backdropPath;
    final posterPath =posterData.posterPath;
    return AspectRatio(
      aspectRatio: 390 / 219,
      child: Stack(children: [

        backdropPath != null
            ? Image.network(ImageDownloader.imageUrl(backdropPath))
            :
        const SizedBox.shrink(),
        Positioned(
          top: 20,
          left: 20,
          bottom: 20,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child:
            posterPath != null ? Image.network(ImageDownloader.imageUrl(posterPath)) :
            const SizedBox.shrink(),
          ),
        ),
        Positioned(
            top: 5,
            right: 5,
            child: IconButton(onPressed: () => model.toggleFavorite(context),  icon: Icon (posterData.favoriteIcon,color: Colors.red,))
        )
      ],),
    );
  }
}

class _MovieNameWidget extends StatelessWidget {
  const _MovieNameWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final data = context.select((TvShowDetailsModel model) => model.data.movieNameData);
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        maxLines: 3,
        text: TextSpan(
          children: [
            TextSpan(text: data.name,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 17)),
            TextSpan(text: data.year,
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
    final scoreData = context.select((TvShowDetailsModel model) => model.data.scoreData);
    final voteAverage = scoreData.voteAverage;
    final trailerKey = scoreData.trailerKey;
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
    final summary = context.select((TvShowDetailsModel model) => model.data.summary);
    return ColoredBox(
      color: const Color.fromRGBO(22, 21, 25, 1.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Text(summary,
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
    final overview = context.select((TvShowDetailsModel model) => model.data.overview);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(overview,
          style: const TextStyle(
              fontWeight: FontWeight.w400, fontSize: 16, color: Colors.white)),
    );
  }
}


class _PeopleWidget extends StatelessWidget {
  const _PeopleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var crew = context.select(( TvShowDetailsModel model ) => model.data.peopleData);
    if (crew.isEmpty) return const SizedBox.shrink();


    return Column(
      children:
      crew.map((chunk) =>
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: _PeopleWidgetRow(employees: chunk),
          )).toList(),

    );
  }
}


class _PeopleWidgetRow extends StatelessWidget {
  final List<DetailsMoviePeoplesData> employees;

  const _PeopleWidgetRow({Key? key, required this.employees}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:
      employees.map((employee) => _PeopleWidgetRowItem(employee: employee))
          .toList(),

    );
  }
}
class _PeopleWidgetRowItem extends StatelessWidget {
  final DetailsMoviePeoplesData employee;
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