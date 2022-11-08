import 'package:flutter/material.dart';
import 'package:movies_app_tmbd/library/Widgets/inherited/provider.dart';
import 'package:movies_app_tmbd/movie_detail_screen/movie_details_main_info_widget.dart';
import 'package:movies_app_tmbd/movie_detail_screen/movie_details_main_cast_widget.dart';
import 'package:movies_app_tmbd/movie_detail_screen/movie_details_model.dart';
import 'package:movies_app_tmbd/my_app_model.dart';

class MovieDetailWidget extends StatefulWidget {
  const MovieDetailWidget({Key? key}) : super(key: key);

  @override
  State<MovieDetailWidget> createState() => _MovieDetailWidgetState();
}

class _MovieDetailWidgetState extends State<MovieDetailWidget> {
  @override
  void initState() {
    super.initState();
   final model =  NotifierProvider.read<MovieDetailsModel>(context);
   final appModel =  Provider.read<MyAppModel>(context);
   model?.onSessionExpired = () => appModel?.resetSession(context);
  }


  void didChangeDependencies() {
    super.didChangeDependencies();
    NotifierProvider.read<MovieDetailsModel>(context)?.setupLocale(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const _TitleWidget()),
      body:
        const ColoredBox(
          color: Color.fromRGBO(24, 23, 27, 1.0),
          child: BodyWidget(),
        )
    );
  }
}

class BodyWidget extends StatelessWidget {
  const BodyWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model =   NotifierProvider.watch<MovieDetailsModel>(context);
    final movieId = model?.movieDetails;
    if(movieId == null){
      return const Center(child: CircularProgressIndicator());
    }


    return ListView(
      children:const [
        MovieDetailsMainInfoWidget(),
        SizedBox(height: 30,),
        MovieDetailsMainCastWidget()
      ],
    );
  }
}

class _TitleWidget extends StatelessWidget {
  const _TitleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  final model =   NotifierProvider.watch<MovieDetailsModel>(context);
    return  Text(model?.movieDetails?.title ?? 'Загрузка...');
  }
}
