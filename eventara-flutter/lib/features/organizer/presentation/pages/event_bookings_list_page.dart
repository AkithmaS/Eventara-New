import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:eventara/core/router/app_routes.dart';
import '../../data/datasources/organizer_remote_datasource.dart';
import '../../data/models/organizer_event_model.dart';

// ─── Color tokens ──────────────────────────────────────────────────────────
const _bgDeep = Color(0xFF0D0B1E);
const _bgCard = Color(0xFF151228);
const _purple = Color(0xFF7B5CF6);
const _purpleLight = Color(0xFF9B8AFB);
const _textPrimary = Color(0xFFFFFFFF);
const _textSecondary = Color(0xFFB0A8D0);
const _accentGreen = Color(0xFF4ECB71);
const _accentRed = Color(0xFFFF6B6B);

final _bookingsDataProvider =
    FutureProvider<List<OrganizerBookingModel>>((ref) async {
  // Fetch all bookings via dashboard (recentBookings is available there)
  // For a full bookings list we'd need a dedicated endpoint; use getMyEvents
  // and load dashboard for now
  final ds = OrganizerRemoteDatasource();
  final dashboard = await ds.getDashboard();
  return dashboard.recentBookings;
});

class EventBookingsListPage extends ConsumerStatefulWidget {
  const EventBookingsListPage({super.key});

  @override
  ConsumerState<EventBookingsListPage> createState() =>
      _EventBookingsListPageState();
}

class _EventBookingsListPageState
    extends ConsumerState<EventBookingsListPage> {
  String _selectedFilter = 'All';
  String _searchQuery = '';
  final List<String> _statusFilters = ['All', 'CONFIRMED', 'CANCELLED'];

  Color _statusColor(String? status) {
    switch ((status ?? '').toUpperCase()) {
      case 'CONFIRMED': return _accentGreen;
      case 'CANCELLED': return _accentRed;
      default: return _textSecondary;
    }
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final dt = DateTime.parse(dateStr);
      const m = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
      return '${m[dt.month - 1]} ${dt.day}, ${dt.year}';
    } catch (_) { return dateStr; }
  }

  @override
  Widget build(BuildContext context) {
    final bookingsAsync = ref.watch(_bookingsDataProvider);

    return Scaffold(
      backgroundColor: _bgDeep,
      appBar: AppBar(
        backgroundColor: _bgDeep,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_rounded, color: _textPrimary),
        ),
        title: const Text('Bookings',
            style: TextStyle(color: _textPrimary, fontSize: 18, fontWeight: FontWeight.w800)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: bookingsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator(color: _purple)),
                error: (e, _) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: $e', style: const TextStyle(color: _textSecondary)),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () => ref.invalidate(_bookingsDataProvider),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: const LinearGradient(colors: [Color(0xFF7B5CF6), Color(0xFFE07BB0)]),
                          ),
                          child: const Text('Retry', style: TextStyle(color: _textPrimary, fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ],
                  ),
                ),
                data: (allBookings) {
                  final filtered = allBookings.where((b) {
                    final matchStatus = _selectedFilter == 'All' ||
                        b.status?.toUpperCase() == _selectedFilter;
                    final matchSearch = _searchQuery.isEmpty ||
                        (b.bookingReference?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false) ||
                        b.maskedCustomerName.toLowerCase().contains(_searchQuery.toLowerCase());
                    return matchStatus && matchSearch;
                  }).toList();

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Search ──────────────────────────────────────
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              color: _bgCard,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                            ),
                            child: TextField(
                              onChanged: (v) => setState(() => _searchQuery = v),
                              decoration: const InputDecoration(
                                hintText: 'Search by name or booking ref',
                                hintStyle: TextStyle(color: _textSecondary, fontSize: 13),
                                prefixIcon: Icon(Icons.search_rounded, color: _textSecondary, size: 18),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(vertical: 12),
                              ),
                              style: const TextStyle(color: _textPrimary, fontSize: 13),
                              cursorColor: _purple,
                            ),
                          ),
                        ),

                        // ── Filter Chips ────────────────────────────────
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
                                  padding: EdgeInsets.only(right: index < _statusFilters.length - 1 ? 8 : 0),
                                  child: GestureDetector(
                                    onTap: () => setState(() => _selectedFilter = filter),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: isSelected ? _purple : _bgCard,
                                        borderRadius: BorderRadius.circular(20),
                                        border: isSelected ? null : Border.all(color: Colors.white.withValues(alpha: 0.1)),
                                      ),
                                      child: Center(
                                        child: Text(filter,
                                            style: TextStyle(
                                                color: isSelected ? _textPrimary : _textSecondary,
                                                fontSize: 12, fontWeight: FontWeight.w600)),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // ── Bookings List ───────────────────────────────
                        if (filtered.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(32),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(Icons.receipt_long_outlined, size: 48, color: _textSecondary.withValues(alpha: 0.3)),
                                  const SizedBox(height: 12),
                                  Text('No bookings found', style: TextStyle(color: _textSecondary.withValues(alpha: 0.6), fontSize: 14)),
                                ],
                              ),
                            ),
                          )
                        else
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              children: filtered.map((booking) {
                                final color = _statusColor(booking.status);
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: _bgCard,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(booking.bookingReference ?? '-',
                                                style: const TextStyle(color: _textPrimary, fontSize: 12, fontWeight: FontWeight.w700)),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                              decoration: BoxDecoration(
                                                color: color.withValues(alpha: 0.15),
                                                borderRadius: BorderRadius.circular(4),
                                                border: Border.all(color: color.withValues(alpha: 0.3)),
                                              ),
                                              child: Text(booking.status ?? '',
                                                  style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w700)),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(booking.maskedCustomerName,
                                            style: const TextStyle(color: _textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
                                        const SizedBox(height: 4),
                                        Text(booking.eventName ?? '',
                                            style: TextStyle(color: _textSecondary.withValues(alpha: 0.7), fontSize: 11)),
                                        if (booking.seatDetails != null) ...[
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Icon(Icons.event_seat_rounded, color: _textSecondary.withValues(alpha: 0.6), size: 12),
                                              const SizedBox(width: 6),
                                              Expanded(child: Text(booking.seatDetails!, style: TextStyle(color: _textSecondary.withValues(alpha: 0.7), fontSize: 11))),
                                            ],
                                          ),
                                        ],
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(Icons.calendar_today_rounded, color: _textSecondary.withValues(alpha: 0.6), size: 12),
                                            const SizedBox(width: 6),
                                            Text(_formatDate(booking.createdAt),
                                                style: TextStyle(color: _textSecondary.withValues(alpha: 0.7), fontSize: 11)),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('${booking.quantity ?? 1} ticket(s)',
                                                style: TextStyle(color: _textSecondary.withValues(alpha: 0.7), fontSize: 11)),
                                            Text('LKR ${(booking.totalAmount ?? 0).toStringAsFixed(0)}',
                                                style: const TextStyle(color: _textPrimary, fontSize: 13, fontWeight: FontWeight.w800)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _OrganizerBottomNav(selectedIndex: 2),
    );
  }
}

class _OrganizerBottomNav extends StatelessWidget {
  final int selectedIndex;
  const _OrganizerBottomNav({required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    final navItems = [
      {'icon': Icons.dashboard_rounded, 'label': 'Dashboard'},
      {'icon': Icons.event_rounded, 'label': 'My Events'},
      {'icon': Icons.assignment_rounded, 'label': 'Bookings'},
      {'icon': Icons.person_rounded, 'label': 'Profile'},
    ];
    return Container(
      decoration: BoxDecoration(
        color: _bgCard,
        border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(navItems.length, (i) {
              final item = navItems[i];
              final isSel = selectedIndex == i;
              return GestureDetector(
                onTap: () {
                  switch (i) {
                    case 0: context.go(AppRoutes.organizerDashboard); break;
                    case 1: context.go(AppRoutes.organizerMyEvents); break;
                    case 2: context.go(AppRoutes.organizerBookings); break;
                    case 3: context.go(AppRoutes.organizerProfile); break;
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item['icon'] as IconData, color: isSel ? _purpleLight : _textSecondary, size: 24),
                    const SizedBox(height: 4),
                    Text(item['label'] as String,
                        style: TextStyle(color: isSel ? _purpleLight : _textSecondary, fontSize: 11, fontWeight: FontWeight.w600)),
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
