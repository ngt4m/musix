import 'package:flutter/material.dart';
import 'package:musi/screen/favorite_screnn.dart';
import 'package:musi/screen/playlist_video.dart';
import 'package:musi/screen/recently_screen_.dart';
import 'package:musi/screen/search_video.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = VideoListScreen();
      case 1:
        page = SearchVideo();
      case 2:
        page = RecentlyPlay();
      case 3:
        page = FavoriteScrenn();
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    return Material(
      child: Column(
        children: [
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: page,
            ),
          ),
          BottomNavigationBar(
            backgroundColor: Color.fromARGB(255, 31, 31, 31),
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.music_note),
                label: 'PlayList',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.recent_actors),
                label: 'Recently Play',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Favorite',
              ),
            ],
            currentIndex: selectedIndex,
            selectedItemColor: Color.fromARGB(255, 233, 100, 41),
            unselectedItemColor: Color.fromARGB(255, 129, 129, 129),
            onTap: (value) {
              setState(() {
                selectedIndex = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
