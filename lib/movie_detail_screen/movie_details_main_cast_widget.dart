import 'package:flutter/material.dart';
import '../domain/api_client/api_client.dart';
import '../library/Widgets/inherited/provider.dart';
import 'movie_details_model.dart';

class MovieDetailsMainCastWidget extends StatelessWidget {
  const MovieDetailsMainCastWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ColoredBox(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Top Billed Cast',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(
            height: 250,
            child: Scrollbar(
              child: _ActorListWidget(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: TextButton(
              onPressed: () {},
              child: Text('Full Cast & Crew',style: TextStyle(color: Colors.black87,fontSize: 17),),
            ),
          )
    ],
    )
    );
  }
}

class _ActorListWidget extends StatelessWidget {
  const _ActorListWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    var  casts = model?.movieDetails?.credits.cast;
    if(casts == null || casts.isEmpty) return const SizedBox.shrink();
    return ListView.builder(
    itemCount: casts.length,
    itemExtent: 122,
    scrollDirection: Axis.horizontal,
    itemBuilder: (BuildContext context,int index){
      return _ActorItemWidget(actorIndex: index,);
    },
    );
  }
}

class _ActorItemWidget extends StatelessWidget {
  final int actorIndex;
  const _ActorItemWidget({
    Key? key,
    required this.actorIndex
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.read<MovieDetailsModel>(context);
    var  actor = model!.movieDetails!.credits.cast[actorIndex];
    final profilePath = actor.profilePath;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DecoratedBox(
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
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          clipBehavior: Clip.hardEdge,
          child: Column(
            children: [
              profilePath != null ?
              Image.network(ApiClient.imageUrl(profilePath),fit: BoxFit.fitWidth,)
              : Image.asset('assets/images/placeholder.jpg', fit: BoxFit.fitWidth),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(actor.name,maxLines: 2,style: const TextStyle(fontWeight: FontWeight.bold),),
                    const  SizedBox(height: 7),
                      Text(actor.character,maxLines: 1,),
                    ],
                  ),
                ),
              ),

          ],),
        ),
      ),
    );
  }
}
