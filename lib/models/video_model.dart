import 'package:musi/models/playlist_model.dart';
import 'package:musi/models/search_model.dart';

class VideoModel {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String channelTitle;

  VideoModel({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.channelTitle,
  });

  // Tạo từ PlaylistVideoModel
  factory VideoModel.fromPlaylist(PlaylistModel playlistVideo) {
    return VideoModel(
      id: playlistVideo.id,
      title: playlistVideo.title,
      thumbnailUrl: playlistVideo.thumbnailUrl,
      channelTitle: playlistVideo.channelTitle,
    );
  }

  // Tạo từ SearchModel
  factory VideoModel.fromSearch(SearchModel searchVideo) {
    return VideoModel(
      id: searchVideo.id,
      title: searchVideo.title,
      thumbnailUrl: searchVideo.thumbnailUrl,
      channelTitle: searchVideo.channelTitle,
    );
  }

    Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'thumbnailUrl': thumbnailUrl,
      'channelTitle': channelTitle,
    };
  }
  factory VideoModel.fromMap(Map<String, dynamic> map) {
    return VideoModel(
      id: map['id'],
      title: map['title'],
      thumbnailUrl: map['thumbnailUrl'],
      channelTitle: map['channelTitle'],
    );
  }


}
