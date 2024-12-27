import 'package:flutter/material.dart';
import 'package:musi/models/playlist_model.dart';
import 'package:musi/models/search_model.dart';
import 'package:musi/models/video_model.dart';
import 'package:musi/provider/favorite_provider.dart';
import 'package:provider/provider.dart';


  // static const _favoriteKey = '';
  // Future<List<VideoModel>> GetFovoriteVideo() async {
  //   final preference = await SharedPreferences.getInstance();
  //   final jsonString = preference.getString(_favoriteKey);
  //   if (jsonString != null) {
  //     final List<dynamic> jsonList = json.decode(jsonString);
  //     return jsonList.map((e) => VideoModel.fromMap(e)).toList();
  //   }
  //   return [];
  // }
  // Future<void> AddFavoriteVideo(VideoModel video) async {
  //   final favorite = await GetFovoriteVideo();
  //   if (!favorite.any((v) => v.id == video.id)) {
  //     {
  //       favorite.add(video);
  //       final preference = await SharedPreferences.getInstance();
  //       preference.setString(
  //         _favoriteKey,
  //         json.encode(favorite.map((e) => e.toMap()).toList()),
  //       );
  //     }
  //     Future<void> RemoveFavoriteVideo(String videoID) async {
  //       final favorite = await GetFovoriteVideo();
  //       favorite.removeWhere((video) => video.id == videoID);
  //       final preference = await SharedPreferences.getInstance();
  //       preference.setString(
  //         _favoriteKey,
  //         json.encode(favorite.map((e) => e.toMap()).toList()),
  //       );
  //     }
  //   }
  // }

  void AddVideoFromPlaylistFavorite(BuildContext context, PlaylistModel playlistVideo) {
    final favoriteProvider =
        Provider.of<FavoriteProvider>(context, listen: false);
    final video = VideoModel.fromPlaylist(playlistVideo);
    favoriteProvider.AddToFavourites(video);
  }

  void AddVideoFromSearchFavorite (BuildContext context , SearchModel searchVideo){
     final favoriteProvider =
        Provider.of<FavoriteProvider>(context, listen: false);
        final video = VideoModel.fromSearch(searchVideo);
        favoriteProvider.AddToFavourites(video);
  }