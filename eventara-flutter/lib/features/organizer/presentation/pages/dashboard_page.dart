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
const _accentOrange = Color(0xFFD97744);

class OrganizerDashboardPage extends StatefulWidget {
  const OrganizerDashboardPage({super.key});

  @override
  State<OrganizerDashboardPage> createState() => _OrganizerDashboardPageState();
}

class _OrganizerDashboardPageState extends State<OrganizerDashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgDeep,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────────
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Text(
                              'Hello, Alex',
                              style: TextStyle(
                                color: _textPrimary,
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text('👋', style: TextStyle(fontSize: 24)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Manage your events',
                          style: TextStyle(
                            color: _textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        // Notification button
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: _bgCard,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.1),
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.notifications_none_rounded,
                                color: _textSecondary,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Profile button
                        GestureDetector(
                          onTap: () => context.go(AppRoutes.organizerProfile),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [_gradStart, _gradEnd],
                              ),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.1),
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.person_rounded,
                                color: _textPrimary.withValues(alpha: 0.8),
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),

            // ── KPI Cards ────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.15,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _KPICard(
                    icon: Icons.home_rounded,
                    label: 'Total Events',
                    value: '12',
                    color: _accentBlue,
                  ),
                  _KPICard(
                    icon: Icons.confirmation_number_rounded,
                    label: 'Tickets Sold',
                    value: '842',
                    color: _accentOrange,
                  ),
                  _KPICard(
                    icon: Icons.attach_money_rounded,
                    label: 'Total Revenue',
                    value: '\$14.2K',
                    color: _accentGreen,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Quick Actions ────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  // Create Event button
                  Expanded(
                    child: _ActionButton(
                      label: 'Create Event',
                      icon: Icons.add_rounded,
                      isPrimary: true,
                      onTap: () => context.go(AppRoutes.organizerCreateEvent),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // My Events button
                  Expanded(
                    child: _ActionButton(
                      label: 'My Events',
                      icon: Icons.event_outlined,
                      isPrimary: false,
                      onTap: () => context.go(AppRoutes.organizerMyEvents),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // ── Recent Events ────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Events',
                    style: TextStyle(
                      color: _textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.go(AppRoutes.organizerMyEvents),
                    child: const Text(
                      'See All',
                      style: TextStyle(
                        color: _purpleLight,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Event list
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _EventCard(
                    title: 'Neon Nights Mu...',
                    date: 'Oct 24, 2023',
                    venue: 'O2 Arena',
                    status: 'PUBLISHED',
                    statusColor: _accentGreen,
                  ),
                  const SizedBox(height: 12),
                  _EventCard(
                    title: 'Tech Summit 2024',
                    date: 'Nov 12, 2023',
                    venue: 'Convention Ctr',
                    status: 'DRAFT',
                    statusColor: _textSecondary,
                  ),
                  const SizedBox(height: 12),
                  _EventCard(
                    title: 'Charity Gala Din...',
                    date: 'Dec 05, 2023',
                    venue: 'Grand Hall',
                    status: 'SUBMITTED',
                    statusColor: _accentBlue,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // ── Recent Bookings ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Bookings',
                    style: TextStyle(
                      color: _textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.go(AppRoutes.organizerBookings),
                    child: const Text(
                      'View All',
                      style: TextStyle(
                        color: _purpleLight,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Booking list
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _BookingCard(
                    initials: 'JS',
                    name: 'J*** S***',
                    event: 'Neon Nights • 2 seats',
                    amount: '\$120',
                    time: 'Today',
                  ),
                  const SizedBox(height: 12),
                  _BookingCard(
                    initials: 'MR',
                    name: 'M*** R***',
                    event: 'Neon Nights • 1 seat',
                    amount: '\$60',
                    time: '2h ago',
                  ),
                  const SizedBox(height: 12),
                  _BookingCard(
                    initials: 'DL',
                    name: 'D*** L***',
                    event: 'Charity Gala • 4 seats',
                    amount: '\$400',
                    time: 'Yesterday',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),

      // ── Bottom Navigation ────────────────────────────────────────────
      bottomNavigationBar: _OrganizerBottomNav(),
    );
  }
}

// ── KPI Card widget ──────────────────────────────────────────────────────────
class _KPICard extends StatefulWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _KPICard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  State<_KPICard> createState() => _KPICardState();
}

class _KPICardState extends State<_KPICard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          decoration: BoxDecoration(
            color: _bgCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _hovered
                  ? widget.color.withValues(alpha: 0.3)
                  : Colors.white.withValues(alpha: 0.08),
            ),
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: widget.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Icon(
                    widget.icon,
                    color: widget.color,
                    size: 14,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.value,
                    style: const TextStyle(
                      color: _textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.label,
                    style: const TextStyle(
                      color: _textSecondary,
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Action Button widget ─────────────────────────────────────────────────────
class _ActionButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool isPrimary;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.isPrimary,
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
      child: AnimatedScale(
        scale: _hovered ? 1.03 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: widget.isPrimary
                  ? const LinearGradient(colors: [_gradStart, _gradEnd])
                  : null,
              color: widget.isPrimary ? null : _bgCard,
              border: widget.isPrimary
                  ? null
                  : Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.icon,
                    color: widget.isPrimary ? _textPrimary : _textSecondary,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    widget.label,
                    style: TextStyle(
                      color: widget.isPrimary ? _textPrimary : _textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Event Card widget ────────────────────────────────────────────────────────
class _EventCard extends StatefulWidget {
  final String title;
  final String date;
  final String venue;
  final String status;
  final Color statusColor;

  const _EventCard({
    required this.title,
    required this.date,
    required this.venue,
    required this.status,
    required this.statusColor,
  });

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
        scale: _hovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _bgCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _hovered
                  ? _purple.withValues(alpha: 0.2)
                  : Colors.white.withValues(alpha: 0.08),
            ),
          ),
          child: Row(
            children: [
              // Image placeholder
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _purple.withValues(alpha: 0.2),
                      _gradEnd.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.music_note_rounded,
                  color: _purple.withValues(alpha: 0.3),
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              // Event details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        color: _textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.date} • ${widget.venue}',
                      style: TextStyle(
                        color: _textSecondary.withValues(alpha: 0.7),
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Status badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: widget.statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  widget.status,
                  style: TextStyle(
                    color: widget.statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Booking Card widget ──────────────────────────────────────────────────────
class _BookingCard extends StatefulWidget {
  final String initials;
  final String name;
  final String event;
  final String amount;
  final String time;

  const _BookingCard({
    required this.initials,
    required this.name,
    required this.event,
    required this.amount,
    required this.time,
  });

  @override
  State<_BookingCard> createState() => _BookingCardState();
}

class _BookingCardState extends State<_BookingCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _bgCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _hovered
                  ? _purple.withValues(alpha: 0.2)
                  : Colors.white.withValues(alpha: 0.08),
            ),
          ),
          child: Row(
            children: [
              // Initials avatar
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _purple.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    widget.initials,
                    style: const TextStyle(
                      color: _purpleLight,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Booking details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: const TextStyle(
                        color: _textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.event,
                      style: TextStyle(
                        color: _textSecondary.withValues(alpha: 0.7),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              // Amount and time
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    widget.amount,
                    style: const TextStyle(
                      color: _textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.time,
                    style: TextStyle(
                      color: _textSecondary.withValues(alpha: 0.6),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Bottom Navigation Bar ────────────────────────────────────────────────────
class _OrganizerBottomNav extends StatefulWidget {
  const _OrganizerBottomNav();

  @override
  State<_OrganizerBottomNav> createState() => _OrganizerBottomNavState();
}

class _OrganizerBottomNavState extends State<_OrganizerBottomNav> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _navItems = [
    {'icon': Icons.dashboard_rounded, 'label': 'Dashboard'},
    {'icon': Icons.event_rounded, 'label': 'My Events'},
    {'icon': Icons.assignment_rounded, 'label': 'Bookings'},
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
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
