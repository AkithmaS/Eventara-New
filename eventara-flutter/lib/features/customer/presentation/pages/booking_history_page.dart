import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:eventara/core/router/app_routes.dart';
import '../providers/booking_notifier.dart';
import '../../domain/entities/booking_entity.dart';

// ─── Colour tokens ──────────────────────────────────────────────────────────
const _bgDeep = Color(0xFF0D0B1E);
const _bgCard = Color(0xFF151228);
const _purpleLight = Color(0xFF9B8AFB);
const _textPrimary = Color(0xFFFFFFFF);
const _textSecondary = Color(0xFFB0A8D0);
const _accentGreen = Color(0xFF4ECB71);
const _accentOrange = Color(0xFFD97744);
const _accentRed = Color(0xFFFF6B6B);

class BookingHistoryPage extends ConsumerStatefulWidget {
  const BookingHistoryPage({super.key});

  @override
  ConsumerState<BookingHistoryPage> createState() => _BookingHistoryPageState();
}

class _BookingHistoryPageState extends ConsumerState<BookingHistoryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(bookingNotifierProvider.notifier).loadMyBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookingNotifierProvider);

    List<BookingEntity> bookings = [];
    bool isLoading = false;
    String? errorMsg;

    if (state is BookingLoading) isLoading = true;
    if (state is BookingsLoaded) bookings = state.bookings;
    if (state is BookingError) errorMsg = state.message;

    return Scaffold(
      backgroundColor: _bgDeep,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────────
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
                      child: const Icon(Icons.arrow_back_ios_new_rounded, color: _textSecondary, size: 16),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Text('Booking History',
                      style: TextStyle(color: _textPrimary, fontSize: 20, fontWeight: FontWeight.w700)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.refresh_rounded, color: _textSecondary),
                    onPressed: () => ref.read(bookingNotifierProvider.notifier).loadMyBookings(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator(color: _purpleLight))
                  : errorMsg != null
                      ? Center(child: Text(errorMsg, style: const TextStyle(color: _textSecondary, fontSize: 15)))
                      : bookings.isEmpty
                          ? const Center(child: Text('No bookings yet', style: TextStyle(color: _textSecondary, fontSize: 15)))
                          : ListView.separated(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                              itemCount: bookings.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 12),
                              itemBuilder: (ctx, i) => _BookingCard(
                                booking: bookings[i],
                                onCancel: () async {
                                  await ref
                                      .read(bookingNotifierProvider.notifier)
                                      .cancelBooking(bookings[i].id);
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Booking cancelled.')),
                                    );
                                  }
                                },
                              ),
                            ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const _BottomNavBar(),
    );
  }
}

class _BookingCard extends StatefulWidget {
  final BookingEntity booking;
  final VoidCallback onCancel;

  const _BookingCard({required this.booking, required this.onCancel});

  @override
  State<_BookingCard> createState() => _BookingCardState();
}

class _BookingCardState extends State<_BookingCard> {
  bool _showQr = false;

  Color get _statusColor {
    switch (widget.booking.status) {
      case 'CONFIRMED': return _accentGreen;
      case 'PENDING': return _accentOrange;
      default: return _accentRed;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(widget.booking.eventName,
                    style: const TextStyle(color: _textPrimary, fontSize: 15, fontWeight: FontWeight.w700),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: _statusColor.withValues(alpha: 0.3)),
                ),
                child: Text(widget.booking.status,
                    style: TextStyle(color: _statusColor, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('Ref: ${widget.booking.bookingReference}',
              style: TextStyle(color: _textSecondary.withValues(alpha: 0.7), fontSize: 12)),
          const SizedBox(height: 4),
          // Ticket info with total
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tickets: ${widget.booking.quantity}',
                  style: const TextStyle(color: _purpleLight, fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text('Total: LKR ${widget.booking.totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(color: _textSecondary.withValues(alpha: 0.8), fontSize: 12)),
            ],
          ),
          const SizedBox(height: 4),
          Text(widget.booking.createdAt,
              style: TextStyle(color: _textSecondary.withValues(alpha: 0.6), fontSize: 11)),
          // QR Code Section
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => setState(() => _showQr = !_showQr),
            child: Row(
              children: [
                Icon(_showQr ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                    color: _purpleLight, size: 16),
                const SizedBox(width: 6),
                Text(_showQr ? 'Hide QR Code' : 'Show QR Code',
                    style: const TextStyle(color: _purpleLight, fontSize: 13, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          if (_showQr) ...[
            const SizedBox(height: 12),
            Center(
              child: Container(
                width: 160,
                height: 160,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _purpleLight.withValues(alpha: 0.3), width: 2),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Placeholder QR pattern
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8E8E8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.qr_code_2, size: 50, color: Colors.grey[600]),
                            const SizedBox(height: 4),
                            Text(widget.booking.bookingReference.substring(0, 6),
                                style: TextStyle(fontSize: 10, color: Colors.grey[600], fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          // Cancel Button
          if (widget.booking.isConfirmed) ...[
            const SizedBox(height: 12),
            GestureDetector(
              onTap: widget.onCancel,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _accentRed.withValues(alpha: 0.4)),
                ),
                child: Center(
                  child: Text('Cancel Booking',
                      style: TextStyle(color: _accentRed, fontSize: 13, fontWeight: FontWeight.w700)),
                ),
              ),
            ),
          ],
        ],
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
              _navItem(context, Icons.bookmark_rounded, 'My Tickets', AppRoutes.customerMyTickets, false),
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
