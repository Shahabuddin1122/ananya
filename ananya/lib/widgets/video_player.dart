import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayer extends StatefulWidget {
  final String id;
  const VideoPlayer({required this.id, super.key});

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: 'https://www.youtube.com/watch?v=a0oa3Qiz5tw',
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: true,
      ),
    );
    _controller.addListener(listener);
  }

  void listener() {
    print('Player state changed');
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
      progressIndicatorColor: Colors.amber,
      progressColors: const ProgressBarColors(
        playedColor: Colors.amber,
        handleColor: Colors.amberAccent,
      ),
      onReady: () {
        _controller.addListener(listener);
      },
    );
  }
}
