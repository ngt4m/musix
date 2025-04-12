import 'package:flutter/material.dart';
import 'package:musi/models/video_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavoriteProvider extends ChangeNotifier {
  final List<VideoModel> _favourites = [];
  List<VideoModel> get favourites => _favourites;

  void AddToFavourites(VideoModel video) async {
    if (!_favourites.any((item) => item.id == video.id)) {
      _favourites.add(video);
      notifyListeners();
      await _SaveToLocalFavorite();
    }
  }

  void RemoveFromFavourites(VideoModel video) async {
    _favourites.removeWhere((item) => item.id == video.id);
    notifyListeners();
    await _SaveToLocalFavorite();
  }

  void RemoveAllFavorites() async {
    _favourites.clear();
    notifyListeners();
    await _SaveToLocalFavorite();
  }

  Future<void> _SaveToLocalFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> videoData = _favourites
        .map((video) => jsonEncode({
              'id': video.id,
              'title': video.title,
              'thumbnailUrl': video.thumbnailUrl,
              'channelTitle': video.channelTitle,
            }))
        .toList();
    prefs.setStringList('favourites', videoData);
  }

  Future<void> LoadFromLocalFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? videoData = prefs.getStringList('favourites');
    if (videoData != null) {
      _favourites.clear();
      _favourites.addAll(videoData.map((item) {
        final Map<String, dynamic> json = jsonDecode(item);
        return VideoModel(
          id: json['id'],
          title: json['title'],
          thumbnailUrl: json['thumbnailUrl'],
          channelTitle: json['channelTitle'],
        );
      }));
      notifyListeners();
    }
  }
}
