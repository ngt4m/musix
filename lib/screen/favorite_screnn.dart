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
          onSelected:(value) {
            if(value=='Xoadanhsach'){
              favoriteProvider.RemoveAll();
            }
          } ,
          itemBuilder: (BuildContext context)=><PopupMenuEntry<String>>[
           const PopupMenuItem(
              value: 'Xoadanhsach' ,
              child: Text('Xóa danh sách'),
            ),
        ]
        ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.builder(
          itemCount: favoriteProvider.favourites.length,
          itemBuilder: (context, index) {
            final VideoModel video = favoriteProvider.favourites[index];
            return ListTile(
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
                ));
          }),
    );
  }
}
