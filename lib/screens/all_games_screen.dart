import 'package:flutter/material.dart';
import '../models/roblox_game.dart';
import '../widgets/game_tile.dart';

/// Opened by the arrow next to "Top Trending" / "Up-and-Coming":
/// shows every game in that row as a scrollable grid.
class AllGamesScreen extends StatelessWidget {
  final String title;
  final List<RobloxGame> games;

  const AllGamesScreen({super.key, required this.title, required this.games});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.82,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
        ),
        itemCount: games.length,
        itemBuilder: (context, index) => GameTile(game: games[index]),
      ),
    );
  }
}
