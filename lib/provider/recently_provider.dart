import 'package:flutter/material.dart';
import 'package:musi/models/video_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
class RecentlyProvider extends ChangeNotifier {
  final List<VideoModel> _listRecently = [];
  List<VideoModel> get recentlyPlayed => _listRecently;
  
  void AddToRecently(VideoModel video) async {
    if (!_listRecently.any((item) => item.id == video.id)) {
      _listRecently.add(video);
      notifyListeners();
      await _SaveToLocalRecently();
    }
  }

  void RemoveFromRecently(VideoModel video) async {
    _listRecently.removeWhere((item) => item.id == video.id);
    notifyListeners();
    await _SaveToLocalRecently();
  }

  Future<void> _SaveToLocalRecently() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> videoData = _listRecently
        .map((video) => jsonEncode({
              'id': video.id,
              'title': video.title,
              'thumbnailUrl': video.thumbnailUrl,
              'channelTitle': video.channelTitle,
            }))
        .toList();
    prefs.setStringList('favourites', videoData);
  }

  Future<void> LoadFromLocalRecently() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? videoData = prefs.getStringList('favourites');
    if (videoData != null) {
      _listRecently.clear();
      _listRecently.addAll(videoData.map((item) {
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

  // void removeVideo(PlaylistModel video) {
  //   if (listRecently.contains(video)) {
  //     listRecently.remove(video);
  //     notifyListeners();
  //   }
  // }
  // void clearAll() {
  //   listRecently.clear();
  //   notifyListeners();
  // }
}
