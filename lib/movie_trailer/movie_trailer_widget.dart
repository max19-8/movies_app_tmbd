import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieTrailerWidget extends StatefulWidget {
  final String youTubeKey;
  const MovieTrailerWidget({Key? key,required this.youTubeKey}) : super(key: key);

  @override
  State<MovieTrailerWidget> createState() => _MovieTrailerWidgetState();
}

class _MovieTrailerWidgetState extends State<MovieTrailerWidget> {

 late  final  YoutubePlayerController _controller;

 @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.youTubeKey,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: true,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
   final _player = YoutubePlayer(
     controller: _controller,
     showVideoProgressIndicator: true);

    return YoutubePlayerBuilder(
       player:_player, builder: (context , _player ) {
         return Scaffold(appBar: AppBar(title: const Text('Трейлер'),),
           body: Center(child: _player),
         );
    },
   );
  }
}
