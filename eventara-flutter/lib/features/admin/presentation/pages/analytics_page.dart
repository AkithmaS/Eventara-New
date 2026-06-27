import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:eventara/core/router/app_routes.dart';

// ─── Color tokens ──────────────────────────────────────────────────────────
const _bgDeep = Color(0xFF0D0B1E);
const _bgCard = Color(0xFF151228);
const _purple = Color(0xFF7B5CF6);
const _textPrimary = Color(0xFFFFFFFF);
const _textSecondary = Color(0xFFB0A8D0);
const _accentGreen = Color(0xFF4ECB71);

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  String _selectedPeriod = '7 Days';
  final List<String> _periods = ['7 Days', '30 Days', '3 Months', '1 Year'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgDeep,
      appBar: AppBar(
        backgroundColor: _bgDeep,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: const Icon(Icons.arrow_back_rounded, color: _textPrimary),
        ),
        title: const Text(
          'Analytics',
          style: TextStyle(
            color: _textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {},
              child: const Icon(
                Icons.download_rounded,
                color: _textSecondary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Period Filter ───────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _periods.length,
                    itemBuilder: (context, index) {
                      final period = _periods[index];
                      final isSelected = _selectedPeriod == period;
                      return Padding(
                        padding: EdgeInsets.only(
                          right: index < _periods.length - 1 ? 8 : 0,
                        ),
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => _selectedPeriod = period),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? const LinearGradient(
                                      colors: [
                                        Color(0xFF7B5CF6),
                                        Color(0xFFE07BB0),
                                      ],
                                    )
                                  : null,
                              color: isSelected ? null : _bgCard,
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
                                period,
                                style: TextStyle(
                                  color: isSelected
                                      ? _textPrimary
                                      : _textSecondary,
                                  fontSize: 11,
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

              // ── KPI Cards ───────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _KPICard(
                            label: 'Total Revenue',
                            value: 'LKR 4,288',
                            change: '+12.5%',
                            icon: Icons.trending_up_rounded,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _KPICard(
                            label: 'Total Bookings',
                            value: '8,420',
                            change: '+8.2%',
                            icon: Icons.shopping_bag_rounded,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _KPICard(
                            label: 'Avg Per Event',
                            value: '1,540',
                            change: '+3.1%',
                            icon: Icons.event_rounded,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _KPICard(
                            label: 'Seats Available',
                            value: '2,845',
                            change: '-5.2%',
                            icon: Icons.chair_rounded,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Revenue Over Time Chart ─────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
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
                      const Text(
                        'Revenue Over Time',
                        style: TextStyle(
                          color: _textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 120,
                        child: CustomPaint(
                          painter: _LineChartPainter(),
                          size: const Size(double.infinity, 120),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Jan',
                            style: TextStyle(
                              color: _textSecondary,
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            'Jun',
                            style: TextStyle(
                              color: _textSecondary,
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            'Dec',
                            style: TextStyle(
                              color: _textSecondary,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ── Bookings Over Time Chart ────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
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
                      const Text(
                        'Bookings Over Time',
                        style: TextStyle(
                          color: _textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 120,
                        child: CustomPaint(
                          painter: _BarChartPainter(),
                          size: const Size(double.infinity, 120),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Mon',
                            style: TextStyle(
                              color: _textSecondary,
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            'Wed',
                            style: TextStyle(
                              color: _textSecondary,
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            'Fri',
                            style: TextStyle(
                              color: _textSecondary,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ── Top Events ──────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Top Events',
                      style: TextStyle(
                        color: _textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _EventItem(
                      title: 'Summer Concert Series',
                      subtitle: 'by Double Sun',
                      bookings: '1,200',
                    ),
                    const SizedBox(height: 10),
                    _EventItem(
                      title: 'Tech Conference 2024',
                      subtitle: 'by Tech Events Pro',
                      bookings: '850',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Realistic Booked Rooms ─────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Realistic Booked Rooms',
                      style: TextStyle(
                        color: _textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _StatItem(
                      icon: Icons.location_on_rounded,
                      title: 'Grand Ballroom',
                      value: '4480',
                    ),
                    const SizedBox(height: 10),
                    _StatItem(
                      icon: Icons.location_on_rounded,
                      title: 'Madison Square',
                      value: '3920',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Artisan Fixed Types ─────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Artisan Fixed Types',
                      style: TextStyle(
                        color: _textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _StatItem(
                      icon: Icons.category_rounded,
                      title: 'Concert Events',
                      value: '2650',
                    ),
                    const SizedBox(height: 10),
                    _StatItem(
                      icon: Icons.category_rounded,
                      title: 'Festival Events',
                      value: '1890',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Top Organizers ──────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Top Organizers',
                      style: TextStyle(
                        color: _textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _OrganizerItem(
                      name: 'Quantum Productions',
                      revenue: 'LKR 6,650',
                    ),
                    const SizedBox(height: 10),
                    _OrganizerItem(
                      name: 'PinqPanda Inc.',
                      revenue: 'LKR 6,320',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── User Growth Chart ───────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
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
                      const Text(
                        'User Growth',
                        style: TextStyle(
                          color: _textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 100,
                        child: CustomPaint(
                          painter: _UserGrowthPainter(),
                          size: const Size(double.infinity, 100),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ── Category Breakdown ──────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
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
                      const Text(
                        'Category Breakdown',
                        style: TextStyle(
                          color: _textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 140,
                        child: CustomPaint(
                          painter: _PieChartPainter(),
                          size: const Size(double.infinity, 140),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _PieLegendItem(
                            color: const Color(0xFFE07BB0),
                            label: 'Tech (24%)',
                          ),
                          _PieLegendItem(
                            color: const Color(0xFF7B5CF6),
                            label: 'Music (35%)',
                          ),
                          _PieLegendItem(
                            color: const Color(0xFF4ECB71),
                            label: 'Arts (18%)',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
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
              children: [
                _BottomNavItem(
                  icon: Icons.dashboard_rounded,
                  label: 'Dashboard',
                  onTap: () => context.go(AppRoutes.adminDashboard),
                ),
                _BottomNavItem(
                  icon: Icons.people_rounded,
                  label: 'Users',
                  onTap: () => context.go(AppRoutes.adminUsers),
                ),
                _BottomNavItem(
                  icon: Icons.event_rounded,
                  label: 'Events',
                  onTap: () => context.go(AppRoutes.adminEvents),
                ),
                _BottomNavItem(
                  icon: Icons.settings_rounded,
                  label: 'Settings',
                  onTap: () => context.go(AppRoutes.adminSettings),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── KPI Card Widget ────────────────────────────────────────────────────────
class _KPICard extends StatelessWidget {
  final String label;
  final String value;
  final String change;
  final IconData icon;

  const _KPICard({
    required this.label,
    required this.value,
    required this.change,
    required this.icon,
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: _textSecondary,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Icon(icon, color: _purple, size: 16),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: _textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            change,
            style: TextStyle(
              color: change.startsWith('-') ? const Color(0xFFFF6B6B) : _accentGreen,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Line Chart Painter ─────────────────────────────────────────────────────
class _LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF7B5CF6)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF7B5CF6).withValues(alpha: 0.3),
          const Color(0xFF7B5CF6).withValues(alpha: 0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final points = [
      Offset(0, size.height * 0.6),
      Offset(size.width * 0.2, size.height * 0.5),
      Offset(size.width * 0.4, size.height * 0.45),
      Offset(size.width * 0.6, size.height * 0.3),
      Offset(size.width * 0.8, size.height * 0.2),
      Offset(size.width, size.height * 0.15),
    ];

    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    canvas.drawPath(path, paint);

    final fillPath = Path();
    fillPath.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      fillPath.lineTo(points[i].dx, points[i].dy);
    }
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, gradientPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Bar Chart Painter ──────────────────────────────────────────────────────
class _BarChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final barWidth = size.width / 10;
    final values = [0.4, 0.5, 0.6, 0.7, 0.85, 0.9, 0.75];

    for (int i = 0; i < values.length; i++) {
      final barHeight = values[i] * size.height;
      final x = (i + 1.5) * barWidth;
      final y = size.height - barHeight;

      final paint = Paint()
        ..color = i == 5
            ? const Color(0xFFE07BB0)
            : const Color(0xFF7B5CF6)
        ..style = PaintingStyle.fill;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, barWidth * 0.6, barHeight),
          const Radius.circular(4),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Bottom Nav Item Widget ─────────────────────────────────────────────────
class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: _textSecondary,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: _textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Event Item Widget ──────────────────────────────────────────────────────
class _EventItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String bookings;

  const _EventItem({
    required this.title,
    required this.subtitle,
    required this.bookings,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _bgCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _textPrimary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: _textSecondary,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
          Text(
            bookings,
            style: const TextStyle(
              color: _purple,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Stat Item Widget ───────────────────────────────────────────────────────
class _StatItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _StatItem({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _bgCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: _purple,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: _textPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              color: _accentGreen,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Organizer Item Widget ──────────────────────────────────────────────────
class _OrganizerItem extends StatelessWidget {
  final String name;
  final String revenue;

  const _OrganizerItem({
    required this.name,
    required this.revenue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _bgCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7B5CF6), Color(0xFFE07BB0)],
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: _textPrimary,
                  size: 16,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                name,
                style: const TextStyle(
                  color: _textPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Text(
            revenue,
            style: const TextStyle(
              color: _accentGreen,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ── User Growth Painter ────────────────────────────────────────────────────
class _UserGrowthPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF7B5CF6)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF7B5CF6).withValues(alpha: 0.2),
          const Color(0xFF7B5CF6).withValues(alpha: 0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final points = [
      Offset(0, size.height * 0.7),
      Offset(size.width * 0.15, size.height * 0.65),
      Offset(size.width * 0.3, size.height * 0.55),
      Offset(size.width * 0.45, size.height * 0.45),
      Offset(size.width * 0.6, size.height * 0.35),
      Offset(size.width * 0.75, size.height * 0.25),
      Offset(size.width, size.height * 0.15),
    ];

    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    canvas.drawPath(path, paint);

    final fillPath = Path();
    fillPath.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      fillPath.lineTo(points[i].dx, points[i].dy);
    }
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, gradientPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Pie Chart Painter ──────────────────────────────────────────────────────
class _PieChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = 50.0;

    // Tech - 24% (Pink)
    _drawPieSlice(
      canvas,
      centerX,
      centerY,
      radius,
      0,
      0.24 * 360,
      const Color(0xFFE07BB0),
    );

    // Music - 35% (Purple)
    _drawPieSlice(
      canvas,
      centerX,
      centerY,
      radius,
      0.24 * 360,
      (0.24 + 0.35) * 360,
      const Color(0xFF7B5CF6),
    );

    // Arts - 18% (Green)
    _drawPieSlice(
      canvas,
      centerX,
      centerY,
      radius,
      (0.24 + 0.35) * 360,
      (0.24 + 0.35 + 0.18) * 360,
      const Color(0xFF4ECB71),
    );

    // Others - 23% (Gray)
    _drawPieSlice(
      canvas,
      centerX,
      centerY,
      radius,
      (0.24 + 0.35 + 0.18) * 360,
      360,
      const Color(0xFF2A2842),
    );
  }

  void _drawPieSlice(
    Canvas canvas,
    double centerX,
    double centerY,
    double radius,
    double startAngle,
    double endAngle,
    Color color,
  ) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final startRad = startAngle * 3.14159265 / 180;
    final endRad = endAngle * 3.14159265 / 180;

    final path = Path();
    path.moveTo(centerX, centerY);
    path.arcTo(
      Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
      startRad,
      endRad - startRad,
      false,
    );
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Pie Legend Item Widget ─────────────────────────────────────────────────
class _PieLegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _PieLegendItem({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: _textSecondary,
            fontSize: 9,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
