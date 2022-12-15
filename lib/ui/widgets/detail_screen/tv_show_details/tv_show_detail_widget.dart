import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'tv_show_details_main_cast_widget.dart';
import 'tv_show_details_main_info_widget.dart';
import 'tv_show_details_model.dart';

class TvShowDetailWidget extends StatefulWidget {
  const TvShowDetailWidget({Key? key}) : super(key: key);

  @override
  State<TvShowDetailWidget> createState() => _TvShowDetailWidgetState();
}

class _TvShowDetailWidgetState extends State<TvShowDetailWidget> {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final locale = Localizations.localeOf(context);
    Future.microtask(() =>
        context.read<TvShowDetailsModel>().setupLocale(context,locale));
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
    final isLoading =context.select((TvShowDetailsModel model) => model.data.isLoading );
    if(isLoading){
      return const Center(child: CircularProgressIndicator());
    }
    return ListView(
      children:const [
        TvShowDetailsMainInfoWidget(),
        SizedBox(height: 30,),
        TvShowDetailsMainCastWidget()
      ],
    );
  }
}

class _TitleWidget extends StatelessWidget {
  const _TitleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title =  context.select((TvShowDetailsModel model) => model.data.title );
    return  Text(title);
  }
}