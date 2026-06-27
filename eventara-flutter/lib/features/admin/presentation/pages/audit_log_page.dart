import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ─── Color tokens ──────────────────────────────────────────────────────────
const _bgDeep = Color(0xFF0D0B1E);
const _bgCard = Color(0xFF151228);
const _purple = Color(0xFF7B5CF6);
const _textPrimary = Color(0xFFFFFFFF);
const _textSecondary = Color(0xFFB0A8D0);
const _accentGreen = Color(0xFF4ECB71);
const _accentOrange = Color(0xFFF59E0B);
const _accentRed = Color(0xFFEF4444);
const _accentBlue = Color(0xFF3B82F6);

class AuditLogPage extends StatefulWidget {
  const AuditLogPage({super.key});

  @override
  State<AuditLogPage> createState() => _AuditLogPageState();
}

class _AuditLogPageState extends State<AuditLogPage> {
  String _selectedAction = 'All';
  final List<String> _actions = ['All', 'Approval', 'Override', 'Suspension', 'Config'];

  final List<Map<String, dynamic>> _auditLogs = [
    {
      'id': 1,
      'action': 'Organizer Account Approved',
      'type': 'approval',
      'actor': 'Admin: Elena Vance',
      'target': 'User: Marcus Chen',
      'timestamp': 'Oct 12, 10:45 AM',
      'description': 'Tier 2 organizer credentials verified through standard KYC protocol.',
      'details': {
        'reason': 'Compliance verified',
        'before': 'Pending',
        'after': 'Approved',
      },
    },
    {
      'id': 2,
      'action': 'System Override Triggered',
      'type': 'override',
      'actor': 'Admin: Sarah Connor',
      'target': 'Ticket #8812-X',
      'timestamp': 'Oct 12, 09:12 AM',
      'description': 'Manual ticket cancellation and refund processed.',
    },
    {
      'id': 3,
      'action': 'Account Suspension',
      'type': 'suspension',
      'actor': 'System: Auth-Guard',
      'target': 'User: bot_killer_99',
      'timestamp': 'Oct 11, 11:58 PM',
      'description': 'Suspicious activity detected - multiple failed login attempts.',
    },
    {
      'id': 4,
      'action': 'Global Config Updated',
      'type': 'config',
      'actor': 'Admin: Dev Ops',
      'target': 'System Settings',
      'timestamp': 'Oct 11, 04:30 PM',
      'description': 'Platform maintenance window extended by 2 hours.',
    },
    {
      'id': 5,
      'action': 'Organizer Account Approved',
      'type': 'approval',
      'actor': 'Admin: John Smith',
      'target': 'User: Jane Doe',
      'timestamp': 'Oct 10, 02:15 PM',
      'description': 'Premium organizer tier activated.',
    },
  ];

  Color _getActionColor(String type) {
    switch (type) {
      case 'approval':
        return _accentGreen;
      case 'override':
        return _accentOrange;
      case 'suspension':
        return _accentRed;
      case 'config':
        return _accentBlue;
      default:
        return _purple;
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
          onTap: () => context.pop(),
          child: const Icon(Icons.arrow_back_rounded, color: _textPrimary),
        ),
        title: const Text(
          'Audit Log',
          style: TextStyle(
            color: _textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                // Filter icon action
              },
              child: const Icon(
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
              // ── Search Bar ──────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  decoration: BoxDecoration(
                    color: _bgCard,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  child: TextField(
                    onChanged: (value) {
                      // Search implementation can be added later
                    },
                    style: const TextStyle(color: _textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Search actions or users',
                      hintStyle: const TextStyle(color: _textSecondary),
                      prefixIcon: const Icon(Icons.search_rounded, color: _textSecondary),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),

              // ── Filters ─────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    // Action Filter
                    GestureDetector(
                      onTap: () => _showActionFilterBottomSheet(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: _bgCard,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Action: $_selectedAction',
                              style: const TextStyle(
                                color: _textPrimary,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(Icons.expand_more_rounded, color: _textSecondary, size: 16),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Date Range Filter
                    GestureDetector(
                      onTap: () => _showDatePickerBottomSheet(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: _bgCard,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today_rounded, color: _purple, size: 14),
                            const SizedBox(width: 6),
                            Text(
                              'Oct 1 - Oct 12',
                              style: const TextStyle(
                                color: _textPrimary,
                                fontSize: 11,
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
              const SizedBox(height: 20),

              // ── Audit Log Timeline ──────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: List.generate(
                    _auditLogs.length,
                    (index) {
                      final log = _auditLogs[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: index < _auditLogs.length - 1 ? 16 : 0),
                        child: _AuditLogItem(
                          log: log,
                          color: _getActionColor(log['type']),
                          isExpanded: false,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _showActionFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _bgCard,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filter by Action',
              style: TextStyle(
                color: _textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            ..._actions.map(
              (action) => GestureDetector(
                onTap: () {
                  setState(() => _selectedAction = action);
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _selectedAction == action ? _purple : _textSecondary,
                            width: _selectedAction == action ? 2 : 1,
                          ),
                          shape: BoxShape.circle,
                          color: _selectedAction == action
                              ? _purple.withValues(alpha: 0.2)
                              : Colors.transparent,
                        ),
                        child: _selectedAction == action
                            ? const Center(
                                child: Icon(Icons.check, color: _purple, size: 12),
                              )
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        action,
                        style: const TextStyle(
                          color: _textPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDatePickerBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _bgCard,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Date Range',
              style: TextStyle(
                color: _textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _purple,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                final nav = Navigator.of(context);
                final range = await showDateRangePickerDialog(context);
                if (mounted && range != null) {
                  nav.pop();
                }
              },
              child: const Text(
                'Pick Date Range',
                style: TextStyle(
                  color: _textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Audit Log Item Widget ───────────────────────────────────────────────────
class _AuditLogItem extends StatefulWidget {
  final Map<String, dynamic> log;
  final Color color;
  final bool isExpanded;

  const _AuditLogItem({
    required this.log,
    required this.color,
    required this.isExpanded,
  });

  @override
  State<_AuditLogItem> createState() => _AuditLogItemState();
}

class _AuditLogItemState extends State<_AuditLogItem> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Timeline Dot and Header ─────────────────────────────────────
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: widget.color,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _isExpanded = !_isExpanded),
                child: Container(
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
                          Expanded(
                            child: Text(
                              widget.log['action'],
                              style: const TextStyle(
                                color: _textPrimary,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Icon(
                            _isExpanded
                                ? Icons.expand_less_rounded
                                : Icons.expand_more_rounded,
                            color: _textSecondary,
                            size: 18,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.log['actor'],
                        style: const TextStyle(
                          color: _textSecondary,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      // ── Expanded Content ────────────────────────────────
                      if (_isExpanded) ...[
                        const SizedBox(height: 12),
                        const Divider(color: Color(0xFF2A2842), height: 1),
                        const SizedBox(height: 12),

                        // Target & Timestamp
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'TARGET',
                                  style: TextStyle(
                                    color: _textSecondary,
                                    fontSize: 8,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.log['target'],
                                  style: const TextStyle(
                                    color: _textPrimary,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  'TIMESTAMP',
                                  style: TextStyle(
                                    color: _textSecondary,
                                    fontSize: 8,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.log['timestamp'],
                                  style: const TextStyle(
                                    color: _textPrimary,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Description
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'DESCRIPTION',
                              style: TextStyle(
                                color: _textSecondary,
                                fontSize: 8,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              widget.log['description'],
                              style: const TextStyle(
                                color: _textPrimary,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        // Details section (if available)
                        if (widget.log['details'] != null) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.04),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.06),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Reason: ${widget.log['details']['reason']}',
                                  style: const TextStyle(
                                    color: _textSecondary,
                                    fontSize: 10,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'BEFORE',
                                          style: TextStyle(
                                            color: _textSecondary,
                                            fontSize: 8,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(alpha: 0.06),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            widget.log['details']['before'],
                                            style: const TextStyle(
                                              color: _textPrimary,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 12),
                                    Icon(Icons.arrow_forward_rounded,
                                        color: _textSecondary, size: 14),
                                    const SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'AFTER',
                                          style: TextStyle(
                                            color: _textSecondary,
                                            fontSize: 8,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0xFF7B5CF6),
                                                Color(0xFFE07BB0),
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            widget.log['details']['after'],
                                            style: const TextStyle(
                                              color: _textPrimary,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Helper function for date range picker ───────────────────────────────────
Future<DateTimeRange?> showDateRangePickerDialog(BuildContext context) async {
  return showDateRangePicker(
    context: context,
    firstDate: DateTime(2024, 1, 1),
    lastDate: DateTime.now(),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: _purple,
            surface: _bgCard,
            onSurface: _textPrimary,
          ),
        ),
        child: child!,
      );
    },
  );
}
