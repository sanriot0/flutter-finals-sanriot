import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/roblox_game.dart';
import '../widgets/review_modal.dart';
import '../widgets/add_game_modal.dart';
import '../widgets/game_banner.dart';
import '../widgets/game_tile.dart';
import '../models/game_sections.dart';
import 'all_games_screen.dart';

class HomeDashboardScreen extends StatelessWidget {
  final ValueChanged<int> onNavigateTab;
  const HomeDashboardScreen({super.key, required this.onNavigateTab});

  static const List<RobloxGame> _standoutGames = [
    RobloxGame(
      title: 'Croydon: London Bus Simulator',
      genre: 'Simulator',
      creator: 'London Transit',
      description: 'Authentic London routes, traffic & detailed bus models.',
      bannerColor: Color(0xFFB71C1C),
      icon: Icons.directions_bus,
      likes: '77% Rating',
      players: '12K',
      assetImage: 'assets/games/croydon.jpg',
    ),
    RobloxGame(
      title: 'TTK Testing',
      genre: 'Adventure',
      creator: 'Tactical Dev',
      description: 'Tactical multi-tiered combat and weapon testing.',
      bannerColor: Color(0xFF263238),
      icon: Icons.shield,
      likes: '91% Rating',
      players: '8.4K',
      badge: 'New Weapons',
      assetImage: 'assets/games/ttk_testing.jpg',
    ),
    RobloxGame(
      title: 'FRONTLINES VERSUS',
      genre: 'Action',
      creator: 'Cluster',
      description: 'Highly competitive modern warfare. Test your skills.',
      bannerColor: Color(0xFF0D47A1),
      icon: Icons.flash_on,
      likes: '82% Rating',
      players: '15.1K',
      assetImage: 'assets/games/frontlines_versus.jpg',
    ),
    RobloxGame(
      title: 'Ecos: La Brea',
      genre: 'Adventure',
      creator: 'Ecos Team',
      description: 'Survive as a prehistoric animal in the Ice Age wilds.',
      bannerColor: Color(0xFF2E7D32),
      icon: Icons.landscape,
      likes: '91% Rating',
      players: '9.6K',
      assetImage: 'assets/games/ecos.jpg',
    ),
  ];

  // Placeholder picks for the "Recommended For You" row - rename/replace freely.
  static const List<RobloxGame> _recommendedGames = [
    RobloxGame(
      title: 'Skip Stones Tycoon',
      genre: 'Tycoon',
      creator: 'Pond Studio',
      description: 'Skip stones across the water and cash in huge combos.',
      bannerColor: Color(0xFF0288D1),
      icon: Icons.waves,
      likes: '93% Rating',
      assetImage: 'assets/games/rec1.jpg',
    ),
    RobloxGame(
      title: 'Pixel Boxing Club',
      genre: 'Action',
      creator: 'Retro Fists',
      description: 'Retro pixel boxing: train, spar and climb the ranks.',
      bannerColor: Color(0xFF3949AB),
      icon: Icons.sports_mma,
      likes: '88% Rating',
      assetImage: 'assets/games/rec2.jpg',
    ),
    RobloxGame(
      title: 'Chess Royale',
      genre: 'Hangouts',
      creator: 'Board Co',
      description: 'Challenge friends to fast, flashy multiplayer chess.',
      bannerColor: Color(0xFFE65100),
      icon: Icons.extension,
      likes: '90% Rating',
      assetImage: 'assets/games/rec3.jpg',
    ),
  ];

  /// "Top Trending ->" style row. Tapping the heading/arrow opens every game in the row.
  Widget _arrowSection(BuildContext context,
      {required String title, required List<RobloxGame> games}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
                builder: (_) => AllGamesScreen(title: title, games: games)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(width: 6),
                const Icon(Icons.arrow_forward, size: 20, color: Colors.white),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 215,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: games.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) =>
                SizedBox(width: 140, child: GameTile(game: games[index])),
          ),
        ),
      ],
    );
  }

  /// One Roblox-style row: heading, subtitle, horizontal list of cards.
  Widget _gameSection(
    BuildContext context, {
    required String title,
    String? subtitle,
    required List<RobloxGame> games,
    required double cardWidth,
    required double bannerHeight,
    required double listHeight,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(subtitle,
              style: TextStyle(fontSize: 13, color: Colors.grey[400])),
        ],
        const SizedBox(height: 12),
        SizedBox(
          height: listHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: games.length,
            itemBuilder: (context, index) {
              final game = games[index];
              return Container(
                width: cardWidth,
                margin: const EdgeInsets.only(right: 12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () =>
                      showReviewModal(context: context, preselectedGame: game),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GameBanner(game: game, height: bannerHeight),
                      const SizedBox(height: 8),
                      Text(
                        game.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Icon(Icons.thumb_up_alt,
                              size: 13, color: Colors.grey[400]),
                          const SizedBox(width: 4),
                          Text(game.likes,
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[400])),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        game.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('BLOXBOXD'),
        actions: [
          // Upper-right add button: add a game with a picture (shows up in Charts)
          IconButton(
            tooltip: 'Add a game',
            icon:
                const Icon(Icons.add_circle_outline, color: Color(0xFF00E054)),
            onPressed: () => showAddGameModal(context: context),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('game_reviews')
            .where('userId', isEqualTo: user?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          final docs = snapshot.data?.docs ?? [];
          final totalReviews = docs.length;

          double avgRating = 0;
          for (var doc in docs) {
            final data = doc.data() as Map<String, dynamic>;
            avgRating += (data['rating'] as num?)?.toDouble() ?? 0;
          }
          if (totalReviews > 0) avgRating /= totalReviews;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F262E),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'WELCOME BACK,',
                      style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF00E054),
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.email ?? 'Player',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'LIVE FIRESTORE STATS',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                      child: _statCard('Games Logged', '$totalReviews',
                          const Color(0xFF00E054))),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _statCard(
                      'Avg Rating',
                      totalReviews == 0
                          ? '—'
                          : '${avgRating.toStringAsFixed(1)} ★',
                      const Color(0xFFFF8000),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _gameSection(
                context,
                title: 'Standout Games: Reality Check',
                subtitle: 'Curated games crafting detailed worlds',
                games: _standoutGames,
                cardWidth: 270,
                bannerHeight: 150,
                listHeight: 250,
              ),
              const SizedBox(height: 20),
              _gameSection(
                context,
                title: 'Recommended For You',
                games: _recommendedGames,
                cardWidth: 290,
                bannerHeight: 200,
                listHeight: 300,
              ),
              const SizedBox(height: 24),
              _arrowSection(context,
                  title: 'Top Trending', games: kTrendingGames),
              const SizedBox(height: 24),
              _arrowSection(context,
                  title: 'Up-and-Coming', games: kUpAndComingGames),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }

  Widget _statCard(String label, String value, Color accent) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1F262E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w800, color: accent)),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[400])),
        ],
      ),
    );
  }
}
