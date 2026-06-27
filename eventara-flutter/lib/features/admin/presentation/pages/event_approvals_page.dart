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
const _accentOrange = Color(0xFFF59E0B);
const _accentRed = Color(0xFFEF4444);
const _accentBlue = Color(0xFF3B82F6);

// ─── Data Models ──────────────────────────────────────────────────────────
class _EventData {
  final String id;
  final String name;
  final String organizerName;
  final String category;
  final String date;
  final String venue;
  final String ticketType;
  final String submittedDate;
  final String status;
  final String bannerImage;

  const _EventData({
    required this.id, required this.name, required this.organizerName,
    required this.category, required this.date, required this.venue,
    required this.ticketType, required this.submittedDate, required this.status,
    required this.bannerImage,
  });
}

class EventApprovalsPage extends StatefulWidget {
  final String? initialTabIndex;
  const EventApprovalsPage({super.key, this.initialTabIndex});

  @override
  State<EventApprovalsPage> createState() => _EventApprovalsPageState();
}

class _EventApprovalsPageState extends State<EventApprovalsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';

  final List<_EventData> _events = const [
    _EventData(
      id: '1', name: 'Global Tech Summit 2024', organizerName: 'David Ross',
      category: 'Technology', date: 'Jul 15, 2024', venue: 'BMICH', ticketType: 'SEATED',
      submittedDate: 'Jun 01, 2024', status: 'pending',
      bannerImage: 'https://via.placeholder.com/400x200?text=Tech+Summit',
    ),
    _EventData(
      id: '2', name: 'Jazz Night at Luna', organizerName: 'Marcus Chen',
      category: 'Music', date: 'Jun 28, 2024', venue: 'Luna Lounge', ticketType: 'GENERAL ADMISSION',
      submittedDate: 'Jun 05, 2024', status: 'approved',
      bannerImage: 'https://via.placeholder.com/400x200?text=Jazz+Night',
    ),
    _EventData(
      id: '3', name: 'Cricket Championship', organizerName: 'Lisa Wong',
      category: 'Sports', date: 'Aug 10, 2024', venue: 'R Premadasa Stadium', ticketType: 'SEATED',
      submittedDate: 'Jun 03, 2024', status: 'rejected',
      bannerImage: 'https://via.placeholder.com/400x200?text=Cricket',
    ),
    _EventData(
      id: '4', name: 'Startup Pitch Night', organizerName: 'Tom Brady',
      category: 'Technology', date: 'Jul 22, 2024', venue: 'Colombo City Center', ticketType: 'GENERAL ADMISSION',
      submittedDate: 'Jun 07, 2024', status: 'pending',
      bannerImage: 'https://via.placeholder.com/400x200?text=Startup+Night',
    ),
    _EventData(
      id: '5', name: 'Fashion Week 2024', organizerName: 'Priya Nair',
      category: 'Fashion', date: 'Jul 30, 2024', venue: 'Colombo Fashion Hub', ticketType: 'SEATED',
      submittedDate: 'Jun 08, 2024', status: 'approved',
      bannerImage: 'https://via.placeholder.com/400x200?text=Fashion+Week',
    ),
  ];

  @override
  void initState() {
    super.initState();
    int initialIndex = 0;
    if (widget.initialTabIndex == 'pending') {
      initialIndex = 0;
    } else if (widget.initialTabIndex == 'approved') {
      initialIndex = 1;
    } else if (widget.initialTabIndex == 'rejected') {
      initialIndex = 2;
    }
    _tabController = TabController(length: 3, vsync: this, initialIndex: initialIndex);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<_EventData> get _filteredEvents {
    final status = ['pending', 'approved', 'rejected'][_tabController.index];
    return _events.where((e) =>
      (e.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
       e.organizerName.toLowerCase().contains(_searchQuery.toLowerCase())) &&
      e.status == status).toList();
  }

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
        title: const Text('Event Approvals',
            style: TextStyle(color: _textPrimary, fontSize: 18, fontWeight: FontWeight.w800)),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              height: 40,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: _bgCard,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: TabBar(
                controller: _tabController,
                onTap: (_) => setState(() {}),
                indicator: BoxDecoration(
                  gradient: const LinearGradient(colors: [_gradStart, _gradEnd]),
                  borderRadius: BorderRadius.circular(18),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: _textPrimary,
                unselectedLabelColor: _textSecondary,
                labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                tabs: const [
                  Tab(text: 'Pending'),
                  Tab(text: 'Approved'),
                  Tab(text: 'Rejected'),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // ── Search Bar ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Container(
              decoration: BoxDecoration(
                color: _bgCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: TextField(
                onChanged: (v) => setState(() => _searchQuery = v),
                style: const TextStyle(color: _textPrimary, fontSize: 13),
                decoration: const InputDecoration(
                  hintText: 'Search by event name or organizer',
                  hintStyle: TextStyle(color: _textSecondary, fontSize: 13),
                  prefixIcon: Icon(Icons.search_rounded, color: _textSecondary, size: 18),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
                cursorColor: _purple,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // ── Events List ───────────────────────────────────────────────
          Expanded(
            child: _buildEventsList(),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildEventsList() {
    final list = _filteredEvents;
    if (list.isEmpty) return _buildEmpty('No events found');
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      itemCount: list.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) => _EventCard(
        event: list[i],
        onTap: () => context.go(AppRoutes.buildAdminEventDetail(list[i].id)),
        onApprove: _tabController.index == 0 ? () => _showApproveDialog(context, list[i].name) : null,
        onReject: _tabController.index == 0 ? () => _showRejectSheet(context, list[i].name) : null,
        onViewRejectionNotes: _tabController.index == 2 ? () => _showRejectionNotesDialog(context) : null,
      ),
    );
  }

  Widget _buildEmpty(String msg) => Center(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.event_rounded, size: 48, color: _textSecondary.withValues(alpha: 0.3)),
      const SizedBox(height: 12),
      Text(msg, style: TextStyle(color: _textSecondary.withValues(alpha: 0.6), fontSize: 14)),
    ]),
  );

  void _showApproveDialog(BuildContext context, String eventName) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: _bgCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Approve Event',
            style: TextStyle(color: _textPrimary, fontWeight: FontWeight.w800)),
        content: Text('Are you sure you want to approve "$eventName"?'
            ' It will be visible to all customers immediately.',
            style: const TextStyle(color: _textSecondary, fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: _textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Approve',
                style: TextStyle(color: _accentGreen, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _showRejectSheet(BuildContext context, String eventName) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _bgCard,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _RejectBottomSheet(eventName: eventName),
    );
  }

  void _showRejectionNotesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: _bgCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Rejection Notes',
            style: TextStyle(color: _textPrimary, fontWeight: FontWeight.w800)),
        content: Text('Event violates our community guidelines regarding violence.'
            ' Please revise and resubmit for review.',
            style: const TextStyle(color: _textSecondary, fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: _purple)),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
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
            children: [
              _NavItem(icon: Icons.dashboard_rounded, label: 'Dashboard',
                  onTap: () => context.go(AppRoutes.adminDashboard)),
              _NavItem(icon: Icons.people_rounded, label: 'Users',
                  onTap: () => context.go(AppRoutes.adminUsers)),
              _NavItem(icon: Icons.event_rounded, label: 'Events', isActive: true, onTap: () {}),
              _NavItem(icon: Icons.settings_rounded, label: 'Settings',
                  onTap: () => context.go(AppRoutes.adminSettings)),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Event Card ──────────────────────────────────────────────────────────────
class _EventCard extends StatelessWidget {
  final _EventData event;
  final VoidCallback onTap;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;
  final VoidCallback? onViewRejectionNotes;

  const _EventCard({
    required this.event, required this.onTap, this.onApprove, this.onReject,
    this.onViewRejectionNotes,
  });

  Color get _statusColor {
    switch (event.status) {
      case 'pending': return _accentOrange;
      case 'approved': return _accentGreen;
      default: return _accentRed;
    }
  }

  String get _statusLabel => event.status.toUpperCase();

  Color get _categoryColor {
    switch (event.category) {
      case 'Music': return Colors.red;
      case 'Sports': return Colors.blue;
      case 'Technology': return Colors.purple;
      case 'Fashion': return Colors.pink;
      default: return _purple;
    }
  }

  Color get _ticketColor => event.ticketType == 'SEATED' ? _purple : _accentBlue;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: _bgCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
              child: Container(
                width: double.infinity,
                height: 140,
                color: _purple.withValues(alpha: 0.1),
                child: Image.network(
                  event.bannerImage,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Center(
                    child: Icon(Icons.image_rounded, color: _textSecondary, size: 40),
                  ),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event name
                  Text(event.name,
                      style: const TextStyle(color: _textPrimary, fontSize: 14, fontWeight: FontWeight.w700),
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  // Organizer
                  Row(
                    children: [
                      const Icon(Icons.person_rounded, color: _textSecondary, size: 14),
                      const SizedBox(width: 6),
                      Text(event.organizerName,
                          style: TextStyle(color: _textSecondary.withValues(alpha: 0.8), fontSize: 11)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Category & Ticket type badges
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _categoryColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: _categoryColor.withValues(alpha: 0.3)),
                        ),
                        child: Text(event.category,
                            style: TextStyle(color: _categoryColor, fontSize: 9, fontWeight: FontWeight.w600)),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _ticketColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: _ticketColor.withValues(alpha: 0.3)),
                        ),
                        child: Text(event.ticketType,
                            style: TextStyle(color: _ticketColor, fontSize: 9, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Date & Venue
                  Row(
                    children: [
                      Icon(Icons.calendar_today_rounded, color: _textSecondary, size: 12),
                      const SizedBox(width: 4),
                      Text(event.date, style: TextStyle(color: _textSecondary, fontSize: 10)),
                      const SizedBox(width: 12),
                      Icon(Icons.location_on_rounded, color: _textSecondary, size: 12),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(event.venue, style: TextStyle(color: _textSecondary, fontSize: 10),
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Submitted date & Status badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Submitted: ${event.submittedDate}',
                          style: TextStyle(color: _textSecondary.withValues(alpha: 0.5), fontSize: 9)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _statusColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: _statusColor.withValues(alpha: 0.3)),
                        ),
                        child: Text(_statusLabel,
                            style: TextStyle(color: _statusColor, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.3)),
                      ),
                    ],
                  ),
                  // Action buttons
                  if (onApprove != null && onReject != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: onApprove,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: _accentGreen.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: _accentGreen.withValues(alpha: 0.3)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.check_rounded, color: _accentGreen, size: 12),
                                  const SizedBox(width: 4),
                                  const Text('Approve',
                                      style: TextStyle(color: _accentGreen, fontSize: 11, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: GestureDetector(
                            onTap: onReject,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: _accentRed.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: _accentRed.withValues(alpha: 0.3)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.close_rounded, color: _accentRed, size: 12),
                                  const SizedBox(width: 4),
                                  const Text('Reject',
                                      style: TextStyle(color: _accentRed, fontSize: 11, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ] else if (onViewRejectionNotes != null) ...[
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: onViewRejectionNotes,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: _accentRed.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: _accentRed.withValues(alpha: 0.3)),
                        ),
                        child: Center(
                          child: Text('View Rejection Notes',
                              style: TextStyle(color: _accentRed, fontSize: 11, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                  ] else ...[
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: onTap,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: _purple.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: _purple.withValues(alpha: 0.3)),
                        ),
                        child: const Center(
                          child: Text('View Details',
                              style: TextStyle(color: _purpleLight, fontSize: 11, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Reject Bottom Sheet ─────────────────────────────────────────────────────
class _RejectBottomSheet extends StatefulWidget {
  final String eventName;
  const _RejectBottomSheet({required this.eventName});

  @override
  State<_RejectBottomSheet> createState() => _RejectBottomSheetState();
}

class _RejectBottomSheetState extends State<_RejectBottomSheet> {
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Reject Event',
                  style: TextStyle(color: _textPrimary, fontSize: 16, fontWeight: FontWeight.w800)),
              const SizedBox(height: 16),
              TextField(
                controller: _notesController,
                maxLines: 5,
                style: const TextStyle(color: _textPrimary, fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Explain why this event is being rejected. The organizer will see this and can edit and resubmit.',
                  hintStyle: TextStyle(color: _textSecondary.withValues(alpha: 0.6), fontSize: 13),
                  filled: true,
                  fillColor: _bgCard,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: _purple),
                  ),
                ),
                cursorColor: _purple,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _bgCard,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                        ),
                        child: const Center(
                          child: Text('Cancel',
                              style: TextStyle(color: _textSecondary, fontSize: 13, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: _notesController.text.isEmpty ? null : () {
                        // Submit rejection
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          gradient: _notesController.text.isEmpty
                              ? null
                              : const LinearGradient(colors: [_gradStart, _gradEnd]),
                          color: _notesController.text.isEmpty
                              ? _bgCard.withValues(alpha: 0.5)
                              : null,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text('Submit Rejection',
                              style: TextStyle(
                                color: _notesController.text.isEmpty ? _textSecondary : _textPrimary,
                                fontSize: 13, fontWeight: FontWeight.w600,
                              )),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Bottom Nav Item ────────────────────────────────────────────────────────
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isActive;

  const _NavItem({required this.icon, required this.label, required this.onTap, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon, color: isActive ? _purpleLight : _textSecondary, size: 24),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(
          color: isActive ? _purpleLight : _textSecondary,
          fontSize: 11, fontWeight: FontWeight.w600,
        )),
      ]),
    );
  }
}
