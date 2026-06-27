import 'package:flutter/material.dart';

// ─── Color tokens ──────────────────────────────────────────────────────────
const _bgDeep = Color(0xFF0D0B1E);
const _bgCard = Color(0xFF151228);
const _purple = Color(0xFF7B5CF6);
const _purpleLight = Color(0xFF9B8AFB);
const _textPrimary = Color(0xFFFFFFFF);
const _textSecondary = Color(0xFFB0A8D0);
const _accentGreen = Color(0xFF4ECB71);
const _accentRed = Color(0xFFFF6B6B);
const _accentOrange = Color(0xFFFFA500);

class OrganizerApplicationsPage extends StatefulWidget {
  const OrganizerApplicationsPage({super.key});

  @override
  State<OrganizerApplicationsPage> createState() =>
      _OrganizerApplicationsPageState();
}

class _OrganizerApplicationsPageState extends State<OrganizerApplicationsPage> {
  String _selectedFilter = 'All';
  final List<String> _filterOptions = ['All', 'Pending', 'Approved', 'Rejected'];

  final List<_ApplicationData> _applications = [
    _ApplicationData(
      id: '1',
      name: 'John Doe',
      avatar: 'JD',
      appliedDate: 'Oct 24, 2023',
      organization: 'Quantum Events',
      type: 'Corporation',
      description: 'Specializing in tech conferences and global summits with over 10 years of logistics...',
      email: 'quantum.events',
      status: 'PENDING',
      accountType: 'Organization Account',
    ),
    _ApplicationData(
      id: '2',
      name: 'Sarah Reed',
      avatar: 'SR',
      appliedDate: 'Oct 22, 2023',
      organization: 'Reed & Co',
      type: 'Individual Account',
      description: '',
      email: 'sarah.reed',
      status: 'APPROVED',
      accountType: 'Individual Account',
    ),
    _ApplicationData(
      id: '3',
      name: 'Ben Miller',
      avatar: 'BM',
      appliedDate: 'Oct 20, 2023',
      organization: 'Miller Fest',
      type: 'Agency Account',
      description: '',
      email: 'ben.miller',
      status: 'REJECTED',
      accountType: 'Agency Account',
    ),
  ];

  List<_ApplicationData> get _filteredApplications {
    if (_selectedFilter == 'All') {
      return _applications;
    }
    return _applications
        .where((a) => a.status == _selectedFilter.toUpperCase())
        .toList();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'PENDING':
        return _accentOrange;
      case 'APPROVED':
        return _accentGreen;
      case 'REJECTED':
        return _accentRed;
      default:
        return _textSecondary;
    }
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
        title: const Text(
          'Organizer Applications',
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
                // Open filter menu
              },
              child: Icon(
                Icons.tune_rounded,
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
              // ── Stats Cards ─────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        count: '12',
                        label: 'Pending',
                        color: _accentOrange,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        count: '145',
                        label: 'Approved',
                        color: _accentGreen,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        count: '8',
                        label: 'Rejected',
                        color: _accentRed,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Filter Chips ────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
                          right: index < _filterOptions.length - 1 ? 8 : 0,
                        ),
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => _selectedFilter = option),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
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
                                option,
                                style: TextStyle(
                                  color: isSelected
                                      ? _textPrimary
                                      : _textSecondary,
                                  fontSize: 12,
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

              const SizedBox(height: 20),

              // ── Applications List ───────────────────────────────────────
              if (_filteredApplications.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.person_outline_rounded,
                          size: 48,
                          color: _textSecondary.withValues(alpha: 0.3),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No applications found',
                          style: TextStyle(
                            color: _textSecondary.withValues(alpha: 0.6),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: List.generate(
                      _filteredApplications.length,
                      (index) => Padding(
                        padding: EdgeInsets.only(
                          bottom: index < _filteredApplications.length - 1
                              ? 16
                              : 24,
                        ),
                        child: _ApplicationCard(
                          application: _filteredApplications[index],
                          statusColor: _getStatusColor(
                            _filteredApplications[index].status,
                          ),
                          onApprove: () {
                            // Approve application
                          },
                          onReject: () {
                            // Reject application
                          },
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Data Model ──────────────────────────────────────────────────────────────
class _ApplicationData {
  final String id;
  final String name;
  final String avatar;
  final String appliedDate;
  final String organization;
  final String type;
  final String description;
  final String email;
  final String status;
  final String accountType;

  _ApplicationData({
    required this.id,
    required this.name,
    required this.avatar,
    required this.appliedDate,
    required this.organization,
    required this.type,
    required this.description,
    required this.email,
    required this.status,
    required this.accountType,
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

// ── Application Card Widget ────────────────────────────────────────────────
class _ApplicationCard extends StatefulWidget {
  final _ApplicationData application;
  final Color statusColor;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const _ApplicationCard({
    required this.application,
    required this.statusColor,
    required this.onApprove,
    required this.onReject,
  });

  @override
  State<_ApplicationCard> createState() => _ApplicationCardState();
}

class _ApplicationCardState extends State<_ApplicationCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Container(
        padding: const EdgeInsets.all(16),
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
            // Header with avatar, name, and status
            Row(
              children: [
                // Avatar
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7B5CF6), Color(0xFFE07BB0)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      widget.application.avatar,
                      style: const TextStyle(
                        color: _textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.application.name,
                        style: const TextStyle(
                          color: _textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Applied ${widget.application.appliedDate}',
                        style: TextStyle(
                          color: _textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: widget.statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: widget.statusColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    widget.application.status,
                    style: TextStyle(
                      color: widget.statusColor,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Organization info
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ORGANIZATION',
                  style: TextStyle(
                    color: _textSecondary,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.application.organization,
                  style: const TextStyle(
                    color: _textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Type and description
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TYPE',
                        style: TextStyle(
                          color: _textSecondary,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.application.type,
                        style: const TextStyle(
                          color: _textPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            if (widget.application.description.isNotEmpty) ...[
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DESCRIPTION',
                    style: TextStyle(
                      color: _textSecondary,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.application.description,
                    style: TextStyle(
                      color: _textSecondary.withValues(alpha: 0.8),
                      fontSize: 11,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],

            const SizedBox(height: 10),

            // Email
            Row(
              children: [
                Icon(
                  Icons.public_rounded,
                  color: _purple,
                  size: 14,
                ),
                const SizedBox(width: 6),
                Text(
                  widget.application.email,
                  style: const TextStyle(
                    color: _purple,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Action buttons (only show for pending applications)
            if (widget.application.status == 'PENDING') ...[
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: widget.onApprove,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: _accentGreen),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            'Approve',
                            style: TextStyle(
                              color: _accentGreen,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: widget.onReject,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: _accentRed),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            'Reject',
                            style: TextStyle(
                              color: _accentRed,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Center(
                child: GestureDetector(
                  onTap: () {
                    // View full details
                  },
                  child: Text(
                    'View Full Details',
                    style: TextStyle(
                      color: _textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ] else ...[
              // Status check/cross for approved/rejected
              Center(
                child: Icon(
                  widget.application.status == 'APPROVED'
                      ? Icons.check_circle_rounded
                      : Icons.cancel_rounded,
                  color: widget.statusColor,
                  size: 28,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
