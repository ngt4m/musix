import 'package:flutter/material.dart';
import 'package:musi/models/search_model.dart';
import 'package:musi/models/playlist_model.dart';
import 'package:musi/models/video_model.dart';
import 'package:musi/provider/recently_provider.dart';
import 'package:provider/provider.dart';

  void AddVideoFromPlaylistRecently(BuildContext context, PlaylistModel playlistVideo) {
    final recentlyProvider =
        Provider.of<RecentlyProvider>(context, listen: false);
    final video = VideoModel.fromPlaylist(playlistVideo);
    recentlyProvider.AddToRecently(video);
  }

  void AddVideoFromSearchRecently (BuildContext context , SearchModel searchVideo){
     final recentlyProvider =
        Provider.of<RecentlyProvider>(context, listen: false);
        final video = VideoModel.fromSearch(searchVideo);
        recentlyProvider.AddToRecently(video);
  }