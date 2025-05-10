import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MiniVideoPlayer extends StatelessWidget {
  final YoutubePlayerController controller;
  final String youtubeTitle;
  final VoidCallback onExpand;
  const MiniVideoPlayer(
      {super.key,
      required this.controller,
      required this.youtubeTitle,
      required this.onExpand,
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      color: Colors.grey,
      child: Row(
        children: [
          GestureDetector(
            onTap: onExpand,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: YoutubePlayer(controller: controller),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  youtubeTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "Playing...",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              controller.pause();
            },
            icon: const Icon(
              Icons.close,
              color: Colors.white,
            ),
            
          ),
        ],
      ),
    );
  }
}
