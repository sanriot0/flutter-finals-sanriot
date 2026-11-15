import 'package:flutter/material.dart';
import '../models/roblox_game.dart';
import 'game_banner.dart';
import 'review_modal.dart';

/// Roblox-style tile: square picture, title (2 lines), thumbs-up % and players.
/// Tapping opens the review sheet for that game.
class GameTile extends StatelessWidget {
  final RobloxGame game;
  const GameTile({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => showReviewModal(context: context, preselectedGame: game),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: GameBanner(game: game, iconSize: 44),
          ),
          const SizedBox(height: 8),
          Text(
            game.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600, height: 1.25),
          ),
          const Spacer(),
          Row(
            children: [
              Icon(Icons.thumb_up_alt, size: 12, color: Colors.grey[400]),
              const SizedBox(width: 3),
              Text(game.likes,
                  style: TextStyle(fontSize: 11, color: Colors.grey[400])),
              const SizedBox(width: 10),
              Icon(Icons.person, size: 13, color: Colors.grey[400]),
              const SizedBox(width: 2),
              Text(game.players,
                  style: TextStyle(fontSize: 11, color: Colors.grey[400])),
            ],
          ),
        ],
      ),
    );
  }
}
