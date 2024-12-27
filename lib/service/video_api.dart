import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:musi/key_api/keys.dart';
import 'package:musi/models/search_model.dart';
import 'package:musi/models/playlist_model.dart';
import 'package:http/http.dart' as http;

class YouTubeService with ChangeNotifier {
  String _nextPageToken = '';
  bool _isLoading = false;
   List<PlaylistModel> _videos = [];
   List<PlaylistModel> get videos => _videos;

  List<SearchModel> _search = [];
  List<SearchModel> get search => _search;

  bool get isLoading => _isLoading;

  String _createUrl(Map<String, String> parameters) {
    final queryParameters = parameters.entries.map(
      (entry) {
        return '${Uri.encodeComponent(entry.key)}=${Uri.encodeComponent(entry.value)}';
      },
    ).join('&');
    return queryParameters;
  }

  Future<void> fetchVideosByPlaylistId() async {
    Map<String, String> parameters = {
      'part': 'snippet',
      'chart': 'mostPopular',
      'pageToken': _nextPageToken,
      'maxResults': '15',
      'key': API_KEY,
    };
    final para = _createUrl(parameters);
    final url = 'https://www.googleapis.com/youtube/v3/videos?$para';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> videoItems = data['items'];
      _videos.addAll(
          videoItems.map((item) => PlaylistModel.fromMap(item)).toList());
      _nextPageToken = data['nextPageToken'] ?? '';
      _isLoading = false;
      notifyListeners();
    } else {
      _isLoading = false;
      notifyListeners();
      throw Exception('Failed to load videos');
    }
  }

  Future<void> searchVideos(String query, {bool loadMore = false}) async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    if (!loadMore) {
      _videos = [];
    }
    Map<String, String> parameters = {
      'part': 'snippet',
      'maxResults': '10',
      'q': query,
      'pageToken': loadMore ? _nextPageToken : '',
      'type': 'video',
      'key': API_KEY,
    };
    final para = _createUrl(parameters);
    final url = 'https://www.googleapis.com/youtube/v3/search?$para';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> searchItems = data['items'];
      if (!loadMore) {
        _videos = [];
      }
      _search.addAll(
          searchItems.map((item) => SearchModel.fromMap(item)).toList());

      _nextPageToken = data['nextPageToken'] ?? '';
    } else {
      throw Exception('Failed to load videos');
    }

    _isLoading = false;
    notifyListeners();
  }

  // void removeScrolledVideos(double scrollPosition) {
  //   if (_videos.length > _maxVideos && scrollPosition >= 100) {
  //     _videos.removeRange(0, _videos.length - _maxVideos);
  //     notifyListeners();
  //   }
  // }

  // void reAddScrolledVideos() {
  //   if (_removedVideos.isNotEmpty) {
  //     _videos.insertAll(0, _removedVideos);
  //     _removedVideos.clear();
  //     notifyListeners();
  //   }
  // }

  Future<List<String>> getSuggestions(String query) async {
    if (query.isEmpty) {
      return [];
    }
    final url = Uri.parse(
        'http://suggestqueries.google.com/complete/search?client=firefox&ds=yt&q=$query');

     final response = await http.get(url);
      if (response.statusCode == 200) {
      final List<dynamic> suggestions = json.decode(response.body)[1];
      return suggestions.map((s) => s.toString()).toList();
    } else {
      throw Exception('Failed to fetch suggestions');
    }
  
  }
}
