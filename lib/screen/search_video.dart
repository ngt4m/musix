import 'package:flutter/material.dart';
import 'package:musi/models/search_model.dart';
import 'package:musi/provider/favorite_video.dart';
import 'package:musi/provider/recently_video.dart';
import 'package:musi/screen/video.dart';
import 'package:musi/service/video_api.dart';
import 'package:provider/provider.dart';

class SearchVideo extends StatefulWidget {
  const SearchVideo({Key? key}) : super(key: key);

  @override
  _SearchVideoState createState() => _SearchVideoState();
}

class _SearchVideoState extends State<SearchVideo> {
  bool typing = false;

  final ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    final videoProvider = Provider.of<YouTubeService>(context, listen: false);
//listener scroll to bottom -> load more video
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          !videoProvider.isLoading) {
        videoProvider.searchVideos(TextBox.ytsearch.text,
            loadMore: true); //search more video
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void _searchVideos() {
    final videoProvider = Provider.of<YouTubeService>(context, listen: false);
    videoProvider.searchVideos(TextBox.ytsearch.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: TextBox(),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                if (!typing) {
                  _searchVideos();
                }
              },
              );
            },
          ),
        ],
      ),
      body: Consumer<YouTubeService>(
        builder: (context, videoProvider, child) {
          if (videoProvider.isLoading && videoProvider.search.isEmpty) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
              controller: scrollController,
              itemCount: videoProvider.search.length +
                  (videoProvider.isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == videoProvider.search.length) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final SearchModel searchVideo = videoProvider.search[index];
                return listItem(searchVideo, context);
              });
        },
      ),
    );
  }
}

Widget listItem(SearchModel search, BuildContext context) {
  return GestureDetector(
    onTap: () {
      // Provider.of<RecentlyProvider>(context, listen: false)
      //     .AddVideoFromSearch(video);
      AddVideoFromSearchRecently(context, search);
      Navigator.push(
        context,
        //-> video screen
        MaterialPageRoute(
          builder: (context) =>
              VideoScreen(youtubeID: search.id, youtubeTitle: search.title),
        ),
      );
    },
    child: ListTile(
      leading: Image.network(search.thumbnailUrl),
      title: Text(
        search.title,
        style: const TextStyle(color: Colors.white),
      ),
      subtitle: Text(search.channelTitle),
      trailing: IconButton(
        icon: Icon(Icons.favorite_border),
        onPressed: () async {
          AddVideoFromSearchFavorite(context, search);
        },
      ),
    ),
  );
}

class TextBox extends StatefulWidget {
  const TextBox({Key? key}) : super(key: key);
  static TextEditingController ytsearch = TextEditingController();

  @override
  State<TextBox> createState() => _TextBoxState();
}

class _TextBoxState extends State<TextBox> {
  final FocusNode focus = FocusNode();
  List<String> suggestions = [];
  bool isfocus = false;
  void _clearTextField() {
    TextBox.ytsearch.clear();
    setState(() {
      suggestions.clear();
    });
  }

  void _fetchSuggestion(String query) async {
    if (query.isEmpty) {
      setState(() {
        suggestions.clear();
      });
      return;
    }

    final apiservice = Provider.of<YouTubeService>(context, listen: false);
    final fetchSuggestion = await apiservice.getSuggestions(query);
    print(fetchSuggestion);//log dữ liệu trả về
    setState(() {
      suggestions = fetchSuggestion;
    });
  }

  @override
  void initState() {
    super.initState();
    focus.addListener(() {
      setState(() {
        isfocus = focus.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TextField(
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: const TextStyle(
            color: Color.fromARGB(255, 129, 129, 129),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              _clearTextField();
            },
          ),
        ),
        controller: TextBox.ytsearch,
        //tap Enter
        onChanged: _fetchSuggestion,
        onSubmitted: (value) {
          final videoProvider =
              Provider.of<YouTubeService>(context, listen: false);
          videoProvider.searchVideos(value);
          setState(() {
            suggestions.clear();
          });
        },
      ),
      if (isfocus && suggestions.isNotEmpty)
        Container(
          height : 200,
          color: Colors.black,
          child: ListView.builder(
               shrinkWrap: true,
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  suggestions[index],
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  TextBox.ytsearch.text = suggestions[index];
                  final videoProvider =
                      Provider.of<YouTubeService>(context, listen: false);
                  videoProvider.searchVideos(suggestions[index]);
                  setState(() {
                    suggestions.clear();
                  });
                },
              );
            },
          ),
        )
    ]);
  }
}
