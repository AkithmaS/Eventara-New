import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:eventara/core/router/app_routes.dart';
import '../../data/repositories/event_repository_impl.dart';
import '../../domain/entities/event_entity.dart';

// ─── Colour tokens ──────────────────────────────────────────────────────────
const _bgDeep = Color(0xFF0D0B1E);
const _bgCard = Color(0xFF151228);
const _purple = Color(0xFF7B5CF6);
const _purpleLight = Color(0xFF9B8AFB);
const _gradStart = Color(0xFF7B5CF6);
const _gradEnd = Color(0xFFE07BB0);
const _textPrimary = Color(0xFFFFFFFF);
const _textSecondary = Color(0xFFB0A8D0);
const _accentPink = Color(0xFFFF006E);

// ─── Provider ────────────────────────────────────────────────────────────────

final _eventDetailProvider =
    FutureProvider.family<EventEntity, int>((ref, id) async {
  final repo = EventRepositoryImpl();
  return repo.getEventById(id);
});

/// Returns the local asset path for a given event title.
/// First tries title-based matching, then falls back to category.
String? _assetForEvent(String title, String categoryName) {
  final lower = title.toLowerCase();
  
  // Title-based matching (highest priority)
  if (lower.contains('stand-up') || lower.contains('standup')) {
    return 'assets/images/comedy.jpg';
  }
  if (lower.contains('swan lake')) {
    return 'assets/images/ballet.jpg';
  }
  if (lower.contains('cricket')) {
    return 'assets/images/cricket.jpg';
  }
  if (lower.contains('esport') || lower.contains('gaming')) {
    return 'assets/images/esport.jpg';
  }
  
  // Fall back to category matching
  return categoryAssetFor(categoryName);
}

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

class EventDetailPage extends ConsumerStatefulWidget {
  final String eventId;
  const EventDetailPage({super.key, required this.eventId});

  @override
  ConsumerState<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends ConsumerState<EventDetailPage> {
  bool _liked = false;
  bool _expandedDescription = false;

  @override
  Widget build(BuildContext context) {
    final id = int.tryParse(widget.eventId) ?? 0;
    final asyncEvent = ref.watch(_eventDetailProvider(id));

    return asyncEvent.when(
      loading: () => const Scaffold(
        backgroundColor: _bgDeep,
        body: Center(child: CircularProgressIndicator(color: _purpleLight)),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: _bgDeep,
        appBar: AppBar(
          backgroundColor: _bgDeep,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: _textPrimary),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(
          child: Text(e.toString(),
              style: const TextStyle(color: _textSecondary, fontSize: 14)),
        ),
      ),
      data: (event) => _buildPage(context, event),
    );
  }

  Widget _buildPage(BuildContext context, EventEntity event) {
    return Scaffold(
      backgroundColor: _bgDeep,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Hero ──────────────────────────────────────────────────────
            Stack(
              children: [
                SizedBox(
                  height: 320,
                  width: double.infinity,
                  child: _EventHeroImage(
                    event: event,
                  ),
                ),
                Positioned(
                  top: 20, left: 16,
                  child: GestureDetector(
                    onTap: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go(AppRoutes.customerHome);
                      }
                    },
                    child: Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(
                        color: _bgDeep.withValues(alpha: 0.7),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1.5),
                      ),
                      child: const Icon(Icons.arrow_back_rounded, color: _textPrimary, size: 22),
                    ),
                  ),
                ),
                Positioned(
                  top: 20, right: 16,
                  child: GestureDetector(
                    onTap: () => setState(() => _liked = !_liked),
                    child: Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(
                        color: _bgDeep.withValues(alpha: 0.7),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1.5),
                      ),
                      child: Icon(
                        _liked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        color: _liked ? _accentPink : _textPrimary, size: 22,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category + type badge row
                  Row(
                    children: [
                      _badge(event.categoryName, _purple, _purpleLight),
                      const SizedBox(width: 8),
                      _badge(
                        event.isSeated ? 'SEATED' : 'GENERAL ADMISSION',
                        event.isSeated
                            ? const Color(0xFF00BCD4)
                            : const Color(0xFF4CAF50),
                        Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(event.title,
                      style: const TextStyle(
                          color: _textPrimary, fontSize: 28,
                          fontWeight: FontWeight.w800, height: 1.2)),
                  const SizedBox(height: 20),
                  _infoRow(Icons.calendar_today_rounded, event.eventDate, ''),
                  const SizedBox(height: 16),
                  _infoRow(Icons.location_on_rounded, event.venueName, event.venueAddress),
                  const SizedBox(height: 16),
                  _infoRow(Icons.person_rounded, 'By ${event.organizerName}', 'Organizer'),
                  const SizedBox(height: 16),
                  _infoRow(
                    Icons.event_seat_rounded,
                    '${event.availableCapacity} / ${event.totalCapacity} available',
                    'Capacity',
                  ),
                  const SizedBox(height: 32),
                  const Text('About this Event',
                      style: TextStyle(color: _textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  Text(
                    _expandedDescription || event.description.length <= 160
                        ? event.description
                        : '${event.description.substring(0, 160)}...',
                    style: TextStyle(color: _textSecondary.withValues(alpha: 0.9), fontSize: 14, height: 1.6),
                  ),
                  if (event.description.length > 160) ...[
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => setState(() => _expandedDescription = !_expandedDescription),
                      child: Text(
                        _expandedDescription ? 'Read less' : 'Read more',
                        style: const TextStyle(color: _purpleLight, fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: _bgCard,
          border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.08), width: 1)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('STARTING FROM',
                        style: TextStyle(
                            color: _textSecondary.withValues(alpha: 0.6),
                            fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8)),
                    const SizedBox(height: 4),
                    Text('LKR ${event.ticketPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                            color: _textPrimary, fontSize: 20, fontWeight: FontWeight.w800)),
                  ],
                ),
                _BookNowButton(
                  onTap: () {
                    if (event.isSeated) {
                      context.go(AppRoutes.buildCustomerSeatMap(widget.eventId));
                    } else {
                      context.go(AppRoutes.buildCustomerPayment(widget.eventId));
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _badge(String label, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: bg.withValues(alpha: 0.4), width: 1),
      ),
      child: Text(label,
          style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
    );
  }

  Widget _infoRow(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Icon(icon, color: _textSecondary, size: 18),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(color: _textPrimary, fontSize: 15, fontWeight: FontWeight.w600)),
            if (subtitle.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(subtitle,
                  style: TextStyle(color: _textSecondary.withValues(alpha: 0.8), fontSize: 13)),
            ],
          ],
        ),
      ],
    );
  }
}

class _EventHeroImage extends StatelessWidget {
  final EventEntity event;
  const _EventHeroImage({required this.event});

  @override
  Widget build(BuildContext context) {
    final asset = _assetForEvent(event.title, event.categoryName);

    // Try network image first if available
    if (event.imageUrl != null && event.imageUrl!.isNotEmpty) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            event.imageUrl!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _buildFallback(asset),
          ),
          _buildGradientOverlay(),
        ],
      );
    }

    // Try local asset
    if (asset != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            asset,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _buildEmojiFallback(event.categoryName),
          ),
          _buildGradientOverlay(),
        ],
      );
    }

    // Fallback to gradient + emoji
    return _buildEmojiFallback(event.categoryName);
  }

  Widget _buildFallback(String? asset) {
    if (asset != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            asset,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _buildEmojiFallback(event.categoryName),
          ),
          _buildGradientOverlay(),
        ],
      );
    }
    return _buildEmojiFallback(event.categoryName);
  }

  Widget _buildGradientOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            _bgDeep.withValues(alpha: 0.6),
            _bgDeep,
          ],
        ),
      ),
    );
  }

  Widget _buildEmojiFallback(String categoryName) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _gradStart.withValues(alpha: 0.8),
            _gradEnd.withValues(alpha: 0.6),
          ],
        ),
      ),
      child: Center(
        child: Text(
          _emojiFor(categoryName),
          style: const TextStyle(fontSize: 80),
        ),
      ),
    );
  }

  String _emojiFor(String cat) {
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
    if (lower.contains('esport') || lower.contains('gaming')) return '🎮';
    return '📌';
  }
}

class _BookNowButton extends StatefulWidget {
  final VoidCallback onTap;
  const _BookNowButton({required this.onTap});

  @override
  State<_BookNowButton> createState() => _BookNowButtonState();
}

class _BookNowButtonState extends State<_BookNowButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(colors: [_gradStart, _gradEnd]),
              boxShadow: [BoxShadow(color: _purple.withValues(alpha: 0.5), blurRadius: 16, offset: const Offset(0, 6))],
            ),
            child: const Text('Book Now',
                style: TextStyle(color: _textPrimary, fontSize: 15, fontWeight: FontWeight.w700, letterSpacing: 0.3)),
          ),
        ),
      ),
    );
  }
}
