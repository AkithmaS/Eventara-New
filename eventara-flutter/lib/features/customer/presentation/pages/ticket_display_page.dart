import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:eventara/core/router/app_routes.dart';

// ─── Colour tokens ──────────────────────────────────────────────────────────
const _bgDeep = Color(0xFF0D0B1E);
const _bgCard = Color(0xFF151228);
const _purple = Color(0xFF7B5CF6);
const _purpleLight = Color(0xFF9B8AFB);
const _gradEnd = Color(0xFFE07BB0);
const _textPrimary = Color(0xFFFFFFFF);
const _textSecondary = Color(0xFFB0A8D0);
const _accentCyan = Color(0xFF4ECDC4);
const _accentRed = Color(0xFFFF6B6B);

class TicketDisplayPage extends StatefulWidget {
  const TicketDisplayPage({super.key});

  @override
  State<TicketDisplayPage> createState() => _TicketDisplayPageState();
}

class _TicketDisplayPageState extends State<TicketDisplayPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  final List<_TicketData> _upcomingTickets = [
    _TicketData(
      id: '1',
      eventName: 'Neon Pulse Festival',
      date: 'Aug 24, 2026 • 10:00 PM',
      venue: 'Neon Gardens, Los Angeles',
      seatInfo: 'Row B • Seat 12',
      bookingRef: '#BK-2026-N7X9',
      image: 'assets/images/neon.jpg',
      status: 'upcoming',
      holderName: 'John Doe',
      totalPrice: '150.00',
    ),
    _TicketData(
      id: '2',
      eventName: 'Midnight Jazz Lounge',
      date: 'Sep 12, 2026 • 21:30',
      venue: 'The Blue Note, NYC',
      seatInfo: 'VIP Table 4',
      bookingRef: '#BK-2026-JPW2',
      image: 'assets/images/jazz.jpg',
      status: 'upcoming',
      holderName: 'Jane Smith',
      totalPrice: '250.00',
    ),
  ];

  final List<_TicketData> _pastTickets = [
    _TicketData(
      id: '3',
      eventName: 'Summer Music Festival',
      date: 'Jul 15, 2026 • 18:00',
      venue: 'Central Park, NY',
      seatInfo: 'General Admission',
      bookingRef: '#BK-2026-SUM1',
      image: 'assets/images/festival.jpg',
      status: 'past',
      holderName: 'Alex Johnson',
      totalPrice: '75.00',
    ),
  ];

  final List<_TicketData> _cancelledTickets = [
    _TicketData(
      id: '4',
      eventName: 'Global Tech Summit',
      date: 'Oct 06, 2026 • 09:00',
      venue: 'Convention Center, SF',
      seatInfo: 'General Admission',
      bookingRef: '#BK-2026-T481',
      image: 'assets/images/tech.jpg',
      status: 'cancelled',
      holderName: 'Chris Lee',
      totalPrice: '200.00',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgDeep,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header with Menu and Notification ────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Menu action
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: _bgCard,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.menu_rounded,
                          color: _textPrimary,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    'My Tickets',
                    style: TextStyle(
                      color: _purpleLight,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Notification action
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: _bgCard,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.notifications_rounded,
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
            // ── Tab Bar ──────────────────────────────────────────────
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: _bgCard,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: _purple,
                  borderRadius: BorderRadius.circular(10),
                ),
                labelColor: _textPrimary,
                unselectedLabelColor: _textSecondary,
                labelStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                tabs: const [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text('Upcoming'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text('Past'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text('Cancelled'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // ── Tab Views ────────────────────────────────────────────
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Upcoming Tickets
                  _TicketListView(tickets: _upcomingTickets),
                  // Past Tickets
                  _TicketListView(tickets: _pastTickets),
                  // Cancelled Tickets
                  _TicketListView(tickets: _cancelledTickets),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNavBar(),
    );
  }
}

/// Ticket data model
class _TicketData {
  final String id;
  final String eventName;
  final String date;
  final String venue;
  final String seatInfo;
  final String bookingRef;
  final String image;
  final String status;
  final String holderName;
  final String totalPrice;

  _TicketData({
    required this.id,
    required this.eventName,
    required this.date,
    required this.venue,
    required this.seatInfo,
    required this.bookingRef,
    required this.image,
    required this.status,
    required this.holderName,
    required this.totalPrice,
  });
}

/// List view for tickets
class _TicketListView extends StatelessWidget {
  final List<_TicketData> tickets;

  const _TicketListView({required this.tickets});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: tickets.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _TicketCard(ticket: tickets[index]),
        );
      },
    );
  }
}

/// Individual ticket card
class _TicketCard extends StatefulWidget {
  final _TicketData ticket;

  const _TicketCard({required this.ticket});

  @override
  State<_TicketCard> createState() => _TicketCardState();
}

class _TicketCardState extends State<_TicketCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isCancelled = widget.ticket.status == 'cancelled';
    final statusColor = isCancelled ? _accentRed : _accentCyan;
    final statusText = isCancelled ? 'CANCELLED' : 'UPCOMING';

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: Container(
          decoration: BoxDecoration(
            color: _bgCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Image
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        _purple.withValues(alpha: 0.3),
                        _gradEnd.withValues(alpha: 0.2),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.music_note_rounded,
                      size: 60,
                      color: _purple.withValues(alpha: 0.4),
                    ),
                  ),
                ),
              ),
              // Event Details
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.ticket.eventName,
                      style: const TextStyle(
                        color: _textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_rounded,
                          color: _textSecondary,
                          size: 13,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          widget.ticket.date,
                          style: TextStyle(
                            color: _textSecondary.withValues(alpha: 0.8),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          color: _textSecondary,
                          size: 13,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            widget.ticket.venue,
                            style: TextStyle(
                              color: _textSecondary.withValues(alpha: 0.8),
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.ticket.seatInfo,
                      style: TextStyle(
                        color: _textSecondary.withValues(alpha: 0.7),
                        fontSize: 11,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Status badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: statusColor.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            statusText,
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        // Booking reference
                        Text(
                          widget.ticket.bookingRef,
                          style: TextStyle(
                            color: _textSecondary.withValues(alpha: 0.6),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Action Button
                    SizedBox(
                      width: double.infinity,
                      child: GestureDetector(
                        onTap: () {
                          // Extract date from format "Aug 24, 2026 • 10:00 PM" → "Aug 24, 2026"
                          final eventDate = widget.ticket.date.split(' • ')[0];
                          final seatsCount = widget.ticket.seatInfo.contains('General')
                              ? '1'
                              : widget.ticket.seatInfo.split(' ').last; // Extract seat count
                          
                          context.go(
                            AppRoutes.buildCustomerBookingConfirmation(
                              widget.ticket.bookingRef.replaceAll('#BK-2026-', ''),
                              eventName: widget.ticket.eventName,
                              eventDate: eventDate,
                              venue: widget.ticket.venue,
                              holderName: widget.ticket.holderName,
                              seatsCount: seatsCount,
                              totalPrice: widget.ticket.totalPrice,
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _purpleLight.withValues(alpha: 0.4),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              widget.ticket.status == 'cancelled'
                                  ? 'Details'
                                  : 'View Ticket',
                              style: const TextStyle(
                                color: _purpleLight,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
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

/// Bottom Navigation Bar
class _BottomNavBar extends StatefulWidget {
  const _BottomNavBar();

  @override
  State<_BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<_BottomNavBar> {
  int _selectedIndex = 2; // My Tickets is index 2

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
