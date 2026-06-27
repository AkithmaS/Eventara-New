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

class OrganizerDetailPage extends StatelessWidget {
  final String organizerId;
  const OrganizerDetailPage({super.key, required this.organizerId});

  Map<String, dynamic> get _organizer => {
    'id': organizerId,
    'name': 'Marcus Chen',
    'company': 'Chen Events Co.',
    'email': 'm.chen@gmail.com',
    'phone': '+94 77 987 6543',
    'joinDate': 'Feb 22, 2024',
    'avatar': 'MC',
    'status': 'active',
    'totalEvents': 8,
    'activeEvents': 2,
    'totalRevenue': 'LKR 1.2M',
    'totalTicketsSold': 3240,
  };

  static const List<Map<String, dynamic>> _events = [
    {'title': 'Neon Nights Music Fest', 'date': 'Oct 24, 2024',
     'tickets': '842 sold', 'revenue': 'LKR 420K', 'status': 'PUBLISHED'},
    {'title': 'Tech Summit 2024', 'date': 'Nov 12, 2024',
     'tickets': '0 sold', 'revenue': 'LKR 0', 'status': 'DRAFT'},
    {'title': 'Charity Gala Dinner', 'date': 'Dec 05, 2024',
     'tickets': '120 sold', 'revenue': 'LKR 84K', 'status': 'SUBMITTED'},
    {'title': 'Jazz Under Stars', 'date': 'Jan 15, 2025',
     'tickets': '280 sold', 'revenue': 'LKR 280K', 'status': 'PUBLISHED'},
  ];

  Color _statusColor(String s) {
    switch (s) {
      case 'PUBLISHED': return _accentGreen;
      case 'DRAFT':     return _textSecondary;
      case 'SUBMITTED': return _accentBlue;
      default:          return _accentOrange;
    }
  }

  Color _accountStatusColor(String s) =>
      s == 'active' ? _accentGreen : s == 'suspended' ? _accentRed : _accentOrange;

  String _accountStatusLabel(String s) =>
      s == 'active' ? 'ACTIVE' : s == 'suspended' ? 'SUSPENDED' : 'PENDING';

  @override
  Widget build(BuildContext context) {
    final o = _organizer;
    final statusColor = _accountStatusColor(o['status']);

    return Scaffold(
      backgroundColor: _bgDeep,
      appBar: AppBar(
        backgroundColor: _bgDeep,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.go(AppRoutes.adminUsers),
          child: const Icon(Icons.arrow_back_rounded, color: _textPrimary),
        ),
        title: const Text('Organizer Details',
            style: TextStyle(color: _textPrimary, fontSize: 18, fontWeight: FontWeight.w800)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Profile Header ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Column(
                children: [
                  Container(
                    width: 88, height: 88,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: [_gradStart, _gradEnd]),
                    ),
                    child: Center(
                      child: Text(o['avatar'],
                          style: const TextStyle(color: _textPrimary, fontSize: 28, fontWeight: FontWeight.w800)),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(o['name'],
                      style: const TextStyle(color: _textPrimary, fontSize: 22, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text(o['company'],
                      style: TextStyle(color: _textSecondary.withValues(alpha: 0.8), fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(o['email'],
                      style: TextStyle(color: _textSecondary.withValues(alpha: 0.6), fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(o['phone'],
                      style: TextStyle(color: _textSecondary.withValues(alpha: 0.6), fontSize: 12)),
                  const SizedBox(height: 4),
                  Text('Member since ${o['joinDate']}',
                      style: TextStyle(color: _textSecondary.withValues(alpha: 0.5), fontSize: 11)),
                  const SizedBox(height: 12),
                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: statusColor.withValues(alpha: 0.4)),
                    ),
                    child: Text(_accountStatusLabel(o['status']),
                        style: TextStyle(color: statusColor, fontSize: 11,
                            fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // ── Stats Grid ────────────────────────────────────────────
            _label('PERFORMANCE STATS'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10, crossAxisSpacing: 10,
                childAspectRatio: 2.4,
                children: [
                  _StatCard(label: 'Total Events',   value: '${o['totalEvents']}',       color: _purpleLight),
                  _StatCard(label: 'Active Events',  value: '${o['activeEvents']}',      color: _accentGreen),
                  _StatCard(label: 'Tickets Sold',   value: '${o['totalTicketsSold']}',  color: _accentBlue),
                  _StatCard(label: 'Total Revenue',  value: o['totalRevenue'],            color: _accentOrange),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Recent Events ─────────────────────────────────────────
            _label('RECENT EVENTS'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: _events.map((e) => Padding(
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
                              Text(e['title'],
                                  style: const TextStyle(color: _textPrimary, fontSize: 12, fontWeight: FontWeight.w700),
                                  maxLines: 1, overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 4),
                              Row(children: [
                                Icon(Icons.calendar_today_rounded,
                                    color: _textSecondary.withValues(alpha: 0.5), size: 10),
                                const SizedBox(width: 4),
                                Text(e['date'],
                                    style: TextStyle(color: _textSecondary.withValues(alpha: 0.7), fontSize: 10)),
                              ]),
                              const SizedBox(height: 4),
                              Row(children: [
                                Icon(Icons.confirmation_number_rounded,
                                    color: _textSecondary.withValues(alpha: 0.5), size: 10),
                                const SizedBox(width: 4),
                                Text(e['tickets'],
                                    style: TextStyle(color: _textSecondary.withValues(alpha: 0.7), fontSize: 10)),
                                const SizedBox(width: 10),
                                Text(e['revenue'],
                                    style: const TextStyle(color: _accentGreen, fontSize: 10, fontWeight: FontWeight.w700)),
                              ]),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _statusColor(e['status']).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: _statusColor(e['status']).withValues(alpha: 0.3)),
                          ),
                          child: Text(e['status'],
                              style: TextStyle(color: _statusColor(e['status']),
                                  fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.3)),
                        ),
                      ],
                    ),
                  ),
                )).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // ── Admin Actions ─────────────────────────────────────────
            _label('ADMIN ACTIONS'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // Suspend / Unsuspend
                  _ActionRow(
                    icon: Icons.pause_circle_outline_rounded,
                    title: o['status'] == 'suspended' ? 'Unsuspend Account' : 'Suspend Account',
                    subtitle: o['status'] == 'suspended'
                        ? 'Allow organizer to post events again'
                        : 'Prevent organizer from posting new events',
                    color: _accentOrange,
                    onTap: () => _showConfirmDialog(
                      context,
                      title: o['status'] == 'suspended' ? 'Unsuspend Account' : 'Suspend Account',
                      message: o['status'] == 'suspended'
                          ? 'Are you sure you want to unsuspend this organizer?'
                          : 'Are you sure you want to suspend this organizer? They will not be able to post new events.',
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Danger Zone ───────────────────────────────────────────
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
                      const Icon(Icons.warning_amber_rounded, color: _accentRed, size: 16),
                      const SizedBox(width: 6),
                      const Text('DANGER ZONE', style: TextStyle(color: _accentRed, fontSize: 11,
                          fontWeight: FontWeight.w800, letterSpacing: 0.5)),
                    ]),
                    const SizedBox(height: 12),
                    Text('Deactivating this account will permanently revoke organizer access.',
                        style: TextStyle(color: _textSecondary.withValues(alpha: 0.7), fontSize: 12)),
                    const SizedBox(height: 14),
                    GestureDetector(
                      onTap: () => _showConfirmDialog(
                        context,
                        title: 'Deactivate Organizer',
                        message: 'Are you sure you want to deactivate this organizer account?'
                            ' They will no longer be able to log in or manage events.',
                        isDestructive: true,
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _accentRed.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: _accentRed.withValues(alpha: 0.4)),
                        ),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
                          Icon(Icons.block_rounded, color: _accentRed, size: 16),
                          SizedBox(width: 8),
                          Text('Deactivate Account',
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

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(text, style: TextStyle(color: _textSecondary, fontSize: 11,
          fontWeight: FontWeight.w700, letterSpacing: 0.5)),
    ),
  );

  void _showConfirmDialog(BuildContext context,
      {required String title, required String message, bool isDestructive = false}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: _bgCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title,
            style: const TextStyle(color: _textPrimary, fontWeight: FontWeight.w800)),
        content: Text(message,
            style: const TextStyle(color: _textSecondary, fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: _textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Confirm',
                style: TextStyle(
                  color: isDestructive ? _accentRed : _accentOrange,
                  fontWeight: FontWeight.w700,
                )),
          ),
        ],
      ),
    );
  }
}

// ── Action Row ───────────────────────────────────────────────────────────────
class _ActionRow extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ActionRow({required this.icon, required this.title, required this.subtitle,
      required this.color, required this.onTap});

  @override
  State<_ActionRow> createState() => _ActionRowState();
}

class _ActionRowState extends State<_ActionRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _bgCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _hovered ? widget.color.withValues(alpha: 0.25) : Colors.white.withValues(alpha: 0.08),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: widget.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(widget.icon, color: widget.color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.title,
                        style: const TextStyle(color: _textPrimary, fontSize: 13, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(widget.subtitle,
                        style: TextStyle(color: _textSecondary.withValues(alpha: 0.6), fontSize: 11)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded,
                  color: _hovered ? widget.color : _textSecondary, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Stat Card ────────────────────────────────────────────────────────────────
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
