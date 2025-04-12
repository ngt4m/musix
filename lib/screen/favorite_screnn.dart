import 'package:flutter/material.dart';
import 'package:musi/models/video_model.dart';
import 'package:musi/provider/favorite_provider.dart';
import 'package:provider/provider.dart';

class FavoriteScrenn extends StatefulWidget {
  const FavoriteScrenn({Key? key}) : super(key: key);

  @override
  _FavoriteScrennState createState() => _FavoriteScrennState();
}

class _FavoriteScrennState extends State<FavoriteScrenn> {
  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: [
          PopupMenuButton(
              onSelected: (value) {
                if (value == 'xoadanhsach') {
                  favoriteProvider.RemoveAllFavorites();
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem(
                      value: 'xoadanhsach',
                      child: Text('Xóa danh sách'),
                    ),
                  ],
                  icon: Icon(Icons.more_horiz),
                  ),
        ],
      ),
      body: ListView.builder(
        reverse: true,
        itemCount: favoriteProvider.favourites.length,
        itemBuilder: (context, index) {
          final VideoModel video = favoriteProvider.favourites[index];
          return Dismissible(
            key: ValueKey(favoriteProvider.favourites[index]),
            direction: DismissDirection.horizontal,
            background: Container(
              color: Colors.red,
              child: Icon(Icons.delete),
            ),
            onDismissed: (direction) {
              favoriteProvider.RemoveFromFavourites(video);
            },
            child: ListTile(
              leading: Image.network(video.thumbnailUrl),
              title: Text(
                video.title,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              subtitle: Text(
                video.channelTitle,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
