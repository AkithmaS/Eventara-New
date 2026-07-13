import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:eventara/core/router/app_routes.dart';
import '../providers/events_provider.dart';
import '../../domain/entities/event_entity.dart';
import '../widgets/event_image.dart';

// ─── Colour tokens ───────────────────────────────────────────────────────────
const _bgDeep = Color(0xFF0D0B1E);
const _bgCard = Color(0xFF151228);
const _purple = Color(0xFF7B5CF6);
const _purpleLight = Color(0xFF9B8AFB);
const _textPrimary = Color(0xFFFFFFFF);
const _textSecondary = Color(0xFFB0A8D0);
const _accentPink = Color(0xFFFF006E);

class AllEventsPage extends ConsumerStatefulWidget {
  const AllEventsPage({super.key});

  @override
  ConsumerState<AllEventsPage> createState() => _AllEventsPageState();
}

class _AllEventsPageState extends ConsumerState<AllEventsPage> {
  int _selectedCategoryIndex = 0;
  int? _selectedCategoryId;
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final current = ref.read(eventsNotifierProvider);
      if (current is EventsInitial) {
        ref.read(eventsNotifierProvider.notifier).init();
      }
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onCategoryTap(int index, List<Map<String, dynamic>> cats) {
    setState(() => _selectedCategoryIndex = index);
    if (index == 0) {
      _selectedCategoryId = null;
      ref.read(eventsNotifierProvider.notifier).loadEvents();
    } else {
      final catIndex = index - 1;
      if (catIndex < cats.length) {
        _selectedCategoryId = cats[catIndex]['id'] as int?;
      }
      ref
          .read(eventsNotifierProvider.notifier)
          .loadEvents(categoryId: _selectedCategoryId);
    }
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

    final displayCats = <String>['All', ...apiCategories.map((c) => c['name'] as String? ?? '')];

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
                      width: 38, height: 38,
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
                  const Text('Explore Events',
                      style: TextStyle(color: _textPrimary, fontSize: 20, fontWeight: FontWeight.w700)),
                  const Spacer(),
                  Text('${events.length} found',
                      style: const TextStyle(color: _textSecondary, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // ── Search bar ────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _SearchBar(
                controller: _searchCtrl,
                onChanged: (v) => ref
                    .read(eventsNotifierProvider.notifier)
                    .loadEvents(keyword: v.isEmpty ? null : v),
              ),
            ),
            const SizedBox(height: 16),
            // ── Category filter chips ─────────────────────────────────────
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: displayCats.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final selected = _selectedCategoryIndex == i;
                  return GestureDetector(
                    onTap: () => _onCategoryTap(i, apiCategories),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected ? _purple : _bgCard,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selected ? _purpleLight : Colors.white.withValues(alpha: 0.1),
                          width: 1.5,
                        ),
                      ),
                      child: Text(displayCats[i],
                          style: TextStyle(
                              color: selected ? _textPrimary : _textSecondary,
                              fontSize: 13,
                              fontWeight: FontWeight.w600)),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            // ── Events list ───────────────────────────────────────────────
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator(color: _purpleLight))
                  : errorMsg != null
                      ? Center(child: Text(errorMsg, style: const TextStyle(color: _textSecondary, fontSize: 15)))
                      : events.isEmpty
                          ? const Center(child: Text('No events found', style: TextStyle(color: _textSecondary, fontSize: 15)))
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
      bottomNavigationBar: const _BottomNavBar(),
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
            color: _focused ? _purple.withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.08),
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
  final EventEntity event;
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
          onTap: () => context.go(AppRoutes.buildCustomerEventDetail(widget.event.id.toString())),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: _bgCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _hovered ? _purple.withValues(alpha: 0.4) : Colors.white.withValues(alpha: 0.08),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 90, height: 110,
                  child: EventThumbnail(
                    imageUrl: widget.event.imageUrl,
                    categoryName: widget.event.categoryName,
                    width: 90,
                    height: 110,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: _purple.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(widget.event.categoryName,
                              style: const TextStyle(
                                  color: _purpleLight, fontSize: 10,
                                  fontWeight: FontWeight.w700, letterSpacing: 0.4)),
                        ),
                        const SizedBox(height: 6),
                        Text(widget.event.title,
                            maxLines: 2, overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: _textPrimary, fontSize: 15, fontWeight: FontWeight.w700, height: 1.3)),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined, size: 12, color: _textSecondary.withValues(alpha: 0.7)),
                            const SizedBox(width: 3),
                            Expanded(
                              child: Text(
                                '${widget.event.eventDate} • ${widget.event.venueName}',
                                maxLines: 1, overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: _textSecondary.withValues(alpha: 0.7), fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('LKR ${widget.event.ticketPrice.toStringAsFixed(0)}',
                                style: const TextStyle(color: _purpleLight, fontSize: 14, fontWeight: FontWeight.w700)),
                            Icon(Icons.arrow_forward_rounded,
                                color: _textSecondary.withValues(alpha: 0.5), size: 16),
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
                      _liked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      color: _liked ? _accentPink : _textSecondary, size: 20,
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
        border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.08), width: 1)),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isSelected = index == 1;
              return GestureDetector(
                onTap: () => context.go(item['route'] as String),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item['icon'] as IconData,
                        color: isSelected ? _purpleLight : _textSecondary, size: 24),
                    const SizedBox(height: 4),
                    Text(item['label'] as String,
                        style: TextStyle(
                            color: isSelected ? _purpleLight : _textSecondary,
                            fontSize: 11, fontWeight: FontWeight.w600)),
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
