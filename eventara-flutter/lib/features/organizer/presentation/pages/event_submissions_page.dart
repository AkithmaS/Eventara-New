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
const _accentBlue = Color(0xFF4ECDC4);
const _textPrimary = Color(0xFFFFFFFF);
const _textSecondary = Color(0xFFB0A8D0);

class EventSubmissionsPage extends ConsumerStatefulWidget {
  const EventSubmissionsPage({super.key});

  @override
  ConsumerState<EventSubmissionsPage> createState() =>
      _EventSubmissionsPageState();
}

class _EventSubmissionsPageState extends ConsumerState<EventSubmissionsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        ref.read(organizerEventsProvider.notifier).loadEventsByStatus('SUBMITTED'));
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final dt = DateTime.parse(dateStr);
      const m = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
      return '${m[dt.month - 1]} ${dt.day}, ${dt.year}';
    } catch (_) { return dateStr; }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(organizerEventsProvider);

    return Scaffold(
      backgroundColor: _bgDeep,
      appBar: AppBar(
        backgroundColor: _bgDeep,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_rounded, color: _textPrimary),
        ),
        title: const Text('Event Submissions',
            style: TextStyle(color: _textPrimary, fontSize: 18, fontWeight: FontWeight.w800)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: state is OrganizerEventsLoading || state is OrganizerEventsInitial
            ? const Center(child: CircularProgressIndicator(color: _purple))
            : state is OrganizerEventsError
                ? Center(child: Text(state.message, style: const TextStyle(color: _textSecondary)))
                : _buildList(state is OrganizerEventsLoaded ? state.events : []),
      ),
    );
  }

  Widget _buildList(List<OrganizerEventModel> events) {
    if (events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pending_actions_rounded, size: 64, color: _textSecondary.withValues(alpha: 0.3)),
            const SizedBox(height: 16),
            Text('No pending submissions', style: TextStyle(color: _textSecondary.withValues(alpha: 0.6), fontSize: 14)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: _purple,
      onRefresh: () => ref.read(organizerEventsProvider.notifier).loadEventsByStatus('SUBMITTED'),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _bgCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _accentBlue.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(child: Icon(Icons.pending_actions_rounded, color: _accentBlue, size: 22)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(event.title, style: const TextStyle(color: _textPrimary, fontSize: 14, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 4),
                        Text('Submitted ${_formatDate(event.updatedAt)}',
                            style: TextStyle(color: _textSecondary.withValues(alpha: 0.7), fontSize: 11)),
                        if (event.venueName != null) ...[
                          const SizedBox(height: 2),
                          Text(event.venueName!, style: TextStyle(color: _textSecondary.withValues(alpha: 0.6), fontSize: 11)),
                        ],
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _accentBlue.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text('PENDING REVIEW',
                        style: TextStyle(color: _accentBlue, fontSize: 9, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
