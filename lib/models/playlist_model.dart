class PlaylistModel {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String channelTitle;

  PlaylistModel({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.channelTitle,
  });

  factory PlaylistModel.fromMap(Map<String, dynamic> map) {
    return PlaylistModel(
      id: map['id'],
      title: map['snippet']['title'],
      thumbnailUrl: map['snippet']['thumbnails']['default']['url'],
      channelTitle: map['snippet']['channelTitle'],
    );
  }

}
