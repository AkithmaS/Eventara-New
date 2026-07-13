import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:eventara/core/router/app_routes.dart';
import '../providers/booking_notifier.dart';
import '../../domain/entities/booking_entity.dart';

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

class TicketDisplayPage extends ConsumerStatefulWidget {
  const TicketDisplayPage({super.key});

  @override
  ConsumerState<TicketDisplayPage> createState() => _TicketDisplayPageState();
}

class _TicketDisplayPageState extends ConsumerState<TicketDisplayPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(bookingNotifierProvider.notifier).loadMyBookings();
    });
  }

  TicketEntity _bookingToTicket(BookingEntity booking) {
    return TicketEntity(
      id: booking.id,
      ticketCode: booking.bookingReference,
      bookingReference: booking.bookingReference,
      eventId: booking.eventId,
      eventName: booking.eventName,
      eventDate: booking.createdAt,
      venue: booking.seatDetails ?? 'TBD',
      customerName: booking.customerName,
      seatDetails: booking.seatDetails,
      quantity: booking.quantity,
      totalAmount: booking.totalAmount,
      status: _mapBookingStatusToTicketStatus(booking.status),
      issuedAt: booking.createdAt,
      qrCodeBase64: null,
    );
  }

  String _mapBookingStatusToTicketStatus(String bookingStatus) {
    return switch (bookingStatus) {
      'CONFIRMED' => 'VALID',
      'CANCELLED' => 'CANCELLED',
      'PENDING' => 'VALID',
      _ => 'VALID',
    };
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookingNotifierProvider);

    List<TicketEntity> allTickets = [];
    bool isLoading = false;
    String? errorMsg;

    if (state is BookingLoading) isLoading = true;
    if (state is BookingsLoaded) {
      allTickets = state.bookings.map((b) => _bookingToTicket(b)).toList();
    }
    if (state is BookingError) errorMsg = state.message;

    final upcoming = allTickets.where((t) => t.isValid).toList();
    final past = allTickets.where((t) => t.isUsed || t.isExpired).toList();
    final cancelled = allTickets.where((t) => t.isCancelled).toList();

    return Scaffold(
      backgroundColor: _bgDeep,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: _bgCard),
                    child: IconButton(
                      icon: const Icon(Icons.refresh_rounded, color: _textPrimary, size: 20),
                      onPressed: () => ref.read(bookingNotifierProvider.notifier).loadMyBookings(),
                    ),
                  ),
                  const Text('My Tickets',
                      style: TextStyle(color: _purpleLight, fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // ── Tab Bar ──────────────────────────────────────────────
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(color: _bgCard, borderRadius: BorderRadius.circular(12)),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(color: _purple, borderRadius: BorderRadius.circular(10)),
                labelColor: _textPrimary,
                unselectedLabelColor: _textSecondary,
                labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                unselectedLabelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                tabs: const [
                  Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Text('Valid')),
                  Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Text('Past')),
                  Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Text('Cancelled')),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator(color: _purpleLight))
                  : errorMsg != null
                      ? Center(child: Text(errorMsg, style: const TextStyle(color: _textSecondary)))
                      : TabBarView(
                          controller: _tabController,
                          children: [
                            _TicketListView(tickets: upcoming),
                            _TicketListView(tickets: past),
                            _TicketListView(tickets: cancelled),
                          ],
                        ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const _BottomNavBar(),
    );
  }
}

class _TicketListView extends StatelessWidget {
  final List<TicketEntity> tickets;
  const _TicketListView({required this.tickets});

  @override
  Widget build(BuildContext context) {
    if (tickets.isEmpty) {
      return const Center(child: Text('No tickets', style: TextStyle(color: _textSecondary, fontSize: 15)));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: tickets.length,
      itemBuilder: (context, i) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: _TicketCard(ticket: tickets[i]),
      ),
    );
  }
}

class _TicketCard extends StatefulWidget {
  final TicketEntity ticket;
  const _TicketCard({required this.ticket});

  @override
  State<_TicketCard> createState() => _TicketCardState();
}

class _TicketCardState extends State<_TicketCard> {
  bool _hovered = false;
  bool _showQr = false;

  @override
  Widget build(BuildContext context) {
    final isCancelled = widget.ticket.isCancelled;
    final statusColor = isCancelled ? _accentRed : _accentCyan;
    final statusText = widget.ticket.status;

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
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top image area
              ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                child: Container(
                  height: 100, width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft, end: Alignment.bottomRight,
                      colors: [_purple.withValues(alpha: 0.3), _gradEnd.withValues(alpha: 0.2)],
                    ),
                  ),
                  child: Center(child: Icon(Icons.confirmation_number_rounded, size: 50, color: _purple.withValues(alpha: 0.5))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.ticket.eventName,
                        style: const TextStyle(color: _textPrimary, fontSize: 15, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 6),
                    Row(children: [
                      const Icon(Icons.calendar_today_rounded, color: _textSecondary, size: 13),
                      const SizedBox(width: 6),
                      Text(widget.ticket.eventDate, style: TextStyle(color: _textSecondary.withValues(alpha: 0.8), fontSize: 12)),
                    ]),
                    const SizedBox(height: 4),
                    Row(children: [
                      const Icon(Icons.location_on_rounded, color: _textSecondary, size: 13),
                      const SizedBox(width: 6),
                      Expanded(child: Text(widget.ticket.venue,
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: _textSecondary.withValues(alpha: 0.8), fontSize: 12))),
                    ]),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                          ),
                          child: Text(statusText,
                              style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                        ),
                        Text(widget.ticket.ticketCode,
                            style: TextStyle(color: _textSecondary.withValues(alpha: 0.6), fontSize: 11, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    // QR Code
                    if (widget.ticket.qrCodeBase64 != null) ...[
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () => setState(() => _showQr = !_showQr),
                        child: Text(_showQr ? 'Hide QR Code' : 'Show QR Code',
                            style: const TextStyle(color: _purpleLight, fontSize: 13, fontWeight: FontWeight.w600)),
                      ),
                      if (_showQr) ...[
                        const SizedBox(height: 12),
                        Center(
                          child: Container(
                            width: 180, height: 180,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                            child: Image.memory(
                              base64Decode(widget.ticket.qrCodeBase64!),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ],
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

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  @override
  Widget build(BuildContext context) {
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
            children: [
              _navItem(context, Icons.home_rounded, 'Home', AppRoutes.customerHome, false),
              _navItem(context, Icons.search_rounded, 'Explore', AppRoutes.customerAllEvents, false),
              _navItem(context, Icons.bookmark_rounded, 'My Tickets', AppRoutes.customerMyTickets, true),
              _navItem(context, Icons.person_rounded, 'Profile', AppRoutes.customerProfile, false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(BuildContext context, IconData icon, String label, String route, bool selected) {
    return GestureDetector(
      onTap: () => context.go(route),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: selected ? _purpleLight : _textSecondary, size: 24),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: selected ? _purpleLight : _textSecondary, fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
