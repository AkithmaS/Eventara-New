import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:eventara/shared/widgets/brand_logo.dart';
import 'package:eventara/core/router/app_routes.dart';

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

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _selectedCategory = 0;
  final _searchCtrl = TextEditingController();

  final List<CategoryChip> _categories = [
    CategoryChip(label: 'Music &\nConcerts', icon: '🎵'),
    CategoryChip(label: 'Sports', icon: '⚽'),
    CategoryChip(label: 'Theatre &\nPerforming Arts', icon: '🎭'),
    CategoryChip(label: 'Comedy\nShows', icon: '😂'),
    CategoryChip(label: 'Conferences\n& Seminars', icon: '🎤'),
    CategoryChip(label: 'Workshops', icon: '🛠️'),
    CategoryChip(label: 'Film &\nCinema', icon: '🎬'),
    CategoryChip(label: 'Cultural\nEvents', icon: '🎨'),
    CategoryChip(label: 'Family &\nKids', icon: '👨‍👩‍👧‍👦'),
    CategoryChip(label: 'Other', icon: '📌'),
  ];

  final List<EventCard> _upcomingEvents = [
    EventCard(
      id: '1',
      category: 'MUSIC',
      title: 'Jazz Under the Stars',
      location: 'Sep 05 • Rooftop Terrace',
      price: 'LKR 4500.00',
      image: 'assets/images/jazz.jpg',
    ),
    EventCard(
      id: '2',
      category: 'COMEDY',
      title: 'Stand-up Night',
      location: 'Sep 12 • The Laugh Factory',
      price: 'LKR 3000.00',
      image: 'assets/images/comedy.jpg',
    ),
    EventCard(
      id: '3',
      category: 'MUSIC',
      title: 'Stadium Rock Tour',
      location: 'Sep 28 • National Arena',
      price: 'LKR 1800.00',
      image: 'assets/images/stadium.jpg',
    ),
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgDeep,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header with profile, notifications, branding ──────────────
            _HeaderSection(),
            const SizedBox(height: 20),
            // ── Search bar ─────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _SearchBar(controller: _searchCtrl),
            ),
            const SizedBox(height: 28),
            // ── Category chips ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: 100,
                child: GridView.count(
                  crossAxisCount: 4,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.85,
                  children: List.generate(_categories.length, (index) {
                    final category = _categories[index];
                    final isSelected = _selectedCategory == index;
                    return _CategoryButton(
                      category: category,
                      isSelected: isSelected,
                      onTap: () => setState(() => _selectedCategory = index),
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 32),
            // ── Featured Events Section ────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Featured Events',
                    style: TextStyle(
                      color: _textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.go(AppRoutes.customerAllEvents),
                    child: const Text(
                      'See all',
                      style: TextStyle(
                        color: _purpleLight,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _FeaturedEventCard(),
            ),
            const SizedBox(height: 32),
            // ── Upcoming Events Section ────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Upcoming Events',
                    style: TextStyle(
                      color: _textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'Filter',
                      style: TextStyle(
                        color: _purpleLight,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ...List.generate(_upcomingEvents.length, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: _UpcomingEventCard(event: _upcomingEvents[index]),
              );
            }),
            const SizedBox(height: 100),
          ],
        ),
      ),
      // ── Bottom Navigation Bar ────────────────────────────────────────────
      bottomNavigationBar: _BottomNavBar(),
    );
  }
}

/// Header with profile, notifications, and branding
class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          // Profile avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _bgCard,
              border: Border.all(
                color: _purple.withValues(alpha: 0.4),
                width: 1.5,
              ),
            ),
            child: const Center(
              child: Text(
                'A',
                style: TextStyle(
                  color: _textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Greeting
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Text(
                      'Hi, Alex',
                      style: TextStyle(
                        color: _textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text('👋', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ],
            ),
          ),
          // Notification icon
          MouseRegion(
            onEnter: (_) {},
            child: GestureDetector(
              onTap: () {},
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _bgCard,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                    width: 1.5,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.notifications_none_rounded,
                    color: _textSecondary,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Branding
          const BrandLogo(fontSize: 14),
        ],
      ),
    );
  }
}

/// Search bar with filters
class _SearchBar extends StatefulWidget {
  final TextEditingController controller;

  const _SearchBar({required this.controller});

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
                style: const TextStyle(
                  color: _textPrimary,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  hintText: 'Search events...',
                  hintStyle: const TextStyle(
                    color: _textSecondary,
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 8),
                    child: Icon(
                      Icons.search_rounded,
                      color: _focused ? _purpleLight : _textSecondary,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
            // Filter button
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _purple.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.tune_rounded,
                      color: _purpleLight,
                      size: 18,
                    ),
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

/// Category button chip
class CategoryChip {
  final String label;
  final String icon;

  CategoryChip({required this.label, required this.icon});
}

class _CategoryButton extends StatefulWidget {
  final CategoryChip category;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryButton({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

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
                Text(
                  widget.category.icon,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.category.label,
                  style: TextStyle(
                    color: widget.isSelected ? _textPrimary : _textSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Featured event card with large banner
class _FeaturedEventCard extends StatefulWidget {
  const _FeaturedEventCard();

  @override
  State<_FeaturedEventCard> createState() => _FeaturedEventCardState();
}

class _FeaturedEventCardState extends State<_FeaturedEventCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: Container(
          height: 220,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _gradStart.withValues(alpha: 0.3),
                _gradEnd.withValues(alpha: 0.2),
              ],
            ),
            border: Border.all(
              color: _hovered
                  ? _purple.withValues(alpha: 0.5)
                  : Colors.white.withValues(alpha: 0.1),
              width: 1.5,
            ),
          ),
          child: Stack(
            children: [
              // Background placeholder
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: _bgCard,
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'MUSIC',
                          style: TextStyle(
                            color: _textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Neon Jungle Festival',
                          style: TextStyle(
                            color: _textPrimary,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Aug 24 • Electric Gardens',
                          style: TextStyle(
                            color: _textSecondary.withValues(alpha: 0.8),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    // Price badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _textPrimary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'LKR 2000',
                        style: TextStyle(
                          color: _bgDeep,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Event card model
class EventCard {
  final String id;
  final String category;
  final String title;
  final String location;
  final String price;
  final String image;

  EventCard({
    required this.id,
    required this.category,
    required this.title,
    required this.location,
    required this.price,
    required this.image,
  });
}

/// Upcoming event card
class _UpcomingEventCard extends StatefulWidget {
  final EventCard event;

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
          onTap: () => context.go(AppRoutes.buildCustomerEventDetail(widget.event.id)),
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
                // Event image placeholder
                Container(
                  width: 100,
                  height: 120,
                  decoration: BoxDecoration(
                    color: _purple.withValues(alpha: 0.2),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.image_outlined,
                      color: _textSecondary,
                      size: 32,
                    ),
                  ),
                ),
                // Event details
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.event.category,
                              style: const TextStyle(
                                color: _textSecondary,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.event.title,
                              style: const TextStyle(
                                color: _textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              widget.event.location,
                              style: TextStyle(
                                color: _textSecondary.withValues(alpha: 0.7),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.event.price,
                              style: const TextStyle(
                                color: _purpleLight,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: _textSecondary.withValues(alpha: 0.5),
                              size: 16,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Like button
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () => setState(() => _liked = !_liked),
                    child: Icon(
                      _liked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
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

/// Bottom navigation bar
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
            color: Colors.white.withValues(alpha: 0.08),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_navItems.length, (index) {
              final item = _navItems[index];
              final isSelected = _selectedIndex == index;
              return MouseRegion(
                onEnter: (_) {},
                child: GestureDetector(
                  onTap: () {
                    setState(() => _selectedIndex = index);
                    switch (index) {
                      case 0:
                        context.go(AppRoutes.customerHome);
                        break;
                      case 1:
                        context.go(AppRoutes.customerAllEvents);
                        break;
                      case 2:
                        context.go(AppRoutes.customerMyTickets);
                        break;
                      case 3:
                        context.go(AppRoutes.customerProfile);
                        break;
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        item['icon'],
                        color: isSelected ? _purpleLight : _textSecondary,
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['label'],
                        style: TextStyle(
                          color: isSelected ? _purpleLight : _textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
