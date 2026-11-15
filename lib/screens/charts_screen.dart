import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/roblox_game.dart';
import '../models/chart_games.dart';
import '../widgets/game_tile.dart';

class ChartsScreen extends StatefulWidget {
  const ChartsScreen({super.key});

  @override
  State<ChartsScreen> createState() => _ChartsScreenState();
}

class _ChartsScreenState extends State<ChartsScreen> {
  String _selectedGenre = 'All';

  // Created once so the stream isn't re-subscribed on every rebuild.
  final Stream<QuerySnapshot> _customGames = FirebaseFirestore.instance
      .collection('custom_games')
      .orderBy('createdAt', descending: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ROBLOX CHARTS')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _customGames,
        builder: (context, snapshot) {
          // Games users added from the Home "+" button come first.
          final added = (snapshot.data?.docs ?? [])
              .map((d) =>
                  RobloxGame.fromFirestore(d.data() as Map<String, dynamic>))
              .toList();
          final all = [...added, ...kRobloxCatalog, ...kMoreChartGames];

          final filtered = _selectedGenre == 'All'
              ? all
              : all.where((g) => g.genre == _selectedGenre).toList();

          return Column(
            children: [
              // Genre filters
              SizedBox(
                height: 50,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: kGenres.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final genre = kGenres[index];
                    return ChoiceChip(
                      label: Text(genre),
                      selected: genre == _selectedGenre,
                      selectedColor: const Color(0xFF00E054),
                      onSelected: (_) => setState(() => _selectedGenre = genre),
                    );
                  },
                ),
              ),

              // 2 square cards per row, scrolling vertically
              Expanded(
                child: filtered.isEmpty
                    ? const Center(child: Text('No games found.'))
                    : GridView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.74,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) =>
                            GameTile(game: filtered[index]),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
