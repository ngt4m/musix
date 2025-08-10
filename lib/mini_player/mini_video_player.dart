import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MiniVideoPlayer extends StatefulWidget {
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
  State<MiniVideoPlayer> createState() => _MiniVideoPlayerState();
}

class _MiniVideoPlayerState extends State<MiniVideoPlayer> with SingleTickerProviderStateMixin {
   late YoutubePlayerController _controller;
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _heightAnimation;
  late Animation<double> _widthAnimation;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      color: Colors.grey,
      child: Row(
        children: [
          GestureDetector(
            onTap: widget.onExpand,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: YoutubePlayer(controller: widget.controller),
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
                  widget.youtubeTitle,
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
              widget.controller.pause();
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
