import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:eventara/core/router/app_routes.dart';
import '../../../auth/presentation/providers/auth_notifier.dart';
import '../providers/organizer_event_notifier.dart';

// ─── Color tokens ──────────────────────────────────────────────────────────
const _bgDeep = Color(0xFF0D0B1E);
const _bgCard = Color(0xFF151228);
const _purple = Color(0xFF7B5CF6);
const _purpleLight = Color(0xFF9B8AFB);
const _gradStart = Color(0xFF7B5CF6);
const _gradEnd = Color(0xFFE07BB0);
const _textPrimary = Color(0xFFFFFFFF);
const _textSecondary = Color(0xFFB0A8D0);
const _accentRed = Color(0xFFFF6B6B);

class OrganizerProfilePage extends ConsumerStatefulWidget {
  const OrganizerProfilePage({super.key});

  @override
  ConsumerState<OrganizerProfilePage> createState() =>
      _OrganizerProfilePageState();
}

class _OrganizerProfilePageState extends ConsumerState<OrganizerProfilePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => ref.read(organizerProfileProvider.notifier).loadProfile());
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(organizerProfileProvider);

    return Scaffold(
      backgroundColor: _bgDeep,
      appBar: AppBar(
        backgroundColor: _bgDeep,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_rounded, color: _textPrimary),
        ),
        title: const Text('Profile',
            style: TextStyle(color: _textPrimary, fontSize: 18, fontWeight: FontWeight.w800)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: profileState is OrganizerProfileLoading || profileState is OrganizerProfileInitial
            ? const Center(child: CircularProgressIndicator(color: _purple))
            : _buildBody(profileState),
      ),
      bottomNavigationBar: _OrganizerBottomNav(selectedIndex: 3),
    );
  }

  Widget _buildBody(dynamic state) {
    final profile =
        state is OrganizerProfileLoaded ? state.profile : null;

    final name = profile?.fullName ?? 'Organizer';
    final company = profile?.organizationName ?? '';
    final email = profile?.email ?? '';
    final phone = profile?.phoneNumber ?? '';
    final website = profile?.websiteUrl ?? '';
    final description = profile?.description ?? '';
    final status = profile?.status ?? 'APPROVED';

    return RefreshIndicator(
      color: _purple,
      onRefresh: () =>
          ref.read(organizerProfileProvider.notifier).loadProfile(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            // ── Profile Header ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: _gradEnd, width: 3),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [_gradStart, _gradEnd],
                      ),
                    ),
                    child: const Center(
                      child: Icon(Icons.person_rounded,
                          color: _textPrimary, size: 48),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(name,
                      style: const TextStyle(
                          color: _textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  if (company.isNotEmpty)
                    Text(company,
                        style: TextStyle(
                            color: _textSecondary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: _purple.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _purple.withValues(alpha: 0.4)),
                    ),
                    child: Text(status,
                        style: TextStyle(
                            color: _purpleLight,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5)),
                  ),
                ],
              ),
            ),

            // ── Organization Info ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ORGANIZATION INFO',
                      style: TextStyle(
                          color: _textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _bgCard,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                    ),
                    child: Column(
                      children: [
                        _InfoRow(icon: Icons.email_rounded, label: 'Email', value: email),
                        if (phone.isNotEmpty) ...[
                          const Divider(color: Colors.white12, height: 20),
                          _InfoRow(icon: Icons.phone_rounded, label: 'Phone', value: phone),
                        ],
                        if (company.isNotEmpty) ...[
                          const Divider(color: Colors.white12, height: 20),
                          _InfoRow(icon: Icons.business_rounded, label: 'Organisation', value: company),
                        ],
                        if (website.isNotEmpty) ...[
                          const Divider(color: Colors.white12, height: 20),
                          _InfoRow(icon: Icons.language_rounded, label: 'Website', value: website),
                        ],
                        if (description.isNotEmpty) ...[
                          const Divider(color: Colors.white12, height: 20),
                          _InfoRow(icon: Icons.description_rounded, label: 'About', value: description),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Account Management ─────────────────────────────────────
            _MenuSection(
              title: 'ACCOUNT MANAGEMENT',
              items: [
                _MenuItem(icon: Icons.event_note_rounded, label: 'My Events', onTap: () => context.go(AppRoutes.organizerMyEvents)),
                _MenuItem(icon: Icons.bar_chart_rounded, label: 'Reports & Analytics', onTap: () => context.go(AppRoutes.organizerReports)),
                _MenuItem(icon: Icons.receipt_long_rounded, label: 'Booking History', onTap: () => context.go(AppRoutes.organizerBookings)),
              ],
            ),

            const SizedBox(height: 24),

            // ── Logout Button ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GestureDetector(
                onTap: () async {
                  await ref.read(authNotifierProvider.notifier).logout();
                  if (context.mounted) context.go(AppRoutes.login);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: _bgCard,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _accentRed.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout_rounded, color: _accentRed, size: 18),
                      const SizedBox(width: 8),
                      Text('Log Out',
                          style: TextStyle(
                              color: _accentRed,
                              fontSize: 13,
                              fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ── Info Row ─────────────────────────────────────────────────────────────────
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: _purple, size: 18),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                      color: _textSecondary,
                      fontSize: 10,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(value,
                  style: const TextStyle(
                      color: _textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Menu Section ─────────────────────────────────────────────────────────────
class _MenuSection extends StatelessWidget {
  final String title;
  final List<_MenuItem> items;

  const _MenuSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  color: _textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5)),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: _bgCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Column(
              children: List.generate(items.length, (index) {
                return Column(
                  children: [
                    _MenuItemTile(item: items[index]),
                    if (index < items.length - 1)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Divider(
                            color: Colors.white.withValues(alpha: 0.05),
                            height: 1),
                      ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItemTile extends StatefulWidget {
  final _MenuItem item;
  const _MenuItemTile({required this.item});

  @override
  State<_MenuItemTile> createState() => _MenuItemTileState();
}

class _MenuItemTileState extends State<_MenuItemTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.item.onTap,
        child: Container(
          color: _hovered
              ? Colors.white.withValues(alpha: 0.02)
              : Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(widget.item.icon,
                  color: _hovered ? _purpleLight : _textSecondary, size: 18),
              const SizedBox(width: 12),
              Expanded(
                child: Text(widget.item.label,
                    style: TextStyle(
                        color: _hovered ? _textPrimary : _textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600)),
              ),
              Icon(Icons.chevron_right_rounded,
                  color: _hovered ? _purpleLight : _textSecondary, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  _MenuItem({required this.icon, required this.label, required this.onTap});
}

// ── Bottom Navigation Bar ────────────────────────────────────────────────────
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
                    Icon(item['icon'] as IconData,
                        color: isSel ? _purpleLight : _textSecondary, size: 24),
                    const SizedBox(height: 4),
                    Text(item['label'] as String,
                        style: TextStyle(
                            color: isSel ? _purpleLight : _textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w600)),
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
