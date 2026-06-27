import 'package:flutter/material.dart';

// ─── Color tokens ──────────────────────────────────────────────────────────
const _bgDeep = Color(0xFF0D0B1E);
const _bgCard = Color(0xFF151228);
const _purple = Color(0xFF7B5CF6);
const _purpleLight = Color(0xFF9B8AFB);
const _gradStart = Color(0xFF7B5CF6);
const _gradEnd = Color(0xFFE07BB0);
const _textPrimary = Color(0xFFFFFFFF);
const _textSecondary = Color(0xFFB0A8D0);
const _accentGreen = Color(0xFF4ECB71);
const _accentRed = Color(0xFFFF6B6B);

class OrganizerReportsPage extends StatefulWidget {
  const OrganizerReportsPage({super.key});

  @override
  State<OrganizerReportsPage> createState() => _OrganizerReportsPageState();
}

class _OrganizerReportsPageState extends State<OrganizerReportsPage> {
  String _selectedEvent = 'All Events';
  final List<String> _events = ['All Events', 'Neon Nights 2024', 'Summer Jazz Festival', 'Tech Expo 2024'];

  final List<_EventReport> _topEvents = [
    _EventReport(
      name: 'Neon Nights 2024',
      revenue: 'LKR 1.2M',
      progress: 0.85,
    ),
    _EventReport(
      name: 'Summer Jazz Festival',
      revenue: 'LKR 800K',
      progress: 0.65,
    ),
    _EventReport(
      name: 'Tech Expo Collection',
      revenue: 'LKR 600K',
      progress: 0.45,
    ),
  ];

  final List<_TransactionData> _transactions = [
    _TransactionData(
      bookingRef: 'EV-08245',
      date: 'Today, 2:45 PM',
      amount: 'LKR 10,000',
      status: 'SUCCESS',
      icon: Icons.check_circle_rounded,
    ),
    _TransactionData(
      bookingRef: 'EV-08244',
      date: 'Today, 1:30 PM',
      amount: 'LKR 8,500',
      status: 'SUCCESS',
      icon: Icons.check_circle_rounded,
    ),
    _TransactionData(
      bookingRef: 'EV-08243',
      date: 'Yesterday, 6:45 PM',
      amount: 'LKR 4,200',
      status: 'SUCCESS',
      icon: Icons.check_circle_rounded,
    ),
    _TransactionData(
      bookingRef: 'EV-08242',
      date: 'Yesterday, 3:10 PM',
      amount: 'LKR 12,000',
      status: 'REFUNDED',
      icon: Icons.warning_rounded,
    ),
    _TransactionData(
      bookingRef: 'EV-08241',
      date: 'Yesterday, 8:45 PM',
      amount: 'LKR 2,500',
      status: 'SUCCESS',
      icon: Icons.check_circle_rounded,
    ),
  ];

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
          'Reports',
          style: TextStyle(
            color: _textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Event Filter ────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Filter by Event',
                      style: TextStyle(
                        color: _textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Show event filter dropdown
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _bgCard,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              _selectedEvent,
                              style: const TextStyle(
                                color: _textPrimary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.expand_more_rounded,
                              color: _textSecondary,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ── Key Metrics ─────────────────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: _MetricCard(
                        icon: Icons.local_activity_rounded,
                        label: 'Tickets Sold',
                        value: '2,480',
                        trend: '+25%',
                        isPositive: true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _MetricCard(
                        icon: Icons.payments_rounded,
                        label: 'Total Revenue',
                        value: 'LKR 4.2M',
                        trend: '+18%',
                        isPositive: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: _MetricCard(
                        icon: Icons.people_rounded,
                        label: 'Attendance Rate',
                        value: '88.5%',
                        trend: '+8%',
                        isPositive: true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _MetricCard(
                        icon: Icons.cancel_rounded,
                        label: 'Cancellation Rate',
                        value: '1.4%',
                        trend: '2%',
                        isPositive: false,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // ── Revenue Trend ───────────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _bgCard,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Revenue Trend',
                            style: TextStyle(
                              color: _textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'Last 7 Days',
                            style: TextStyle(
                              color: _textSecondary,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Simple bar chart placeholder
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _ChartBar(height: 0.4, label: 'M'),
                          _ChartBar(height: 0.6, label: 'T'),
                          _ChartBar(height: 0.5, label: 'W'),
                          _ChartBar(height: 0.75, label: 'T'),
                          _ChartBar(height: 0.9, label: 'F'),
                          _ChartBar(height: 0.7, label: 'S'),
                          _ChartBar(height: 0.8, label: 'S'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ── Top Performing Events ───────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Top Performing Events',
                      style: TextStyle(
                        color: _textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // View all
                      },
                      child: Text(
                        'View All',
                        style: TextStyle(
                          color: _purple,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Column(
                  children: List.generate(
                    _topEvents.length,
                    (index) => Padding(
                      padding: EdgeInsets.only(
                        bottom: index < _topEvents.length - 1 ? 12 : 0,
                      ),
                      child: _TopEventCard(event: _topEvents[index]),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // ── Zone Distribution ───────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _bgCard,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Zone Distribution',
                        style: TextStyle(
                          color: _textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: SizedBox(
                          width: 140,
                          height: 140,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: SweepGradient(
                                    colors: [
                                      _purple,
                                      _gradEnd,
                                      _accentGreen,
                                      _purple,
                                    ],
                                    stops: const [0.0, 0.33, 0.66, 1.0],
                                  ),
                                ),
                              ),
                              Container(
                                width: 110,
                                height: 110,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _bgCard,
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        '2.4k',
                                        style: TextStyle(
                                          color: _textPrimary,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      Text(
                                        'Tickets',
                                        style: TextStyle(
                                          color: _textSecondary,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _ZoneInfo(color: _purple, label: 'Zone A', percentage: '50%'),
                          _ZoneInfo(color: _gradEnd, label: 'Zone B', percentage: '30%'),
                          _ZoneInfo(color: _accentGreen, label: 'Zone C', percentage: '20%'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ── Recent Transactions ─────────────────────────────────
                const Text(
                  'Recent Transactions',
                  style: TextStyle(
                    color: _textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Column(
                  children: List.generate(
                    _transactions.length,
                    (index) => Padding(
                      padding: EdgeInsets.only(
                        bottom: index < _transactions.length - 1 ? 10 : 0,
                      ),
                      child: _TransactionCard(transaction: _transactions[index]),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Metric Card Widget ──────────────────────────────────────────────────────
class _MetricCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String trend;
  final bool isPositive;

  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.trend,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: _purple, size: 18),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isPositive
                      ? _accentGreen.withValues(alpha: 0.15)
                      : _accentRed.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  trend,
                  style: TextStyle(
                    color: isPositive ? _accentGreen : _accentRed,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              color: _textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
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

// ── Chart Bar Widget ────────────────────────────────────────────────────────
class _ChartBar extends StatelessWidget {
  final double height;
  final String label;

  const _ChartBar({required this.height, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 8,
          height: 60 * height,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [_gradStart, _gradEnd],
            ),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: _textSecondary,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ── Top Event Card Widget ───────────────────────────────────────────────────
class _TopEventCard extends StatefulWidget {
  final _EventReport event;

  const _TopEventCard({required this.event});

  @override
  State<_TopEventCard> createState() => _TopEventCardState();
}

class _TopEventCardState extends State<_TopEventCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _bgCard,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _hovered
                ? _purple.withValues(alpha: 0.3)
                : Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.event.name,
                    style: const TextStyle(
                      color: _textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Icon(
                  Icons.trending_up_rounded,
                  color: _accentGreen,
                  size: 16,
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: widget.event.progress,
                backgroundColor: Colors.white.withValues(alpha: 0.1),
                valueColor: const AlwaysStoppedAnimation<Color>(_gradEnd),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.event.revenue,
              style: const TextStyle(
                color: _accentGreen,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Zone Info Widget ────────────────────────────────────────────────────────
class _ZoneInfo extends StatelessWidget {
  final Color color;
  final String label;
  final String percentage;

  const _ZoneInfo({
    required this.color,
    required this.label,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: _textSecondary,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          percentage,
          style: const TextStyle(
            color: _textPrimary,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

// ── Transaction Card Widget ────────────────────────────────────────────────
class _TransactionCard extends StatelessWidget {
  final _TransactionData transaction;

  const _TransactionCard({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _bgCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        children: [
          Icon(
            transaction.icon,
            color: transaction.status == 'SUCCESS' ? _accentGreen : _accentRed,
            size: 18,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.bookingRef,
                  style: const TextStyle(
                    color: _textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  transaction.date,
                  style: TextStyle(
                    color: _textSecondary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                transaction.amount,
                style: const TextStyle(
                  color: _textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                transaction.status,
                style: TextStyle(
                  color: transaction.status == 'SUCCESS'
                      ? _accentGreen
                      : _accentRed,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Data Models ─────────────────────────────────────────────────────────────
class _EventReport {
  final String name;
  final String revenue;
  final double progress;

  _EventReport({
    required this.name,
    required this.revenue,
    required this.progress,
  });
}

class _TransactionData {
  final String bookingRef;
  final String date;
  final String amount;
  final String status;
  final IconData icon;

  _TransactionData({
    required this.bookingRef,
    required this.date,
    required this.amount,
    required this.status,
    required this.icon,
  });
}
