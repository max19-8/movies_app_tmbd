import 'package:flutter/material.dart';
import 'package:movies_app_tmbd/ui/widgets/detail_screen/movie_details/details_model.dart';
import 'package:movies_app_tmbd/ui/widgets/detail_screen/movie_details/movie_details_main_cast_widget.dart';
import 'package:movies_app_tmbd/ui/widgets/detail_screen/movie_details/movie_details_main_info_widget.dart';
import 'package:provider/provider.dart';


class MovieDetailWidget extends StatefulWidget {
  const MovieDetailWidget({Key? key}) : super(key: key);

  @override
  State<MovieDetailWidget> createState() => _MovieDetailWidgetState();
}

class _MovieDetailWidgetState extends State<MovieDetailWidget> {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final locale = Localizations.localeOf(context);
    Future.microtask(() =>
        context.read<MovieDetailsModel>().setupLocale(context,locale));
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
    final isLoading =context.select((MovieDetailsModel model) => model.data.isLoading );
    if(isLoading){
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
  final title =  context.select((MovieDetailsModel model) => model.data.title );
    return  Text(title);
  }
}
