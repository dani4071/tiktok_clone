import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class customVideoPlayer extends StatefulWidget {

  final String videoFilePath;

  const customVideoPlayer({super.key, required this.videoFilePath});

  @override
  State<customVideoPlayer> createState() => _customVideoPlayerState();
}

class _customVideoPlayerState extends State<customVideoPlayer> {
  
  VideoPlayerController? playerController;


  @override
  void initState() {
    super.initState();
    
    playerController = VideoPlayerController.network(widget.videoFilePath)
    ..initialize().then((value){
      playerController!.play();
      // playerController!.setLooping(true);
      playerController!.setVolume(2);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    playerController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        color: Colors.yellow,
      ),
      child: VideoPlayer(
        playerController!
      ),
    );
  }
}
