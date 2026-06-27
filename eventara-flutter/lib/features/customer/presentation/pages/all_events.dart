import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:eventara/core/router/app_routes.dart';

// ─── Colour tokens ───────────────────────────────────────────────────────────
const _bgDeep   = Color(0xFF0D0B1E);
const _bgCard   = Color(0xFF151228);
const _purple   = Color(0xFF7B5CF6);
const _purpleLight = Color(0xFF9B8AFB);
const _textPrimary   = Color(0xFFFFFFFF);
const _textSecondary = Color(0xFFB0A8D0);
const _accentPink    = Color(0xFFFF006E);

// ─── Sample data ─────────────────────────────────────────────────────────────
class _EventItem {
  final String id;
  final String category;
  final String title;
  final String location;
  final String date;
  final String price;
  final Color accentColor;

  const _EventItem({
    required this.id,
    required this.category,
    required this.title,
    required this.location,
    required this.date,
    required this.price,
    required this.accentColor,
  });
}

const _allEvents = [
  _EventItem(id: '1', category: 'Music & Concerts',          title: 'Neon Jungle Festival',       location: 'Electric Gardens',     date: 'Aug 24',  price: 'LKR 129', accentColor: Color(0xFF7B5CF6)),
  _EventItem(id: '2', category: 'Sports',                    title: 'Premier League Night',       location: 'National Stadium',     date: 'Sep 03',  price: 'LKR 85',  accentColor: Color(0xFF00C853)),
  _EventItem(id: '3', category: 'Music & Concerts',          title: 'Jazz Under the Stars',       location: 'Rooftop Terrace',      date: 'Sep 05',  price: 'LKR 45',  accentColor: Color(0xFF7B5CF6)),
  _EventItem(id: '4', category: 'Comedy Shows',              title: 'Stand-up Night',             location: 'The Laugh Factory',    date: 'Sep 12',  price: 'LKR 30',  accentColor: Color(0xFFFFC107)),
  _EventItem(id: '5', category: 'Theatre & Performing Arts', title: 'Swan Lake — Live Ballet',    location: 'Grand Theatre',        date: 'Sep 18',  price: 'LKR 200', accentColor: Color(0xFFE91E63)),
  _EventItem(id: '6', category: 'Conferences & Seminars',    title: 'DevCon Asia 2026',           location: 'BMICH Convention',     date: 'Sep 21',  price: 'LKR 500', accentColor: Color(0xFF2196F3)),
  _EventItem(id: '7', category: 'Music & Concerts',          title: 'Stadium Rock Tour',          location: 'National Arena',       date: 'Sep 28',  price: 'LKR 180', accentColor: Color(0xFF7B5CF6)),
  _EventItem(id: '8', category: 'Workshops',                 title: 'UI/UX Masterclass',          location: 'Design Studio',        date: 'Oct 02',  price: 'LKR 75',  accentColor: Color(0xFF00BCD4)),
  _EventItem(id: '9', category: 'Film & Cinema',             title: 'Indie Film Showcase',        location: 'Regal Cinema',         date: 'Oct 08',  price: 'LKR 25',  accentColor: Color(0xFFFF5722)),
  _EventItem(id: '10', category: 'Cultural Events',          title: 'Sri Lankan Heritage Fair',   location: 'Independence Square',  date: 'Oct 14',  price: 'Free',    accentColor: Color(0xFFFF9800)),
  _EventItem(id: '11', category: 'Family & Kids',            title: 'KidZone Adventure',          location: 'City Park',            date: 'Oct 19',  price: 'LKR 20',  accentColor: Color(0xFF8BC34A)),
  _EventItem(id: '12', category: 'Conferences & Seminars',   title: 'FinTech Summit 2026',        location: 'Hilton Ballroom',      date: 'Oct 25',  price: 'LKR 350', accentColor: Color(0xFF2196F3)),
];

const _categories = [
  'All',
  'Music & Concerts',
  'Sports',
  'Theatre & Performing Arts',
  'Comedy Shows',
  'Conferences & Seminars',
  'Workshops',
  'Film & Cinema',
  'Cultural Events',
  'Family & Kids',
  'Other',
];

// ─── Page ─────────────────────────────────────────────────────────────────────
class AllEventsPage extends StatefulWidget {
  const AllEventsPage({super.key});

  @override
  State<AllEventsPage> createState() => _AllEventsPageState();
}

class _AllEventsPageState extends State<AllEventsPage> {
  String _selectedCategory = 'All';
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<_EventItem> get _filtered {
    return _allEvents.where((e) {
      final matchCat = _selectedCategory == 'All' || e.category == _selectedCategory;
      final matchSearch = _searchQuery.isEmpty ||
          e.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          e.category.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          e.location.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchCat && matchSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final events = _filtered;

    return Scaffold(
      backgroundColor: _bgDeep,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top bar ───────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.go(AppRoutes.customerHome),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: _bgCard,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: _textSecondary, size: 16),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    'Explore Events',
                    style: TextStyle(
                      color: _textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${events.length} found',
                    style: const TextStyle(color: _textSecondary, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Search bar ────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _SearchBar(
                controller: _searchCtrl,
                onChanged: (v) => setState(() => _searchQuery = v),
              ),
            ),
            const SizedBox(height: 16),

            // ── Category filter chips ────────────────────────────────────
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final cat = _categories[i];
                  final selected = _selectedCategory == cat;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected ? _purple : _bgCard,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selected
                              ? _purpleLight
                              : Colors.white.withValues(alpha: 0.1),
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        cat,
                        style: TextStyle(
                          color: selected ? _textPrimary : _textSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // ── Events list ───────────────────────────────────────────────
            Expanded(
              child: events.isEmpty
                  ? const Center(
                      child: Text(
                        'No events found',
                        style: TextStyle(color: _textSecondary, fontSize: 15),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      itemCount: events.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) => _EventCard(event: events[i]),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNavBar(),
    );
  }
}

// ─── Search Bar ──────────────────────────────────────────────────────────────
class _SearchBar extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  const _SearchBar({required this.controller, required this.onChanged});

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
        child: TextField(
          controller: widget.controller,
          onChanged: widget.onChanged,
          style: const TextStyle(color: _textPrimary, fontSize: 15),
          decoration: InputDecoration(
            hintText: 'Search events, categories...',
            hintStyle: const TextStyle(color: _textSecondary, fontSize: 14),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 12, right: 8),
              child: Icon(Icons.search_rounded,
                  color: _focused ? _purpleLight : _textSecondary, size: 20),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Event Card ───────────────────────────────────────────────────────────────
class _EventCard extends StatefulWidget {
  final _EventItem event;
  const _EventCard({required this.event});

  @override
  State<_EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<_EventCard> {
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
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
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
                // ── Colour accent strip + icon ─────────────────────────
                Container(
                  width: 90,
                  height: 110,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        widget.event.accentColor.withValues(alpha: 0.4),
                        widget.event.accentColor.withValues(alpha: 0.15),
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _categoryIcon(widget.event.category),
                      style: const TextStyle(fontSize: 30),
                    ),
                  ),
                ),

                // ── Details ───────────────────────────────────────────
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Category pill
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: widget.event.accentColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            widget.event.category,
                            style: TextStyle(
                              color: widget.event.accentColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.event.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: _textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined,
                                size: 12, color: _textSecondary.withValues(alpha: 0.7)),
                            const SizedBox(width: 3),
                            Expanded(
                              child: Text(
                                '${widget.event.date} • ${widget.event.location}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: _textSecondary.withValues(alpha: 0.7),
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
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

                // ── Like ─────────────────────────────────────────────
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

  String _categoryIcon(String cat) {
    switch (cat) {
      case 'Music & Concerts':          return '🎵';
      case 'Sports':                    return '⚽';
      case 'Theatre & Performing Arts': return '🎭';
      case 'Comedy Shows':              return '😂';
      case 'Conferences & Seminars':    return '🎤';
      case 'Workshops':                 return '🛠️';
      case 'Film & Cinema':             return '🎬';
      case 'Cultural Events':           return '🎨';
      case 'Family & Kids':             return '👨‍👩‍👧';
      default:                          return '📌';
    }
  }
}

// ─── Bottom Nav Bar ──────────────────────────────────────────────────────────
class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  @override
  Widget build(BuildContext context) {
    const items = [
      {'icon': Icons.home_rounded, 'label': 'Home', 'route': AppRoutes.customerHome},
      {'icon': Icons.search_rounded, 'label': 'Explore', 'route': AppRoutes.customerAllEvents},
      {'icon': Icons.bookmark_rounded, 'label': 'My Tickets', 'route': AppRoutes.customerMyTickets},
      {'icon': Icons.person_rounded, 'label': 'Profile', 'route': AppRoutes.customerProfile},
    ];

    return Container(
      decoration: BoxDecoration(
        color: _bgCard,
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.08), width: 1),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isSelected = index == 1; // Explore is active
              return GestureDetector(
                onTap: () => context.go(item['route'] as String),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      item['icon'] as IconData,
                      color: isSelected ? _purpleLight : _textSecondary,
                      size: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['label'] as String,
                      style: TextStyle(
                        color: isSelected ? _purpleLight : _textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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
