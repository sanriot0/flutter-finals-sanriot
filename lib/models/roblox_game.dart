import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class RobloxGame {
  final String title;
  final String genre;
  final String creator;
  final String description;
  final Color bannerColor;
  final IconData icon;
  final String likes;
  final String players;

  /// Set only for games users add themselves (stored as base64 in Firestore).
  final String? imageBase64;

  /// Optional local thumbnail, e.g. 'assets/games/croydon.jpg'.
  /// Falls back to the colour + icon banner if the file isn't there.
  final String? assetImage;

  /// Optional small chip on the banner, e.g. 'New Weapons'.
  final String? badge;

  const RobloxGame({
    required this.title,
    required this.genre,
    required this.creator,
    required this.description,
    required this.bannerColor,
    required this.icon,
    this.likes = '90%',
    this.players = '10K',
    this.imageBase64,
    this.assetImage,
    this.badge,
  });

  Uint8List? get imageBytes {
    if (imageBase64 == null || imageBase64!.isEmpty) return null;
    try {
      return base64Decode(imageBase64!);
    } catch (_) {
      return null;
    }
  }

  /// Builds a game from a document in the `custom_games` collection.
  factory RobloxGame.fromFirestore(Map<String, dynamic> d) {
    return RobloxGame(
      title: d['title'] ?? 'Untitled',
      genre: d['genre'] ?? 'Adventure',
      creator: d['creatorEmail'] ?? 'Community',
      description: d['description'] ?? '',
      bannerColor: const Color(0xFF2B3440),
      icon: Icons.sports_esports,
      likes: 'New',
      players: '—',
      imageBase64: d['imageBase64'],
    );
  }
}

const List<String> kGenres = [
  'All',
  'Adventure',
  'Action',
  'Horror',
  '2 Player Obby',
  'Simulator',
  'Tycoon',
  'Hangouts',
];

const List<RobloxGame> kRobloxCatalog = [
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
    title: 'Blox Fruits',
    genre: 'Adventure',
    creator: 'Gamer Robot Inc',
    description: 'Sail across vast oceans and master powerful abilities.',
    bannerColor: Color(0xFF1E88E5),
    icon: Icons.explore,
    assetImage: 'assets/games/blox_fruits.jpg',
  ),
  RobloxGame(
    title: 'DOORS',
    genre: 'Horror',
    creator: 'LSPLASH',
    description: 'Navigate through 100 hotel rooms while surviving entities.',
    bannerColor: Color(0xFFB71C1C),
    icon: Icons.door_front_door,
    assetImage: 'assets/games/doors.jpg',
  ),
  RobloxGame(
    title: 'Pet Simulator 99',
    genre: 'Simulator',
    creator: 'BIG Games Pets',
    description: 'Hatch thousands of rare eggs and collect coins.',
    bannerColor: Color(0xFF00897B),
    icon: Icons.pets,
    assetImage: 'assets/games/pet_simulator_99.jpg',
  ),
];
