import 'package:flutter/material.dart';
import 'package:musi/home_page.dart';
import 'package:musi/provider/favorite_provider.dart';
import 'package:musi/provider/recently_provider.dart';
import 'package:musi/service/video_api.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final favouriteProvider = FavoriteProvider();
  await favouriteProvider.LoadFromLocalFavorite();
  final recentlyProvider = RecentlyProvider();
  await recentlyProvider.LoadFromLocalRecently();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>YouTubeService()),
        ChangeNotifierProvider(create: (_)=>recentlyProvider),
        ChangeNotifierProvider(create: (_)=>favouriteProvider),
      ],
    
child: MyApp(),

    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music App',
      home: HomePage(),
    );
  }
}
