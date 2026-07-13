import 'package:flutter/material.dart';

/// Returns the local asset path for a given category name.
/// Falls back to null when no match found (caller shows emoji/icon instead).
String? categoryAssetFor(String categoryName) {
  final lower = categoryName.toLowerCase();
  if (lower.contains('music') || lower.contains('concert')) {
    return 'assets/images/concert.jpg';
  }
  if (lower.contains('sport') || lower.contains('cricket')) {
    return 'assets/images/sports.jpg';
  }
  if (lower.contains('theatre') || lower.contains('ballet') || lower.contains('performing')) {
    return 'assets/images/ballet.jpg';
  }
  if (lower.contains('comedy')) {
    return 'assets/images/comedy.jpg';
  }
  if (lower.contains('conference') || lower.contains('seminar')) {
    return 'assets/images/conference.jpg';
  }
  if (lower.contains('workshop')) {
    return 'assets/images/workshop.jpg';
  }
  if (lower.contains('esport') || lower.contains('gaming') || lower.contains('film') || lower.contains('cinema')) {
    return 'assets/images/esport.jpg';
  }
  if (lower.contains('cultural') || lower.contains('wellness') || lower.contains('health')) {
    return 'assets/images/wellness.jpg';
  }
  if (lower.contains('family') || lower.contains('kids')) {
    return 'assets/images/music.jpg';
  }
  return null;
}

/// Card thumbnail — tries network URL first, then local asset, then emoji fallback.
class EventThumbnail extends StatelessWidget {
  final String? imageUrl;
  final String categoryName;
  final double width;
  final double height;
  final BorderRadius borderRadius;

  const EventThumbnail({
    super.key,
    required this.imageUrl,
    required this.categoryName,
    required this.width,
    required this.height,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final asset = categoryAssetFor(categoryName);

    // 1. Network image from backend
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: Image.network(
          imageUrl!,
          width: width,
          height: height,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _localOrFallback(asset),
        ),
      );
    }

    // 2. Local asset matched by category
    return _localOrFallback(asset);
  }

  Widget _localOrFallback(String? asset) {
    if (asset != null) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: Image.asset(
          asset,
          width: width,
          height: height,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _fallback(),
        ),
      );
    }
    return _fallback();
  }

  Widget _fallback() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3D2C8D), Color(0xFF1A1040)],
        ),
      ),
      child: Center(
        child: Text(
          _emoji(categoryName),
          style: const TextStyle(fontSize: 32),
        ),
      ),
    );
  }

  String _emoji(String cat) {
    final lower = cat.toLowerCase();
    if (lower.contains('music') || lower.contains('concert')) return '🎵';
    if (lower.contains('sport') || lower.contains('cricket')) return '⚽';
    if (lower.contains('theatre') || lower.contains('ballet')) return '🎭';
    if (lower.contains('comedy')) return '😂';
    if (lower.contains('conference') || lower.contains('seminar')) return '🎤';
    if (lower.contains('workshop')) return '🛠️';
    if (lower.contains('film') || lower.contains('cinema')) return '🎬';
    if (lower.contains('cultural')) return '🎨';
    if (lower.contains('family') || lower.contains('kids')) return '👨‍👩‍👧';
    return '📌';
  }
}
