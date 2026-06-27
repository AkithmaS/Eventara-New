import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:eventara/core/router/app_routes.dart';

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
const _accentOrange = Color(0xFFFFA500);
const _accentRed = Color(0xFFFF6B6B);

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int _selectedNav = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgDeep,
      appBar: AppBar(
        backgroundColor: _bgDeep,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: GestureDetector(
            onTap: () {
              // Open menu/drawer
            },
            child: Icon(
              Icons.admin_panel_settings_rounded,
              color: _purple,
              size: 24,
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Admin Panel',
              style: TextStyle(
                color: _textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              'System Overview',
              style: TextStyle(
                color: _textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                // Open notifications
              },
              child: Icon(
                Icons.notifications_none_rounded,
                color: _textSecondary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── KPI Cards Grid ──────────────────────────────────────
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  children: [
                    _KPICard(
                      icon: Icons.people_rounded,
                      label: 'Users',
                      value: '12,480',
                      trend: '+12%',
                      isPositive: true,
                    ),
                    _KPICard(
                      icon: Icons.event_rounded,
                      label: 'Events',
                      value: '842',
                      trend: '+5%',
                      isPositive: true,
                    ),
                    _KPICard(
                      icon: Icons.receipt_long_rounded,
                      label: 'Bookings',
                      value: '45.2k',
                      trend: '+18%',
                      isPositive: true,
                    ),
                    _KPICard(
                      icon: Icons.attach_money_rounded,
                      label: 'Revenue',
                      value: 'LKR 12.8M',
                      trend: '+24%',
                      isPositive: true,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // ── Alert Boxes ─────────────────────────────────────────
                _AlertBox(
                  icon: Icons.warning_rounded,
                  title: '3 Organizer Applications',
                  subtitle: 'Pending',
                  buttonLabel: 'Review',
                  onTap: () => context.go(AppRoutes.buildAdminUsersPending()),
                ),
                const SizedBox(height: 10),
                _AlertBox(
                  icon: Icons.event_note_rounded,
                  title: '5 Events Awaiting Approval',
                  subtitle: 'Pending',
                  buttonLabel: 'Review',
                  onTap: () => context.go(AppRoutes.buildAdminEventsPending()),
                ),
                const SizedBox(height: 24),

                // ── Recent Activity ─────────────────────────────────────
                const Text(
                  'Recent Activity',
                  style: TextStyle(
                    color: _textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _bgCard,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Column(
                    children: [
                      _ActivityItem(
                        icon: Icons.person_add_rounded,
                        title: 'New organizer applied',
                        time: '1 hour ago',
                      ),
                      Divider(
                        color: Colors.white.withValues(alpha: 0.05),
                        height: 16,
                      ),
                      _ActivityItem(
                        icon: Icons.event_rounded,
                        title: 'Global Tech Summit submitted',
                        time: '2 hours ago',
                      ),
                      Divider(
                        color: Colors.white.withValues(alpha: 0.05),
                        height: 16,
                      ),
                      _ActivityItem(
                        icon: Icons.check_circle_rounded,
                        title: 'Booking #EV-08240 confirmed',
                        time: '3 hours ago',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ── Quick Actions ───────────────────────────────────────
                const Text(
                  'Quick Actions',
                  style: TextStyle(
                    color: _textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.1,
                  children: [
                    _QuickActionCard(
                      icon: Icons.people_rounded,
                      label: 'Manage Users',
                      onTap: () => context.push(AppRoutes.adminUsers),
                    ),
                    _QuickActionCard(
                      icon: Icons.event_rounded,
                      label: 'Review Events',
                      onTap: () => context.push(AppRoutes.adminEvents),
                    ),
                    _QuickActionCard(
                      icon: Icons.category_rounded,
                      label: 'Categories',
                      onTap: () => context.push(AppRoutes.adminCategories),
                    ),
                    _QuickActionCard(
                      icon: Icons.bar_chart_rounded,
                      label: 'Analytics',
                      onTap: () => context.push(AppRoutes.adminAnalytics),
                    ),
                    _QuickActionCard(
                      icon: Icons.history_rounded,
                      label: 'Audit Log',
                      onTap: () => context.push(AppRoutes.adminAuditLog),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
              ],
            ),
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
                _SimpleNavItem(
                  icon: Icons.dashboard_rounded,
                  label: 'Dashboard',
                  isActive: _selectedNav == 0,
                  onTap: () {
                    setState(() => _selectedNav = 0);
                    context.go(AppRoutes.adminDashboard);
                  },
                ),
                _SimpleNavItem(
                  icon: Icons.people_rounded,
                  label: 'Users',
                  isActive: _selectedNav == 1,
                  onTap: () {
                    setState(() => _selectedNav = 1);
                    context.go(AppRoutes.adminUsers);
                  },
                ),
                _SimpleNavItem(
                  icon: Icons.event_rounded,
                  label: 'Events',
                  isActive: _selectedNav == 2,
                  onTap: () {
                    setState(() => _selectedNav = 2);
                    context.go(AppRoutes.adminEvents);
                  },
                ),
                _SimpleNavItem(
                  icon: Icons.settings_rounded,
                  label: 'Settings',
                  isActive: _selectedNav == 3,
                  onTap: () {
                    setState(() => _selectedNav = 3);
                    context.go(AppRoutes.adminSettings);
                  },
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
  final IconData icon;
  final String label;
  final String value;
  final String trend;
  final bool isPositive;

  const _KPICard({
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _purple.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: _purple, size: 16),
              ),
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
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Alert Box Widget ────────────────────────────────────────────────────────
class _AlertBox extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String buttonLabel;
  final VoidCallback onTap;

  const _AlertBox({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _accentOrange.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: _accentOrange, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: _textSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _accentOrange,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                buttonLabel,
                style: const TextStyle(
                  color: _textPrimary,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Activity Item Widget ────────────────────────────────────────────────────
class _ActivityItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String time;

  const _ActivityItem({
    required this.icon,
    required this.title,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _purple.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: _purple, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: _textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                time,
                style: TextStyle(
                  color: _textSecondary,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Quick Action Card Widget ───────────────────────────────────────────────
class _QuickActionCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_QuickActionCard> createState() => _QuickActionCardState();
}

class _QuickActionCardState extends State<_QuickActionCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: _hovered
                ? LinearGradient(
                    colors: [_gradStart.withValues(alpha: 0.3), _gradEnd.withValues(alpha: 0.3)],
                  )
                : null,
            color: _hovered ? null : _bgCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _hovered
                  ? _purple.withValues(alpha: 0.3)
                  : Colors.white.withValues(alpha: 0.08),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _purple.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.icon,
                  color: _purple,
                  size: 24,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: _textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// ── Simple NavBar Item Widget ──────────────────────────────────────────────
class _SimpleNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _SimpleNavItem({
    required this.icon,
    required this.label,
    required this.isActive,
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
            color: isActive ? _purpleLight : _textSecondary,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? _purpleLight : _textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
