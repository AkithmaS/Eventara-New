import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:eventara/core/router/app_routes.dart';

// ─── Color tokens ──────────────────────────────────────────────────────────
const _bgDeep = Color(0xFF0D0B1E);
const _bgCard = Color(0xFF151228);
const _purpleLight = Color(0xFF9B8AFB);
const _gradStart = Color(0xFF7B5CF6);
const _gradEnd = Color(0xFFE07BB0);
const _textPrimary = Color(0xFFFFFFFF);
const _textSecondary = Color(0xFFB0A8D0);
const _accentGreen = Color(0xFF4ECB71);
const _accentOrange = Color(0xFFF59E0B);
const _accentRed = Color(0xFFEF4444);
const _accentBlue = Color(0xFF4ECDC4);

class CustomerDetailPage extends StatelessWidget {
  final String customerId;
  const CustomerDetailPage({super.key, required this.customerId});

  // Sample data — replace with real data from provider/repo
  Map<String, dynamic> get _customer => {
    'id': customerId,
    'name': 'Elena Vance',
    'email': 'elena.vance@eventara.com',
    'phone': '+94 77 123 4567',
    'joinDate': 'Jan 15, 2024',
    'avatar': 'EV',
    'status': 'active',
    'totalBookings': 12,
    'upcomingBookings': 3,
    'cancelledBookings': 1,
    'totalSpent': 'LKR 47,500',
  };

  static const List<Map<String, dynamic>> _bookings = [
    {'event': 'Neon Nights Music Fest', 'date': 'Oct 24, 2024',
     'seats': '2 seats', 'amount': 'LKR 10,000', 'status': 'CONFIRMED'},
    {'event': 'Tech Summit 2024', 'date': 'Nov 12, 2024',
     'seats': '1 seat', 'amount': 'LKR 3,500', 'status': 'CONFIRMED'},
    {'event': 'Charity Gala Dinner', 'date': 'Dec 05, 2024',
     'seats': '2 seats', 'amount': 'LKR 8,000', 'status': 'CANCELLED'},
    {'event': 'Jazz Under Stars', 'date': 'Jan 15, 2025',
     'seats': '1 seat', 'amount': 'LKR 5,000', 'status': 'UPCOMING'},
    {'event': 'Comedy Night Live', 'date': 'Feb 22, 2025',
     'seats': '3 seats', 'amount': 'LKR 9,000', 'status': 'UPCOMING'},
  ];

  Color _statusColor(String status) {
    switch (status) {
      case 'CONFIRMED': return _accentGreen;
      case 'CANCELLED': return _accentRed;
      case 'UPCOMING': return _accentBlue;
      default: return _accentOrange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = _customer;
    final isActive = c['status'] == 'active';

    return Scaffold(
      backgroundColor: _bgDeep,
      appBar: AppBar(
        backgroundColor: _bgDeep,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.go(AppRoutes.adminUsers),
          child: const Icon(Icons.arrow_back_rounded, color: _textPrimary),
        ),
        title: const Text('Customer Details',
            style: TextStyle(color: _textPrimary, fontSize: 18, fontWeight: FontWeight.w800)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Profile Header ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Column(
                children: [
                  // Avatar
                  Container(
                    width: 88, height: 88,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: [_gradStart, _gradEnd]),
                    ),
                    child: Center(
                      child: Text(c['avatar'],
                          style: const TextStyle(color: _textPrimary, fontSize: 28, fontWeight: FontWeight.w800)),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(c['name'],
                      style: const TextStyle(color: _textPrimary, fontSize: 22, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  Text(c['email'],
                      style: TextStyle(color: _textSecondary.withValues(alpha: 0.8), fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(c['phone'],
                      style: TextStyle(color: _textSecondary.withValues(alpha: 0.6), fontSize: 12)),
                  const SizedBox(height: 4),
                  Text('Member since ${c['joinDate']}',
                      style: TextStyle(color: _textSecondary.withValues(alpha: 0.5), fontSize: 11)),
                  const SizedBox(height: 12),
                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                    decoration: BoxDecoration(
                      color: (isActive ? _accentGreen : _accentRed).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: (isActive ? _accentGreen : _accentRed).withValues(alpha: 0.4)),
                    ),
                    child: Text(
                      isActive ? 'ACTIVE' : 'DEACTIVATED',
                      style: TextStyle(
                        color: isActive ? _accentGreen : _accentRed,
                        fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // ── Booking Stats ───────────────────────────────────────────
            _sectionLabel('BOOKING STATS'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10, crossAxisSpacing: 10,
                childAspectRatio: 2.4,
                children: [
                  _StatCard(label: 'Total Bookings', value: '${c['totalBookings']}', color: _purpleLight),
                  _StatCard(label: 'Upcoming', value: '${c['upcomingBookings']}', color: _accentBlue),
                  _StatCard(label: 'Cancelled', value: '${c['cancelledBookings']}', color: _accentRed),
                  _StatCard(label: 'Total Spent', value: c['totalSpent'], color: _accentGreen),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Recent Bookings ─────────────────────────────────────────
            _sectionLabel('RECENT BOOKINGS'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: _bookings.map((b) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: _bgCard,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(b['event'],
                                  style: const TextStyle(color: _textPrimary, fontSize: 12, fontWeight: FontWeight.w700),
                                  maxLines: 1, overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 4),
                              Row(children: [
                                Icon(Icons.calendar_today_rounded,
                                    color: _textSecondary.withValues(alpha: 0.5), size: 10),
                                const SizedBox(width: 4),
                                Text(b['date'],
                                    style: TextStyle(color: _textSecondary.withValues(alpha: 0.7), fontSize: 10)),
                                const SizedBox(width: 10),
                                Icon(Icons.event_seat_rounded,
                                    color: _textSecondary.withValues(alpha: 0.5), size: 10),
                                const SizedBox(width: 4),
                                Text(b['seats'],
                                    style: TextStyle(color: _textSecondary.withValues(alpha: 0.7), fontSize: 10)),
                              ]),
                              const SizedBox(height: 4),
                              Text(b['amount'],
                                  style: const TextStyle(color: _textPrimary, fontSize: 12, fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _statusColor(b['status']).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: _statusColor(b['status']).withValues(alpha: 0.3)),
                          ),
                          child: Text(b['status'],
                              style: TextStyle(
                                color: _statusColor(b['status']),
                                fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.3,
                              )),
                        ),
                      ],
                    ),
                  ),
                )).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // ── Danger Zone ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _accentRed.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _accentRed.withValues(alpha: 0.25)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Icon(Icons.warning_amber_rounded, color: _accentRed, size: 16),
                      const SizedBox(width: 6),
                      const Text('DANGER ZONE',
                          style: TextStyle(color: _accentRed, fontSize: 11,
                              fontWeight: FontWeight.w800, letterSpacing: 0.5)),
                    ]),
                    const SizedBox(height: 12),
                    Text('Deactivating this account will prevent the customer from logging in.',
                        style: TextStyle(color: _textSecondary.withValues(alpha: 0.7), fontSize: 12)),
                    const SizedBox(height: 14),
                    GestureDetector(
                      onTap: () => _showDeactivateDialog(context),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _accentRed.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: _accentRed.withValues(alpha: 0.4)),
                        ),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          const Icon(Icons.block_rounded, color: _accentRed, size: 16),
                          const SizedBox(width: 8),
                          const Text('Deactivate Account',
                              style: TextStyle(color: _accentRed, fontSize: 13, fontWeight: FontWeight.w700)),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String label) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(label,
          style: TextStyle(color: _textSecondary, fontSize: 11,
              fontWeight: FontWeight.w700, letterSpacing: 0.5)),
    ),
  );

  void _showDeactivateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: _bgCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Deactivate Account',
            style: TextStyle(color: _textPrimary, fontWeight: FontWeight.w800)),
        content: const Text(
          'Are you sure you want to deactivate this account? The customer will no longer be able to log in.',
          style: TextStyle(color: _textSecondary, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: _textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Confirm',
                style: TextStyle(color: _accentRed, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

// ── Stat Card Widget ─────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatCard({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: _bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Container(
            width: 6, height: 30,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label, style: TextStyle(color: _textSecondary.withValues(alpha: 0.7),
                  fontSize: 9, fontWeight: FontWeight.w600)),
              const SizedBox(height: 3),
              Text(value, style: const TextStyle(color: _textPrimary,
                  fontSize: 14, fontWeight: FontWeight.w800)),
            ],
          ),
        ],
      ),
    );
  }
}
