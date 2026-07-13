import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:eventara/shared/widgets/brand_logo.dart';
import 'package:eventara/core/router/app_routes.dart';
import 'package:eventara/core/storage/secure_storage_service.dart';
import '../providers/events_provider.dart';
import '../../domain/entities/event_entity.dart';
import '../widgets/event_image.dart';

// ─── Colour tokens ──────────────────────────────────────────────────────────
const _bgDeep = Color(0xFF0D0B1E);
const _bgCard = Color(0xFF151228);
const _purple = Color(0xFF7B5CF6);
const _purpleLight = Color(0xFF9B8AFB);
const _textPrimary = Color(0xFFFFFFFF);
const _textSecondary = Color(0xFFB0A8D0);
const _accentPink = Color(0xFFFF006E);

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _selectedCategoryIndex = 0;
  int? _selectedCategoryId;
  final _searchCtrl = TextEditingController();
  String _userName = 'there';

  // Fallback hardcoded categories used until API responds.
  final List<_CategoryChip> _fallbackCategories = [
    _CategoryChip(label: 'Music &\nConcerts', icon: '🎵'),
    _CategoryChip(label: 'Sports', icon: '⚽'),
    _CategoryChip(label: 'Theatre &\nPerforming Arts', icon: '🎭'),
    _CategoryChip(label: 'Comedy\nShows', icon: '😂'),
    _CategoryChip(label: 'Conferences\n& Seminars', icon: '🎤'),
    _CategoryChip(label: 'Workshops', icon: '🛠️'),
    _CategoryChip(label: 'Film &\nCinema', icon: '🎬'),
    _CategoryChip(label: 'Cultural\nEvents', icon: '🎨'),
    _CategoryChip(label: 'Family &\nKids', icon: '👨‍👩‍👧‍👦'),
    _CategoryChip(label: 'Other', icon: '📌'),
  ];

  @override
  void initState() {
    super.initState();
    _loadUserName();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(eventsNotifierProvider.notifier).init();
    });
  }

  Future<void> _loadUserName() async {
    final name = await SecureStorageService.instance.getUserFullName();
    if (mounted && name != null && name.isNotEmpty) {
      setState(() => _userName = name.split(' ').first);
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onCategoryTap(int index, List<Map<String, dynamic>> apiCategories) {
    setState(() => _selectedCategoryIndex = index);
    if (index == 0) {
      _selectedCategoryId = null;
      ref.read(eventsNotifierProvider.notifier).loadEvents();
    } else {
      // API categories start at index 1 (index 0 is "All").
      final catIndex = index - 1;
      if (catIndex < apiCategories.length) {
        _selectedCategoryId = apiCategories[catIndex]['id'] as int?;
      }
      ref
          .read(eventsNotifierProvider.notifier)
          .loadEvents(categoryId: _selectedCategoryId);
    }
  }

  void _onSearch(String value) {
    ref
        .read(eventsNotifierProvider.notifier)
        .loadEvents(keyword: value.isEmpty ? null : value);
  }

  @override
  Widget build(BuildContext context) {
    final eventsState = ref.watch(eventsNotifierProvider);

    List<EventEntity> events = [];
    List<Map<String, dynamic>> apiCategories = [];
    bool isLoading = false;
    String? errorMsg;

    if (eventsState is EventsLoading) isLoading = true;
    if (eventsState is EventsLoaded) {
      events = eventsState.events;
      apiCategories = eventsState.categories;
    }
    if (eventsState is EventsError) errorMsg = eventsState.message;

    // Build display categories: "All" + API categories (or fallback).
    final displayCategories = <_CategoryChip>[
      _CategoryChip(label: 'All', icon: '✨'),
      ...apiCategories.isNotEmpty
          ? apiCategories.map((c) => _CategoryChip(
                label: (c['name'] as String? ?? '').replaceAll(' & ', ' &\n'),
                icon: c['icon'] as String? ?? '📌',
              ))
          : _fallbackCategories,
    ];

    return Scaffold(
      backgroundColor: _bgDeep,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeaderSection(userName: _userName),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _SearchBar(
                controller: _searchCtrl,
                onSubmitted: _onSearch,
              ),
            ),
            const SizedBox(height: 28),
            // ── Category chips ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: 100,
                child: GridView.count(
                  crossAxisCount: 4,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.85,
                  children: List.generate(
                    displayCategories.length.clamp(0, 12),
                    (index) => _CategoryButton(
                      category: displayCategories[index],
                      isSelected: _selectedCategoryIndex == index,
                      onTap: () =>
                          _onCategoryTap(index, apiCategories),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            // ── Upcoming Events ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Upcoming Events',
                      style: TextStyle(
                          color: _textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w700)),
                  GestureDetector(
                    onTap: () => context.go(AppRoutes.customerAllEvents),
                    child: const Text('See all',
                        style: TextStyle(
                            color: _purpleLight,
                            fontSize: 14,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (isLoading)
              const Padding(
                padding: EdgeInsets.all(32),
                child: Center(
                    child: CircularProgressIndicator(color: _purpleLight)),
              )
            else if (errorMsg != null)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                    child: Text(errorMsg,
                        style: const TextStyle(
                            color: _textSecondary, fontSize: 14))),
              )
            else if (events.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Center(
                    child: Text('No events found',
                        style: TextStyle(
                            color: _textSecondary, fontSize: 14))),
              )
            else
              ...events.take(5).map((e) => Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    child: _UpcomingEventCard(event: e),
                  )),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: const _BottomNavBar(),
    );
  }
}

// ─── Header ──────────────────────────────────────────────────────────────────

class _HeaderSection extends StatelessWidget {
  final String userName;
  const _HeaderSection({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _bgCard,
              border: Border.all(color: _purple.withValues(alpha: 0.4), width: 1.5),
            ),
            child: Center(
              child: Text(
                userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                style: const TextStyle(
                    color: _textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hi, $userName',
                    style: const TextStyle(
                        color: _textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const BrandLogo(fontSize: 14),
        ],
      ),
    );
  }
}

// ─── Search Bar ───────────────────────────────────────────────────────────────

class _SearchBar extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;
  const _SearchBar({required this.controller, required this.onSubmitted});

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _focused = true),
      onExit: (_) => setState(() => _focused = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: _bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _focused
                ? _purple.withValues(alpha: 0.5)
                : Colors.white.withValues(alpha: 0.08),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: widget.controller,
                onSubmitted: widget.onSubmitted,
                style: const TextStyle(color: _textPrimary, fontSize: 16),
                decoration: InputDecoration(
                  hintText: 'Search events...',
                  hintStyle:
                      const TextStyle(color: _textSecondary, fontSize: 14),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 8),
                    child: Icon(Icons.search_rounded,
                        color: _focused ? _purpleLight : _textSecondary,
                        size: 20),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: () =>
                    widget.onSubmitted(widget.controller.text),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _purple.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Icon(Icons.tune_rounded,
                        color: _purpleLight, size: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Category Chip ────────────────────────────────────────────────────────────

class _CategoryChip {
  final String label;
  final String icon;
  _CategoryChip({required this.label, required this.icon});
}

class _CategoryButton extends StatefulWidget {
  final _CategoryChip category;
  final bool isSelected;
  final VoidCallback onTap;
  const _CategoryButton(
      {required this.category,
      required this.isSelected,
      required this.onTap});

  @override
  State<_CategoryButton> createState() => _CategoryButtonState();
}

class _CategoryButtonState extends State<_CategoryButton> {
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
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: widget.isSelected ? _purple : _bgCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: widget.isSelected
                    ? _purpleLight
                    : Colors.white.withValues(alpha: 0.1),
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.category.icon,
                    style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 4),
                Text(
                  widget.category.label,
                  style: TextStyle(
                    color: widget.isSelected ? _textPrimary : _textSecondary,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Upcoming Event Card ──────────────────────────────────────────────────────

class _UpcomingEventCard extends StatefulWidget {
  final EventEntity event;
  const _UpcomingEventCard({required this.event});

  @override
  State<_UpcomingEventCard> createState() => _UpcomingEventCardState();
}

class _UpcomingEventCardState extends State<_UpcomingEventCard> {
  bool _hovered = false;
  bool _liked = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: GestureDetector(
          onTap: () => context.go(
              AppRoutes.buildCustomerEventDetail(widget.event.id.toString())),
          child: Container(
            decoration: BoxDecoration(
              color: _bgCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _hovered
                    ? _purple.withValues(alpha: 0.4)
                    : Colors.white.withValues(alpha: 0.08),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 100,
                  height: 120,
                  child: EventThumbnail(
                    imageUrl: widget.event.imageUrl,
                    categoryName: widget.event.categoryName,
                    width: 100,
                    height: 120,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.event.categoryName.toUpperCase(),
                                style: const TextStyle(
                                    color: _textSecondary,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.8)),
                            const SizedBox(height: 4),
                            Text(widget.event.title,
                                style: const TextStyle(
                                    color: _textPrimary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700)),
                            const SizedBox(height: 6),
                            Text(
                                '${widget.event.eventDate} • ${widget.event.venueName}',
                                style: TextStyle(
                                    color:
                                        _textSecondary.withValues(alpha: 0.7),
                                    fontSize: 12)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                'LKR ${widget.event.ticketPrice.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    color: _purpleLight,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700)),
                            Icon(Icons.arrow_forward_rounded,
                                color: _textSecondary.withValues(alpha: 0.5),
                                size: 16),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () => setState(() => _liked = !_liked),
                    child: Icon(
                      _liked
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: _liked ? _accentPink : _textSecondary,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Bottom Nav Bar ───────────────────────────────────────────────────────────

class _BottomNavBar extends StatefulWidget {
  const _BottomNavBar();

  @override
  State<_BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<_BottomNavBar> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _navItems = [
    {'icon': Icons.home_rounded, 'label': 'Home'},
    {'icon': Icons.search_rounded, 'label': 'Explore'},
    {'icon': Icons.bookmark_rounded, 'label': 'My Tickets'},
    {'icon': Icons.person_rounded, 'label': 'Profile'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _bgCard,
        border: Border(
            top: BorderSide(
                color: Colors.white.withValues(alpha: 0.08), width: 1)),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_navItems.length, (index) {
              final item = _navItems[index];
              final isSelected = _selectedIndex == index;
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedIndex = index);
                  switch (index) {
                    case 0: context.go(AppRoutes.customerHome); break;
                    case 1: context.go(AppRoutes.customerAllEvents); break;
                    case 2: context.go(AppRoutes.customerMyTickets); break;
                    case 3: context.go(AppRoutes.customerProfile); break;
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item['icon'],
                        color: isSelected ? _purpleLight : _textSecondary,
                        size: 24),
                    const SizedBox(height: 4),
                    Text(item['label'],
                        style: TextStyle(
                            color: isSelected ? _purpleLight : _textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
