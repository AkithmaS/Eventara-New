import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
const _accentGreen = Color(0xFF4ECB71);
const _accentBlue = Color(0xFF4ECDC4);

class MyEventsPage extends StatefulWidget {
  const MyEventsPage({super.key});

  @override
  State<MyEventsPage> createState() => _MyEventsPageState();
}

class _MyEventsPageState extends State<MyEventsPage> {
  String _selectedFilter = 'All';
  final List<String> _filterOptions = ['All', 'Published', 'Draft', 'Submitted'];

  final List<_EventData> _events = [
    _EventData(
      id: '1',
      title: 'Neon Nights Music Fest',
      date: 'Oct 24, 2023',
      venue: 'O2 Arena',
      status: 'Published',
      tickets: 450,
      revenue: '\$12,500',
      image: 'assets/images/neon.jpg',
    ),
    _EventData(
      id: '2',
      title: 'Tech Summit 2024',
      date: 'Nov 12, 2023',
      venue: 'Convention Center',
      status: 'Draft',
      tickets: 0,
      revenue: '\$0',
      image: 'assets/images/tech.jpg',
    ),
    _EventData(
      id: '3',
      title: 'Charity Gala Dinner',
      date: 'Dec 05, 2023',
      venue: 'Grand Hall',
      status: 'Submitted',
      tickets: 120,
      revenue: '\$8,400',
      image: 'assets/images/charity.jpg',
    ),
    _EventData(
      id: '4',
      title: 'Jazz Under Stars',
      date: 'Jan 15, 2024',
      venue: 'Rooftop Terrace',
      status: 'Published',
      tickets: 280,
      revenue: '\$5,600',
      image: 'assets/images/jazz.jpg',
    ),
    _EventData(
      id: '5',
      title: 'Comedy Night Live',
      date: 'Feb 22, 2024',
      venue: 'Comedy Club',
      status: 'Draft',
      tickets: 0,
      revenue: '\$0',
      image: 'assets/images/comedy.jpg',
    ),
  ];

  List<_EventData> get _filteredEvents {
    if (_selectedFilter == 'All') {
      return _events;
    }
    return _events.where((e) => e.status == _selectedFilter).toList();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Published':
        return _accentGreen;
      case 'Draft':
        return _textSecondary;
      case 'Submitted':
        return _accentBlue;
      default:
        return _textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgDeep,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'My Events',
                    style: TextStyle(
                      color: _textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.go(AppRoutes.organizerCreateEvent),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [_gradStart, _gradEnd],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.add_rounded,
                          color: _textPrimary,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Filter Chips ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _filterOptions.length,
                  itemBuilder: (context, index) {
                    final option = _filterOptions[index];
                    final isSelected = _selectedFilter == option;
                    return Padding(
                      padding: EdgeInsets.only(right: index < _filterOptions.length - 1 ? 8 : 0),
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedFilter = option),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? _purple : _bgCard,
                            borderRadius: BorderRadius.circular(20),
                            border: isSelected
                                ? null
                                : Border.all(
                                    color: Colors.white.withValues(alpha: 0.1),
                                  ),
                          ),
                          child: Center(
                            child: Text(
                              option,
                              style: TextStyle(
                                color: isSelected ? _textPrimary : _textSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── Events Grid ──────────────────────────────────────────
            Expanded(
              child: _filteredEvents.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.event_outlined,
                            size: 60,
                            color: _textSecondary.withValues(alpha: 0.3),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No events found',
                            style: TextStyle(
                              color: _textSecondary.withValues(alpha: 0.6),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        childAspectRatio: 0.65,
                      ),
                      itemCount: _filteredEvents.length,
                      itemBuilder: (context, index) {
                        return _EventCard(
                          event: _filteredEvents[index],
                          statusColor: _getStatusColor(_filteredEvents[index].status),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: _OrganizerBottomNav(selectedIndex: 1),
    );
  }
}

// ── Event Data Model ─────────────────────────────────────────────────────────
class _EventData {
  final String id;
  final String title;
  final String date;
  final String venue;
  final String status;
  final int tickets;
  final String revenue;
  final String image;

  _EventData({
    required this.id,
    required this.title,
    required this.date,
    required this.venue,
    required this.status,
    required this.tickets,
    required this.revenue,
    required this.image,
  });
}

// ── Event Card widget ────────────────────────────────────────────────────────
class _EventCard extends StatefulWidget {
  final _EventData event;
  final Color statusColor;

  const _EventCard({required this.event, required this.statusColor});

  @override
  State<_EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<_EventCard> {
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
          onTap: () {
            context.go(
              AppRoutes.buildOrganizerEditEvent(widget.event.id),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: _bgCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _hovered
                    ? _purple.withValues(alpha: 0.3)
                    : Colors.white.withValues(alpha: 0.08),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event Image
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(14),
                    topRight: Radius.circular(14),
                  ),
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          _purple.withValues(alpha: 0.2),
                          _gradEnd.withValues(alpha: 0.1),
                        ],
                      ),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Icon(
                            Icons.music_note_rounded,
                            size: 48,
                            color: _purple.withValues(alpha: 0.2),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: widget.statusColor.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: widget.statusColor.withValues(alpha: 0.4),
                              ),
                            ),
                            child: Text(
                              widget.event.status,
                              style: TextStyle(
                                color: widget.statusColor,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Event Details
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        widget.event.title,
                        style: const TextStyle(
                          color: _textPrimary,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),

                      // Date & Venue
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_rounded,
                                color: _textSecondary.withValues(alpha: 0.6),
                                size: 9,
                              ),
                              const SizedBox(width: 3),
                              Expanded(
                                child: Text(
                                  widget.event.date,
                                  style: TextStyle(
                                    color: _textSecondary.withValues(alpha: 0.7),
                                    fontSize: 9,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_rounded,
                                color: _textSecondary.withValues(alpha: 0.6),
                                size: 9,
                              ),
                              const SizedBox(width: 3),
                              Expanded(
                                child: Text(
                                  widget.event.venue,
                                  style: TextStyle(
                                    color: _textSecondary.withValues(alpha: 0.7),
                                    fontSize: 9,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Tickets & Revenue
                      if (widget.event.tickets > 0)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${widget.event.tickets} tickets',
                              style: TextStyle(
                                color: _textSecondary.withValues(alpha: 0.6),
                                fontSize: 9,
                              ),
                            ),
                            Text(
                              widget.event.revenue,
                              style: const TextStyle(
                                color: _accentGreen,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        )
                      else
                        Center(
                          child: Text(
                            'No bookings yet',
                            style: TextStyle(
                              color: _textSecondary.withValues(alpha: 0.5),
                              fontSize: 9,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Action buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: _ActionButton(
                          icon: Icons.edit_rounded,
                          label: 'Edit',
                          onTap: () {
                            context.go(
                              AppRoutes.buildOrganizerEditEvent(widget.event.id),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: _ActionButton(
                          icon: Icons.more_horiz_rounded,
                          label: 'More',
                          onTap: () {
                            // Show options menu
                          },
                        ),
                      ),
                    ],
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

// ── Action Button widget ─────────────────────────────────────────────────────
class _ActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: _hovered ? _bgCard.withValues(alpha: 0.8) : _bgCard,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: _hovered
                  ? _purple.withValues(alpha: 0.2)
                  : Colors.white.withValues(alpha: 0.05),
            ),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.icon,
                  color: _hovered ? _purpleLight : _textSecondary,
                  size: 14,
                ),
                const SizedBox(width: 3),
                Text(
                  widget.label,
                  style: TextStyle(
                    color: _hovered ? _purpleLight : _textSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
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

// ── Bottom Navigation Bar ────────────────────────────────────────────────────
class _OrganizerBottomNav extends StatelessWidget {
  final int selectedIndex;

  const _OrganizerBottomNav({required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> navItems = [
      {'icon': Icons.dashboard_rounded, 'label': 'Dashboard'},
      {'icon': Icons.event_rounded, 'label': 'My Events'},
      {'icon': Icons.assignment_rounded, 'label': 'Bookings'},
      {'icon': Icons.person_rounded, 'label': 'Profile'},
    ];

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
            children: List.generate(navItems.length, (index) {
              final item = navItems[index];
              final isSelected = selectedIndex == index;
              return GestureDetector(
                onTap: () {
                  switch (index) {
                    case 0:
                      context.go(AppRoutes.organizerDashboard);
                      break;
                    case 1:
                      context.go(AppRoutes.organizerMyEvents);
                      break;
                    case 2:
                      context.go(AppRoutes.organizerBookings);
                      break;
                    case 3:
                      context.go(AppRoutes.organizerProfile);
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
              );
            }),
          ),
        ),
      ),
    );
  }
}
