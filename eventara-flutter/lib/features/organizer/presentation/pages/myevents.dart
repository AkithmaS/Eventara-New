import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:eventara/core/router/app_routes.dart';
import '../../data/models/organizer_event_model.dart';
import '../providers/organizer_event_notifier.dart';

// ─── Colour tokens ──────────────────────────────────────────────────────────
const _bgDeep = Color(0xFF0D0B1E);
const _bgCard = Color(0xFF151228);
const _purple = Color(0xFF7B5CF6);
const _purpleLight = Color(0xFF9B8AFB);
const _gradStart = Color(0xFF7B5CF6);
const _gradEnd = Color(0xFFE07BB0);
const _textPrimary = Color(0xFFFFFFFF);
const _textSecondary = Color(0xFFB0A8D0);
const _accentGreen = Color(0xFF4ECB71);
const _accentBlue = Color(0xFF4ECDC4);

Color _statusColor(String status) {
  switch (status.toUpperCase()) {
    case 'PUBLISHED':
    case 'APPROVED':
      return _accentGreen;
    case 'DRAFT':
      return _textSecondary;
    case 'SUBMITTED':
      return _accentBlue;
    case 'REJECTED':
    case 'CANCELLED':
      return Colors.red;
    default:
      return _textSecondary;
  }
}

class MyEventsPage extends ConsumerStatefulWidget {
  const MyEventsPage({super.key});

  @override
  ConsumerState<MyEventsPage> createState() => _MyEventsPageState();
}

class _MyEventsPageState extends ConsumerState<MyEventsPage> {
  String _selectedFilter = 'All';
  final List<String> _filterOptions = [
    'All', 'Draft', 'Submitted', 'Published', 'Rejected'
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => ref.read(organizerEventsProvider.notifier).loadMyEvents());
  }

  List<OrganizerEventModel> _filter(List<OrganizerEventModel> events) {
    if (_selectedFilter == 'All') return events;
    return events
        .where((e) => e.status.toUpperCase() == _selectedFilter.toUpperCase())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final eventsState = ref.watch(organizerEventsProvider);

    return Scaffold(
      backgroundColor: _bgDeep,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('My Events',
                      style: TextStyle(
                          color: _textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w800)),
                  GestureDetector(
                    onTap: () => context.go(AppRoutes.organizerCreateEvent),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [_gradStart, _gradEnd]),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(Icons.add_rounded,
                            color: _textPrimary, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // ── Filter Chips ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _filterOptions.length,
                  itemBuilder: (context, index) {
                    final option = _filterOptions[index];
                    final isSelected = _selectedFilter == option;
                    return Padding(
                      padding: EdgeInsets.only(
                          right: index < _filterOptions.length - 1 ? 8 : 0),
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedFilter = option),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? _purple : _bgCard,
                            borderRadius: BorderRadius.circular(20),
                            border: isSelected
                                ? null
                                : Border.all(
                                    color:
                                        Colors.white.withValues(alpha: 0.1)),
                          ),
                          child: Center(
                            child: Text(option,
                                style: TextStyle(
                                    color: isSelected
                                        ? _textPrimary
                                        : _textSecondary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Events Grid ──────────────────────────────────────────
            Expanded(
              child: _buildContent(eventsState),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _OrganizerBottomNav(selectedIndex: 1),
    );
  }

  Widget _buildContent(OrganizerEventsState state) {
    if (state is OrganizerEventsLoading || state is OrganizerEventsInitial) {
      return const Center(child: CircularProgressIndicator(color: _purple));
    }

    if (state is OrganizerEventsError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(state.message,
                style:
                    const TextStyle(color: _textSecondary, fontSize: 13)),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () =>
                  ref.read(organizerEventsProvider.notifier).loadMyEvents(),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [_gradStart, _gradEnd]),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('Retry',
                    style: TextStyle(
                        color: _textPrimary, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      );
    }

    final events = state is OrganizerEventsLoaded
        ? _filter(state.events)
        : <OrganizerEventModel>[];

    if (events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_outlined,
                size: 60, color: _textSecondary.withValues(alpha: 0.3)),
            const SizedBox(height: 12),
            Text('No events found',
                style: TextStyle(
                    color: _textSecondary.withValues(alpha: 0.6),
                    fontSize: 14)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: _purple,
      onRefresh: () =>
          ref.read(organizerEventsProvider.notifier).loadMyEvents(),
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: 0.65,
        ),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          final canCancel = _canCancel(event);
          return _EventCard(
            event: event,
            statusColor: _statusColor(event.status),
            onEdit: () => context
                .go(AppRoutes.buildOrganizerEditEvent(event.id.toString())),
            onSubmit: event.status == 'DRAFT'
                ? () => _submitEvent(event.id)
                : null,
            onCancel: canCancel ? () => _cancelEvent(event.id) : null,
          );
        },
      ),
    );
  }

  Future<void> _submitEvent(int id) async {
    final ok =
        await ref.read(organizerEventsProvider.notifier).submitEvent(id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(ok ? 'Event submitted for review' : 'Failed to submit')));
    }
  }

  Future<void> _cancelEvent(int id) async {
    final ok =
        await ref.read(organizerEventsProvider.notifier).cancelEvent(id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(ok ? 'Event cancelled' : 'Failed to cancel')));
    }
  }

  /// Cancel is allowed for SUBMITTED or PUBLISHED events where
  /// the event date is still more than 3 days away.
  bool _canCancel(OrganizerEventModel event) {
    final status = event.status.toUpperCase();
    if (status != 'SUBMITTED' && status != 'PUBLISHED') return false;
    if (event.eventDate == null) return true; // no date set, allow
    try {
      final eventDt = DateTime.parse(event.eventDate!);
      final daysUntil = eventDt.difference(DateTime.now()).inDays;
      return daysUntil > 3;
    } catch (_) {
      return true;
    }
  }
}

// ── Event Card widget ────────────────────────────────────────────────────────
class _EventCard extends StatefulWidget {
  final OrganizerEventModel event;
  final Color statusColor;
  final VoidCallback onEdit;
  final VoidCallback? onSubmit;
  final VoidCallback? onCancel;

  const _EventCard({
    required this.event,
    required this.statusColor,
    required this.onEdit,
    this.onSubmit,
    this.onCancel,
  });

  @override
  State<_EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<_EventCard> {
  bool _hovered = false;

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final dt = DateTime.parse(dateStr);
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final event = widget.event;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: GestureDetector(
          onTap: (event.status == 'PUBLISHED' || event.status == 'REJECTED' || event.status == 'CANCELLED')
              ? null
              : widget.onEdit,
          child: Container(
            decoration: BoxDecoration(
              color: _bgCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _hovered
                    ? _purple.withValues(alpha: 0.3)
                    : Colors.white.withValues(alpha: 0.08),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(14),
                    topRight: Radius.circular(14),
                  ),
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        _purple.withValues(alpha: 0.2),
                        _gradEnd.withValues(alpha: 0.1),
                      ]),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Icon(Icons.event_rounded,
                              size: 48,
                              color: _purple.withValues(alpha: 0.2)),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: widget.statusColor.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                  color: widget.statusColor
                                      .withValues(alpha: 0.4)),
                            ),
                            child: Text(event.status,
                                style: TextStyle(
                                    color: widget.statusColor,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Details
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(event.title,
                          style: const TextStyle(
                              color: _textPrimary,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              height: 1.2),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.calendar_today_rounded,
                              color: _textSecondary.withValues(alpha: 0.6),
                              size: 9),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(_formatDate(event.eventDate),
                                style: TextStyle(
                                    color: _textSecondary.withValues(alpha: 0.7),
                                    fontSize: 9),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(Icons.location_on_rounded,
                              color: _textSecondary.withValues(alpha: 0.6),
                              size: 9),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(event.venueName ?? '',
                                style: TextStyle(
                                    color: _textSecondary.withValues(alpha: 0.7),
                                    fontSize: 9),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Action buttons
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 8),
                  child: Row(
                    children: [
                      if (event.status == 'DRAFT' || event.status == 'SUBMITTED') ...[
                        // Edit is available for DRAFT and SUBMITTED only
                        Expanded(
                          child: _ActionBtn(
                            icon: Icons.edit_rounded,
                            label: 'Edit',
                            onTap: widget.onEdit,
                          ),
                        ),
                        if (event.status == 'DRAFT') ...[
                          const SizedBox(width: 6),
                          Expanded(
                            child: _ActionBtn(
                              icon: Icons.send_rounded,
                              label: 'Submit',
                              onTap: widget.onSubmit ?? () {},
                            ),
                          ),
                        ] else if (widget.onCancel != null) ...[
                          // SUBMITTED + within cancellation window
                          const SizedBox(width: 6),
                          Expanded(
                            child: _ActionBtn(
                              icon: Icons.cancel_rounded,
                              label: 'Cancel',
                              onTap: widget.onCancel!,
                            ),
                          ),
                        ],
                      ] else if (event.status == 'PUBLISHED' && widget.onCancel != null) ...[
                        // PUBLISHED + within cancellation window: Cancel only
                        Expanded(
                          child: _ActionBtn(
                            icon: Icons.cancel_rounded,
                            label: 'Cancel',
                            onTap: widget.onCancel!,
                          ),
                        ),
                      ] else ...[
                        // PUBLISHED past window, REJECTED, CANCELLED, APPROVED: View only
                        Expanded(
                          child: _ActionBtn(
                            icon: Icons.visibility_rounded,
                            label: 'View',
                            onTap: widget.onEdit,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Action Button widget ─────────────────────────────────────────────────────
class _ActionBtn extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_ActionBtn> createState() => _ActionBtnState();
}

class _ActionBtnState extends State<_ActionBtn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: _hovered ? _bgCard.withValues(alpha: 0.8) : _bgCard,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: _hovered
                  ? _purple.withValues(alpha: 0.2)
                  : Colors.white.withValues(alpha: 0.05),
            ),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.icon,
                    color: _hovered ? _purpleLight : _textSecondary, size: 14),
                const SizedBox(width: 3),
                Text(widget.label,
                    style: TextStyle(
                        color: _hovered ? _purpleLight : _textSecondary,
                        fontSize: 10,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ),
    );
  }
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
        border:
            Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
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
                        color: isSel ? _purpleLight : _textSecondary,
                        size: 24),
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
