import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musi/home_page.dart';
import 'package:flutter/services.dart';
import 'package:musi/service/video_api.dart';
import 'package:provider/provider.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoScreen extends StatefulWidget {
  final String youtubeID;
  final String youtubeTitle;

  VideoScreen({
    Key? key,
    required this.youtubeID,
    required this.youtubeTitle,
  }) : super(key: key);
  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late YoutubePlayerController controller;
  //late VideoProvider videoManager;
  bool isVideoPlaying = true; //video play or not
  double currentvol = 100;
  late int currentIndex = 0; //theo dõi vị trí của video trong danh sách

  @override
  void initState() {
    super.initState();

    controller = YoutubePlayerController(
      initialVideoId: widget.youtubeID,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        hideThumbnail: true,
      ),
    );
  }

  // void _showBottomSheet(BuildContext context) {
  //   showBottomSheet(
  //     context: context,
  //     builder: (context) {
  //       return Container(
  //         color: Colors.white,
  //         height: 200,
  //         child: Column(
  //           children: <Widget>[
  //             BottomSheetPlayer(
  //                 controller: controller, title: widget.youtubeID),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

//play next video when video ended
  void _playVideoEnded() {
    if (controller.value.playerState == PlayerState.ended) {
      _playNextVideo(Provider.of<YouTubeService>(context, listen: false));
    }
  }

//play next video
  void _playNextVideo(YouTubeService youtubeService) {
    if (currentIndex < youtubeService.videos.length - 1) {
      setState(() {
        currentIndex++;
        controller.load(youtubeService.videos[currentIndex].id);
      });
    } else {
      print('No more videos in the playlist');
    }
  }

//play previous video
  void _playPreviousVideo(YouTubeService youtubeService) {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        controller.load(youtubeService.videos[currentIndex].id);
      });
    } else {
      print('No more video in the playlist');
    }
  }

//replay video
  void _replayVideo() {
    controller.load(controller.metadata.videoId);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _setVolume(double volume) {
    setState(() {
      currentvol = volume;
    });
    controller.setVolume(volume.round());
  }

  @override
  Widget build(BuildContext context) {
    final youtubeService = Provider.of<YouTubeService>(context);
    return YoutubePlayerBuilder(
      player: YoutubePlayer(controller: controller),
      builder: (context, player) => Material(
        color: Colors.black,
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      // _showBottomSheet();
                      //  Provider.of<BottomSheetManager>(context, listen: false).showBottomSheet();
                      Navigator.pop(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ),
                      );
                      //  controller.pause();
                    },
                    child: Icon(
                      Icons.keyboard_arrow_left,
                      color: Color.fromARGB(255, 133, 133, 133),
                    ),
                  ),
                  Spacer(),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'PLAYING FROM',
                        style: TextStyle(
                          color: Color.fromARGB(225, 141, 141, 141),
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        'Rencently Played',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ),
                      );
                    },
                    icon: Icon(Icons.format_indent_decrease),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: player,
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      TextScroll(
                        widget.youtubeTitle,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                        textAlign: TextAlign.start,
                        velocity: Velocity(pixelsPerSecond: Offset(50, 0)),
                        delayBefore: Duration(seconds: 1),
                        pauseBetween: Duration(seconds: 2),
                        mode: TextScrollMode.endless,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      _replayVideo();
                    },
                    icon: Icon(Icons.replay, color: Colors.white),
                  ),
                  IconButton(
                      onPressed: () {
                        _playPreviousVideo(youtubeService);
                      },
                      icon: Icon(
                        Icons.skip_previous,
                        color: Color.fromARGB(255, 233, 100, 41),
                        size: 60,
                      )),
                  SizedBox(
                    width: 20,
                  ),
                  IconButton(
                      icon: isVideoPlaying
                          ? Icon(
                              Icons.pause_circle_filled,
                              size: 50,
                              color: Color.fromARGB(255, 233, 100, 41),
                            )
                          : Icon(
                              Icons.play_circle_fill,
                              size: 50,
                              color: Color.fromARGB(255, 233, 100, 41),
                            ),
                      //play and pause video
                      onPressed: () {
                        setState(() {
                          if (isVideoPlaying) {
                            controller.pause();
                          } else {
                            controller.play();
                          }
                          isVideoPlaying = !isVideoPlaying;
                        });
                      }),
                  SizedBox(
                    width: 20,
                  ),
                  IconButton(
                    onPressed: () {
                      _playNextVideo(youtubeService);
                    },
                    icon: Icon(
                      Icons.skip_next,
                      color: Color.fromARGB(255, 233, 100, 41),
                      size: 60,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 0,
                      ),
                    ),
                    child: Slider(
                      activeColor: Color.fromARGB(255, 233, 100, 41),
                      //controll volume video
                      value: currentvol,
                      min: 0,
                      max: 100,
                      divisions: 100,
                      label: currentvol.round().toString(),
                      onChanged: _setVolume,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
