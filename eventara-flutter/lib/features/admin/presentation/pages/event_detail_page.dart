import 'package:flutter/material.dart';

// ─── Color tokens ──────────────────────────────────────────────────────────
const _bgDeep = Color(0xFF0D0B1E);
const _bgCard = Color(0xFF151228);
const _purple = Color(0xFF7B5CF6);
const _gradStart = Color(0xFF7B5CF6);
const _gradEnd = Color(0xFFE07BB0);
const _textPrimary = Color(0xFFFFFFFF);
const _textSecondary = Color(0xFFB0A8D0);
const _accentGreen = Color(0xFF4ECB71);
const _accentOrange = Color(0xFFF59E0B);
const _accentRed = Color(0xFFEF4444);
const _accentBlue = Color(0xFF3B82F6);

// ─── Event Detail Data Model ───────────────────────────────────────────────
class _EventDetail {
  final String id;
  final String name;
  final String category;
  final String organizerName;
  final String organizationType;
  final String organizerEmail;
  final String submittedDate;
  final String status;
  final String date;
  final String time;
  final String venue;
  final String city;
  final String description;
  final String ticketType;
  final String bannerImage;
  final int maxCapacity;
  final double ticketPrice;
  final int zones;
  final int totalSeats;
  final int organizerEventsCount;
  final String organizerMemberSince;
  final String rejectionReason;

  const _EventDetail({
    required this.id, required this.name, required this.category,
    required this.organizerName, required this.organizationType,
    required this.organizerEmail, required this.submittedDate,
    required this.status, required this.date, required this.time,
    required this.venue, required this.city, required this.description,
    required this.ticketType, required this.bannerImage,
    required this.maxCapacity, required this.ticketPrice,
    required this.zones, required this.totalSeats,
    required this.organizerEventsCount, required this.organizerMemberSince,
    required this.rejectionReason,
  });
}

class AdminEventDetailPage extends StatefulWidget {
  final String eventId;
  const AdminEventDetailPage({super.key, required this.eventId});

  @override
  State<AdminEventDetailPage> createState() => _AdminEventDetailPageState();
}

class _AdminEventDetailPageState extends State<AdminEventDetailPage> {
  // Mock data for demo
  late final _EventDetail event;

  @override
  void initState() {
    super.initState();
    event = _EventDetail(
      id: widget.eventId,
      name: 'Global Tech Summit 2024',
      category: 'Technology',
      organizerName: 'David Ross',
      organizationType: 'Pro Productions',
      organizerEmail: 'org***@gmail.com',
      submittedDate: 'Jun 01, 2024',
      status: 'pending',
      date: 'Jul 15, 2024',
      time: '9:00 AM - 6:00 PM',
      venue: 'Colombo International Convention Center (BMICH)',
      city: 'Colombo',
      description: 'Join industry leaders and innovators at the Global Tech Summit 2024. '
          'This three-day conference features keynote speeches, technical workshops, '
          'networking sessions, and exhibition showcasing cutting-edge technologies.',
      ticketType: 'SEATED',
      bannerImage: 'https://via.placeholder.com/400x200?text=Tech+Summit',
      maxCapacity: 0,
      ticketPrice: 0,
      zones: 3,
      totalSeats: 500,
      organizerEventsCount: 12,
      organizerMemberSince: 'Feb 22, 2024',
      rejectionReason: '',
    );
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
        title: const Text('Event Details',
            style: TextStyle(color: _textPrimary, fontSize: 18, fontWeight: FontWeight.w800)),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: _statusColor.withValues(alpha: 0.3)),
                ),
                child: Text(event.status.toUpperCase(),
                    style: TextStyle(color: _statusColor, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.3)),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Banner Image ────────────────────────────────────────
            ClipRRect(
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
              child: Container(
                width: double.infinity,
                height: 200,
                color: _purple.withValues(alpha: 0.1),
                child: Stack(
                  children: [
                    Image.network(
                      event.bannerImage,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Center(
                        child: Icon(Icons.image_rounded, color: _textSecondary, size: 60),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, _bgDeep.withValues(alpha: 0.6)],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Basic Info ──────────────────────────────────────
                  Text(event.name,
                      style: const TextStyle(color: _textPrimary, fontSize: 20, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: _purple.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: _purple.withValues(alpha: 0.3)),
                        ),
                        child: const Text('Technology',
                            style: TextStyle(color: _purple, fontSize: 10, fontWeight: FontWeight.w600)),
                      ),
                      const SizedBox(width: 12),
                      Row(
                        children: [
                          const Icon(Icons.person_rounded, color: _textSecondary, size: 14),
                          const SizedBox(width: 4),
                          Text(event.organizerName,
                              style: const TextStyle(color: _textSecondary, fontSize: 11)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Submitted on ${event.submittedDate}',
                      style: TextStyle(color: _textSecondary.withValues(alpha: 0.6), fontSize: 10)),
                  const SizedBox(height: 20),

                  // ── Event Details Card ──────────────────────────────
                  _buildSectionCard(
                    title: 'Event Details',
                    child: Column(
                      children: [
                        _buildDetailRow('📅', 'Date & Time', '${event.date}, ${event.time}'),
                        Divider(color: Colors.white.withValues(alpha: 0.05), height: 16),
                        _buildDetailRow('📍', 'Venue', event.venue),
                        Divider(color: Colors.white.withValues(alpha: 0.05), height: 16),
                        _buildDetailRow('🏙️', 'City', event.city),
                        Divider(color: Colors.white.withValues(alpha: 0.05), height: 16),
                        _buildExpandableDescription(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Ticket Info Card ────────────────────────────────
                  _buildSectionCard(
                    title: 'Ticket Information',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (event.ticketType == 'SEATED') ...[
                          _buildDetailRow('🎟️', 'Type', event.ticketType),
                          Divider(color: Colors.white.withValues(alpha: 0.05), height: 16),
                          _buildDetailRow('🗺️', 'Zones', '${event.zones}'),
                          Divider(color: Colors.white.withValues(alpha: 0.05), height: 16),
                          _buildDetailRow('💺', 'Total Seats', '${event.totalSeats}'),
                          Divider(color: Colors.white.withValues(alpha: 0.05), height: 16),
                          const Text('Price per Zone', style: TextStyle(color: _textSecondary, fontSize: 11, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          _buildZonePrices(),
                        ] else ...[
                          _buildDetailRow('🎟️', 'Type', event.ticketType),
                          Divider(color: Colors.white.withValues(alpha: 0.05), height: 16),
                          _buildDetailRow('👥', 'Max Capacity', '${event.maxCapacity}'),
                          Divider(color: Colors.white.withValues(alpha: 0.05), height: 16),
                          _buildDetailRow('💰', 'Price per Ticket', 'LKR ${event.ticketPrice}'),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Seat Map Preview (only for SEATED) ───────────────
                  if (event.ticketType == 'SEATED')
                    _buildSectionCard(
                      title: 'Seat Map Preview',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSeatMapPreview(),
                          const SizedBox(height: 12),
                          GestureDetector(
                            onTap: () {},
                            child: const Text('View Full Seat Map →',
                                style: TextStyle(color: _purple, fontSize: 12, fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    ),
                  if (event.ticketType == 'SEATED') const SizedBox(height: 16),

                  // ── Organizer Info Card ─────────────────────────────
                  _buildSectionCard(
                    title: 'Organizer Information',
                    child: Column(
                      children: [
                        _buildDetailRow('👤', 'Name', event.organizerName),
                        Divider(color: Colors.white.withValues(alpha: 0.05), height: 16),
                        _buildDetailRow('🏢', 'Organization', event.organizationType),
                        Divider(color: Colors.white.withValues(alpha: 0.05), height: 16),
                        _buildDetailRow('✉️', 'Email', event.organizerEmail),
                        Divider(color: Colors.white.withValues(alpha: 0.05), height: 16),
                        _buildDetailRow('📊', 'Total Events', '${event.organizerEventsCount}'),
                        Divider(color: Colors.white.withValues(alpha: 0.05), height: 16),
                        _buildDetailRow('📅', 'Member Since', event.organizerMemberSince),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Rejection Notes (only if rejected) ───────────────
                  if (event.status == 'rejected')
                    _buildRejectionNotesCard(),
                  if (event.status == 'rejected') const SizedBox(height: 16),

                  // ── Admin Actions (only if pending) ──────────────────
                  if (event.status == 'pending')
                    _buildAdminActionsSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color get _statusColor {
    switch (event.status) {
      case 'pending': return _accentOrange;
      case 'approved': return _accentGreen;
      default: return _accentRed;
    }
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: _textPrimary, fontSize: 13, fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _bgCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: child,
        ),
      ],
    );
  }

  Widget _buildDetailRow(String icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(icon, style: const TextStyle(fontSize: 14)),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: _textSecondary, fontSize: 10, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(color: _textPrimary, fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExpandableDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('📝 Description', style: TextStyle(color: _textSecondary, fontSize: 10, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Text(event.description,
            style: const TextStyle(color: _textPrimary, fontSize: 12, height: 1.5),
            maxLines: 3, overflow: TextOverflow.ellipsis),
      ],
    );
  }

  Widget _buildZonePrices() {
    const zones = [
      ('Zone A', 'LKR 5,000'),
      ('Zone B', 'LKR 3,500'),
      ('Zone C', 'LKR 2,000'),
    ];
    return Column(
      children: zones.asMap().entries.map((e) {
        final (label, price) = e.value;
        return Padding(
          padding: EdgeInsets.only(bottom: e.key < zones.length - 1 ? 8 : 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(color: _textSecondary, fontSize: 11)),
              Text(price, style: const TextStyle(color: _textPrimary, fontSize: 11, fontWeight: FontWeight.w600)),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSeatMapPreview() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _bgDeep.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 100,
            child: GridView.count(
              crossAxisCount: 8,
              childAspectRatio: 1,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(24, (i) {
                final zone = i < 8 ? 'A' : i < 16 ? 'B' : 'C';
                final zoneColor = zone == 'A' ? _purple : zone == 'B' ? _accentBlue : _accentOrange;
                return Container(
                  decoration: BoxDecoration(
                    color: zoneColor.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: zoneColor.withValues(alpha: 0.5)),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildZoneLegend('Zone A', _purple),
              _buildZoneLegend('Zone B', _accentBlue),
              _buildZoneLegend('Zone C', _accentOrange),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildZoneLegend(String label, Color color) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(color: _textSecondary, fontSize: 9)),
      ],
    );
  }

  Widget _buildRejectionNotesCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _accentRed.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _accentRed.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Rejection Reason',
              style: TextStyle(color: _accentRed, fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          const Text('Event violates our community guidelines regarding violence.',
              style: TextStyle(color: _textPrimary, fontSize: 12, height: 1.5)),
          const SizedBox(height: 8),
          Text('Rejected on Dec 15, 2024',
              style: TextStyle(color: _textSecondary.withValues(alpha: 0.6), fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildAdminActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Admin Decision',
            style: TextStyle(color: _textPrimary, fontSize: 13, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () => _showApproveDialog(context),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFF4ECB71), Color(0xFF34D399)]),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: const Center(
              child: Text('✓ Approve Event',
                  style: TextStyle(color: _textPrimary, fontSize: 13, fontWeight: FontWeight.w700)),
            ),
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => _showRejectSheet(context),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: _accentRed.withValues(alpha: 0.08),
              border: Border.all(color: _accentRed.withValues(alpha: 0.3)),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            child: const Center(
              child: Text('✗ Reject Event',
                  style: TextStyle(color: _accentRed, fontSize: 13, fontWeight: FontWeight.w700)),
            ),
          ),
        ),
      ],
    );
  }

  void _showApproveDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: _bgCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Approve Event',
            style: TextStyle(color: _textPrimary, fontWeight: FontWeight.w800)),
        content: Text('Are you sure you want to approve "${event.name}"?'
            ' It will be visible to all customers immediately.',
            style: const TextStyle(color: _textSecondary, fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: _textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Confirm',
                style: TextStyle(color: _accentGreen, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _showRejectSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _bgCard,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const _RejectSheet(),
    );
  }
}

class _RejectSheet extends StatefulWidget {
  const _RejectSheet();

  @override
  State<_RejectSheet> createState() => _RejectSheetState();
}

class _RejectSheetState extends State<_RejectSheet> {
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
                onChanged: (_) => setState(() {}),
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
