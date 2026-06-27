import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:eventara/core/router/app_routes.dart';

// ─── Color tokens ──────────────────────────────────────────────────────────
const _bgDeep = Color(0xFF0D0B1E);
const _bgCard = Color(0xFF151228);
const _purple = Color(0xFF7B5CF6);
const _purpleLight = Color(0xFF9B8AFB);
const _textPrimary = Color(0xFFFFFFFF);
const _textSecondary = Color(0xFFB0A8D0);
const _accentGreen = Color(0xFF4ECB71);
const _accentRed = Color(0xFFFF6B6B);
const _accentBlue = Color(0xFF4ECDC4);

class EventBookingsListPage extends StatefulWidget {
  const EventBookingsListPage({super.key});

  @override
  State<EventBookingsListPage> createState() => _EventBookingsListPageState();
}

class _EventBookingsListPageState extends State<EventBookingsListPage> {
  String _selectedFilter = 'All';
  String _searchQuery = '';
  final List<String> _statusFilters = ['All', 'Confirmed', 'Cancelled'];

  final List<_EventData> _events = [
    _EventData(
      id: '1',
      name: 'Neon Nights: Electric Dreams',
      status: 'Active Event',
      icon: '🎵',
      totalBookings: 240,
      soldTickets: 842,
      revenue: 'LKR 42.5L',
    ),
  ];

  final List<_BookingData> _bookings = [
    _BookingData(
      bookingRef: 'EV-08234',
      customerName: 'J*** S***',
      ticketType: 'Premium - A12, A13',
      date: 'Oct 15, 2024',
      status: 'CONFIRMED',
      amountPaid: 'LKR 10,000',
    ),
    _BookingData(
      bookingRef: 'EV-08235',
      customerName: 'A*** M***',
      ticketType: 'Standard - B04',
      date: 'Oct 14, 2024',
      status: 'CONFIRMED',
      amountPaid: 'LKR 3,500',
    ),
    _BookingData(
      bookingRef: 'EV-08236',
      customerName: 'R*** K***',
      ticketType: 'VIP - V01',
      date: 'Oct 14, 2024',
      status: 'CANCELLED',
      amountPaid: 'LKR 15,000',
    ),
    _BookingData(
      bookingRef: 'EV-08240',
      customerName: 'S*** D***',
      ticketType: 'Premium - A40',
      date: 'Oct 12, 2024',
      status: 'CONFIRMED',
      amountPaid: 'LKR 5,000',
    ),
  ];

  List<_BookingData> get _filteredBookings {
    var filtered = _bookings;

    if (_selectedFilter != 'All') {
      filtered = filtered
          .where((b) => b.status == _selectedFilter.toUpperCase())
          .toList();
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((b) =>
              b.bookingRef.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              b.customerName
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return filtered;
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'CONFIRMED':
        return _accentGreen;
      case 'CANCELLED':
        return _accentRed;
      default:
        return _textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgDeep,
      appBar: AppBar(
        backgroundColor: _bgDeep,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_rounded, color: _textPrimary),
        ),
        title: const Text(
          'Bookings',
          style: TextStyle(
            color: _textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Event Selector ──────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'SELECT EVENT',
                            style: TextStyle(
                              color: _textSecondary,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _EventSelector(event: _events[0]),
                        ],
                      ),
                    ),

                    // ── Stats Cards ─────────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: _StatsCard(
                              label: 'TOTAL',
                              value: '${_events[0].totalBookings}',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _StatsCard(
                              label: 'SOLD',
                              value: '${_events[0].soldTickets}',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _StatsCard(
                              label: 'REVENUE',
                              value: _events[0].revenue,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── Search ──────────────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: _bgCard,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.08),
                          ),
                        ),
                        child: TextField(
                          onChanged: (value) => setState(() => _searchQuery = value),
                          decoration: const InputDecoration(
                            hintText: 'Search by name or booking ref',
                            hintStyle: TextStyle(
                              color: _textSecondary,
                              fontSize: 13,
                            ),
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              color: _textSecondary,
                              size: 18,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          style: const TextStyle(
                            color: _textPrimary,
                            fontSize: 13,
                          ),
                          cursorColor: _purple,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── Status Filter Chips ─────────────────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SizedBox(
                        height: 36,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _statusFilters.length,
                          itemBuilder: (context, index) {
                            final filter = _statusFilters[index];
                            final isSelected = _selectedFilter == filter;
                            return Padding(
                              padding: EdgeInsets.only(
                                right: index < _statusFilters.length - 1 ? 8 : 0,
                              ),
                              child: GestureDetector(
                                onTap: () =>
                                    setState(() => _selectedFilter = filter),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected ? _purple : _bgCard,
                                    borderRadius: BorderRadius.circular(20),
                                    border: isSelected
                                        ? null
                                        : Border.all(
                                            color: Colors.white
                                                .withValues(alpha: 0.1),
                                          ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      filter,
                                      style: TextStyle(
                                        color: isSelected
                                            ? _textPrimary
                                            : _textSecondary,
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

                    // ── Bookings List ───────────────────────────────────
                    if (_filteredBookings.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(32),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.receipt_long_outlined,
                                size: 48,
                                color: _textSecondary.withValues(alpha: 0.3),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No bookings found',
                                style: TextStyle(
                                  color:
                                      _textSecondary.withValues(alpha: 0.6),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: List.generate(
                            _filteredBookings.length,
                            (index) => Padding(
                              padding:
                                  EdgeInsets.only(bottom: index < _filteredBookings.length - 1 ? 12 : 0),
                              child: _BookingCard(
                                booking: _filteredBookings[index],
                                statusColor: _getStatusColor(
                                  _filteredBookings[index].status,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _OrganizerBottomNav(selectedIndex: 2),
    );
  }
}

// ── Event Data Model ────────────────────────────────────────────────────────
class _EventData {
  final String id;
  final String name;
  final String status;
  final String icon;
  final int totalBookings;
  final int soldTickets;
  final String revenue;

  _EventData({
    required this.id,
    required this.name,
    required this.status,
    required this.icon,
    required this.totalBookings,
    required this.soldTickets,
    required this.revenue,
  });
}

// ── Booking Data Model ──────────────────────────────────────────────────────
class _BookingData {
  final String bookingRef;
  final String customerName;
  final String ticketType;
  final String date;
  final String status;
  final String amountPaid;

  _BookingData({
    required this.bookingRef,
    required this.customerName,
    required this.ticketType,
    required this.date,
    required this.status,
    required this.amountPaid,
  });
}

// ── Event Selector Widget ───────────────────────────────────────────────────
class _EventSelector extends StatelessWidget {
  final _EventData event;

  const _EventSelector({required this.event});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Open event selection dropdown
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: _bgCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _purple.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  event.icon,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.name,
                    style: const TextStyle(
                      color: _textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    event.status,
                    style: TextStyle(
                      color: _accentGreen,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.expand_more_rounded,
              color: _textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Stats Card Widget ───────────────────────────────────────────────────────
class _StatsCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatsCard({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: _bgCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: _textSecondary,
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: _textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Booking Card Widget ─────────────────────────────────────────────────────
class _BookingCard extends StatefulWidget {
  final _BookingData booking;
  final Color statusColor;

  const _BookingCard({
    required this.booking,
    required this.statusColor,
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
      child: GestureDetector(
        onTap: () {
          // Open booking details
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _bgCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _hovered
                  ? _purple.withValues(alpha: 0.3)
                  : Colors.white.withValues(alpha: 0.08),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Booking Ref & Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.booking.bookingRef,
                    style: const TextStyle(
                      color: _textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: widget.statusColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: widget.statusColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      widget.booking.status,
                      style: TextStyle(
                        color: widget.statusColor,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Customer Name
              Text(
                widget.booking.customerName,
                style: const TextStyle(
                  color: _textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),

              // Ticket Type
              Row(
                children: [
                  Icon(
                    Icons.local_offer_rounded,
                    color: _textSecondary.withValues(alpha: 0.6),
                    size: 12,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      widget.booking.ticketType,
                      style: TextStyle(
                        color: _textSecondary.withValues(alpha: 0.7),
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              // Date
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    color: _textSecondary.withValues(alpha: 0.6),
                    size: 12,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    widget.booking.date,
                    style: TextStyle(
                      color: _textSecondary.withValues(alpha: 0.7),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Amount Paid
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'AMOUNT PAID',
                    style: TextStyle(
                      color: _textSecondary.withValues(alpha: 0.6),
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                  Text(
                    widget.booking.amountPaid,
                    style: const TextStyle(
                      color: _textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
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
