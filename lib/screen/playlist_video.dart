import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:musi/models/playlist_model.dart';
import 'package:musi/provider/favorite_video.dart';
import 'package:musi/provider/recently_provider.dart';
import 'package:musi/provider/recently_video.dart';
import 'package:musi/service/video_api.dart';
import 'package:musi/screen/video.dart';
import 'package:provider/provider.dart';

class VideoListScreen extends StatefulWidget {
  const VideoListScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<VideoListScreen> createState() => _VideoListState();
}

class _VideoListState extends State<VideoListScreen> {
  // List _items = [];
  // @override
  // void initState() {
  //   super.initState();
  //   readJson();
  // }
  // Future<void> readJson() async {
  //   final String response =
  //       await rootBundle.loadString('assets/list_musi.json');
  //   final data = await json.decode(response);
  //   setState(() {
  //     _items = data["items"];
  //   });
  //    }

  // bool _isLoading = true;
  //List<PlaylistModel>? _videos;

  //List<PlaylistModel >  listRecnetly =[];
  final ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    final videoProvider = Provider.of<YouTubeService>(context, listen: false);
    videoProvider.fetchVideosByPlaylistId();
    scrollController.addListener(() {
      //listener scroll to bottom -> load more video
      //final scrollPosition = scrollController.position.pixels;
      // if (scrollPosition >= 100) {
      //   videoProvider.removeScrolledVideos(scrollPosition);
      // }
      // else if (scrollPosition<100){
      //    videoProvider.reAddScrolledVideos();
      // }

      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          !videoProvider.isLoading) {
        videoProvider.fetchVideosByPlaylistId();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  // _fetchVideos() async {
  //   YouTubeService youtubeService = YouTubeService();
  //   try {
  //     List<ListVideo> videos = await youtubeService.fetchVideosByPlaylistId();
  //     setState(() {
  //       _videos = videos;
  //       _isLoading = false;
  //     });
  //   } catch (e) {
  //     print(e);
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: Color.fromARGB(255, 22, 22, 22),
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
              
                    Text(
                      'Playlists',
                      style: TextStyle(color: Colors.white),
                    ),
                    Spacer(),
                  
                    Spacer(),
                    Icon(
                      Icons.more_horiz,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Consumer<YouTubeService>(
              builder: (context, videoProvider, child) {
                //playlist is empty or loading
                if (videoProvider.isLoading && videoProvider.videos.isEmpty) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView.builder(
                  cacheExtent: 500.0,
                  controller: scrollController,
                  // playlist length
                  itemCount: videoProvider.videos.length +
                      (videoProvider.isLoading ? 1 : 0),

                  itemBuilder: (context, index) {
                    if (index == videoProvider.videos.length) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final PlaylistModel video = videoProvider.videos[index];

                    return GestureDetector(
                      onTap: () {
                        // Provider.of<RecentlyProvider>(context, listen: false)
                        //     .AddVideoFromPlaylistRecently(context,video);
                        AddVideoFromPlaylistRecently(context,video);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VideoScreen(
                              youtubeID: video.id,
                              youtubeTitle: video.title,
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        leading: Image.network(video.thumbnailUrl),
                        title: Text(
                          video.title,
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(video.channelTitle),
                        trailing: IconButton(
                          icon: Icon(Icons.favorite_border),
                          onPressed: () async {
                            AddVideoFromPlaylistFavorite(context, video);
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
