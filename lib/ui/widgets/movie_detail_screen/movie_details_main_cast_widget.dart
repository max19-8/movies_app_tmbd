import 'package:flutter/material.dart';
import 'package:movies_app_tmbd/data/api_client/image_downloader.dart';
import 'package:provider/provider.dart';
import 'details_model.dart';

class MovieDetailsMainCastWidget extends StatelessWidget {
  const MovieDetailsMainCastWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ColoredBox(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Top Billed Cast',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(
            height: 250,
            child: Scrollbar(
              child: _ActorListWidget(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: TextButton(
              onPressed: () {},
              child: const Text('Full Cast & Crew',style: TextStyle(color: Colors.black87,fontSize: 17),),
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
    final data = context.select(( NewModel model ) => model.data.actorsData);
    if( data.isEmpty) return  SizedBox.fromSize();
    return ListView.builder(
    itemCount: data.length,
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
    final model = context.read<NewModel>();
    var  actor = model.data.actorsData[actorIndex];
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
              Image.network((ImageDownloader.imageUrl(profilePath)),fit: BoxFit.fitWidth,)
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
