class SearchModel {
  final String id;
  final String title;
  final String thumbnailUrl;

  final String channelTitle;

  SearchModel({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.channelTitle,
  });

  factory SearchModel.fromMap(Map<String, dynamic> map) {
    return SearchModel(
      id:  map['id']?['videoId'] as String? ?? 'Unknown ID',
      title: map['snippet']['title'],
      thumbnailUrl: map['snippet']['thumbnails']['default']['url'],
      channelTitle: map['snippet']['channelTitle'],
    );
  }
}
