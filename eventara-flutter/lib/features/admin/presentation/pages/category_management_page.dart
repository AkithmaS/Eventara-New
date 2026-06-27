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

class CategoryManagementPage extends StatefulWidget {
  const CategoryManagementPage({super.key});

  @override
  State<CategoryManagementPage> createState() =>
      _CategoryManagementPageState();
}

class _CategoryManagementPageState extends State<CategoryManagementPage> {
  final List<_CategoryData> _categories = [
    _CategoryData(
      id: '1',
      name: 'Music',
      icon: '🎵',
      eventCount: 124,
      isActive: true,
    ),
    _CategoryData(
      id: '2',
      name: 'Theater',
      icon: '🎭',
      eventCount: 42,
      isActive: true,
    ),
    _CategoryData(
      id: '3',
      name: 'Sports',
      icon: '🏈',
      eventCount: 89,
      isActive: true,
    ),
    _CategoryData(
      id: '4',
      name: 'Workshops',
      icon: '🎓',
      eventCount: 5,
      isActive: false,
    ),
    _CategoryData(
      id: '5',
      name: 'Charity',
      icon: '❤️',
      eventCount: 32,
      isActive: false,
    ),
  ];

  bool _showInactive = false;

  @override
  void initState() {
    super.initState();
  }

  void _toggleCategory(int index) {
    setState(() {
      final category = _categories[index];
      category.isActive = !category.isActive;
    });
  }

  @override
  Widget build(BuildContext context) {
    final activeCount = _categories.where((c) => c.isActive).length;
    final inactiveCount = _categories.where((c) => !c.isActive).length;

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
          'Event Categories',
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
              onTap: () {
                // Open add category dialog
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _purple.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: _purple,
                  size: 20,
                ),
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
              // ── Stats Row ───────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        count: activeCount.toString(),
                        label: 'Active',
                        color: _accentGreen,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        count: inactiveCount.toString(),
                        label: 'Inactive',
                        color: _accentRed,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        count: _categories.length.toString(),
                        label: 'Total',
                        color: _purpleLight,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Section Header: Active Categories ───────────────────────
              if (activeCount > 0)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ACTIVE CATEGORIES',
                        style: TextStyle(
                          color: _textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        activeCount.toString(),
                        style: TextStyle(
                          color: _accentGreen,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 12),

              // ── Active Categories List ─────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    for (int i = 0; i < _categories.length; i++)
                      if (_categories[i].isActive)
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: _categories[i].isActive &&
                                    i < _categories.length - 1 &&
                                    _categories[i + 1].isActive
                                ? 12
                                : 0,
                          ),
                          child: _CategoryCard(
                            category: _categories[i],
                            onToggle: () => _toggleCategory(i),
                            onEdit: () {
                              // Edit category
                            },
                          ),
                        ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Section Header: Inactive Categories ──────────────────────
              if (inactiveCount > 0) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GestureDetector(
                    onTap: () => setState(() => _showInactive = !_showInactive),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'INACTIVE CATEGORIES',
                              style: TextStyle(
                                color: _textSecondary,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              inactiveCount.toString(),
                              style: TextStyle(
                                color: _accentRed,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          _showInactive
                              ? Icons.expand_less_rounded
                              : Icons.expand_more_rounded,
                          color: _textSecondary,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // ── Inactive Categories List ──────────────────────────────
                if (_showInactive)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        for (int i = 0; i < _categories.length; i++)
                          if (!_categories[i].isActive)
                            Padding(
                              padding: EdgeInsets.only(
                                bottom: !_categories[i].isActive &&
                                        i < _categories.length - 1 &&
                                        !_categories[i + 1].isActive
                                    ? 12
                                    : 0,
                              ),
                              child: _CategoryCard(
                                category: _categories[i],
                                onToggle: () => _toggleCategory(i),
                                onEdit: () {
                                  // Edit category
                                },
                              ),
                            ),
                      ],
                    ),
                  ),
                const SizedBox(height: 24),
              ],
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

// ── Data Model ──────────────────────────────────────────────────────────────
class _CategoryData {
  final String id;
  final String name;
  final String icon;
  final int eventCount;
  bool isActive;

  _CategoryData({
    required this.id,
    required this.name,
    required this.icon,
    required this.eventCount,
    required this.isActive,
  });
}

// ── Stat Card Widget ────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String count;
  final String label;
  final Color color;

  const _StatCard({
    required this.count,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
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
          Text(
            count,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            label,
            style: TextStyle(
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

// ── Category Card Widget ────────────────────────────────────────────────────
class _CategoryCard extends StatefulWidget {
  final _CategoryData category;
  final VoidCallback onToggle;
  final VoidCallback onEdit;

  const _CategoryCard({
    required this.category,
    required this.onToggle,
    required this.onEdit,
  });

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _bgCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _hovered
                ? _purple.withValues(alpha: 0.3)
                : Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Row(
          children: [
            // ── Icon Container ────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _purple.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                widget.category.icon,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(width: 12),

            // ── Category Info ────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.category.name,
                    style: const TextStyle(
                      color: _textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '${widget.category.eventCount} Events',
                    style: TextStyle(
                      color: _textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // ── Edit Icon ──────────────────────────────────────────
            GestureDetector(
              onTap: widget.onEdit,
              child: Icon(
                Icons.edit_rounded,
                color: _textSecondary,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),

            // ── Toggle Switch ──────────────────────────────────────
            GestureDetector(
              onTap: widget.onToggle,
              child: Container(
                width: 44,
                height: 24,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: widget.category.isActive ? _accentGreen : _bgCard,
                  border: Border.all(
                    color: widget.category.isActive
                        ? _accentGreen
                        : Colors.white.withValues(alpha: 0.2),
                  ),
                ),
                child: Stack(
                  children: [
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 200),
                      left: widget.category.isActive ? 22 : 2,
                      top: 2,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Bottom Nav Item Widget ──────────────────────────────────────────────────
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
