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
const _accentOrange = Color(0xFFD97744);
const _accentRed = Color(0xFFFF6B6B);

Color _statusColor(String status) {
  switch (status.toUpperCase()) {
    case 'PUBLISHED': case 'APPROVED': return _accentGreen;
    case 'DRAFT': return _textSecondary;
    case 'SUBMITTED': return _accentBlue;
    case 'REJECTED': case 'CANCELLED': return Colors.red;
    default: return _textSecondary;
  }
}

class EditEventPage extends ConsumerStatefulWidget {
  final String eventId;
  const EditEventPage({super.key, required this.eventId});

  @override
  ConsumerState<EditEventPage> createState() => _EditEventPageState();
}

class _EditEventPageState extends ConsumerState<EditEventPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _venueController = TextEditingController();
  final _venueAddressController = TextEditingController();
  final _cityController = TextEditingController();
  final _capacityController = TextEditingController();
  final _priceController = TextEditingController();

  DateTime? _eventDate;
  DateTime? _endDate;
  OrganizerEventModel? _event;
  bool _isSaving = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadEvent();
  }

  void _loadEvent() {
    final state = ref.read(organizerEventsProvider);
    if (state is OrganizerEventsLoaded) {
      final id = int.tryParse(widget.eventId);
      final found = state.events.where((e) => e.id == id).toList();
      if (found.isNotEmpty) _populateForm(found.first);
    } else {
      // Load events first
      Future.microtask(() async {
        await ref.read(organizerEventsProvider.notifier).loadMyEvents();
        if (mounted) _loadEvent();
      });
    }
  }

  void _populateForm(OrganizerEventModel event) {
    setState(() {
      _event = event;
      _titleController.text = event.title;
      _descriptionController.text = event.description ?? '';
      _venueController.text = event.venueName ?? '';
      _venueAddressController.text = event.venueAddress ?? '';
      _cityController.text = event.city ?? '';
      _capacityController.text = event.maxCapacity?.toString() ?? '';
      _priceController.text = event.generalAdmissionPrice?.toString() ?? '';
      if (event.eventDate != null) {
        try { _eventDate = DateTime.parse(event.eventDate!); } catch (_) {}
      }
      if (event.endDate != null) {
        try { _endDate = DateTime.parse(event.endDate!); } catch (_) {}
      }
    });
  }

  Future<void> _save() async {
    if (_titleController.text.isEmpty) {
      _snack('Title is required');
      return;
    }
    setState(() => _isSaving = true);

    final id = int.tryParse(widget.eventId);
    if (id == null) return;

    final data = {
      'title': _titleController.text,
      'description': _descriptionController.text,
      'venueName': _venueController.text,
      'venueAddress': _venueAddressController.text,
      'city': _cityController.text,
      'maxCapacity': int.tryParse(_capacityController.text) ?? 0,
      if (_eventDate != null) 'eventDate': _eventDate!.toIso8601String(),
      if (_endDate != null) 'endDate': _endDate!.toIso8601String(),
      if (_event != null) 'ticketType': _event!.ticketType,
      if (_priceController.text.isNotEmpty)
        'generalAdmissionPrice': double.tryParse(_priceController.text),
      if (_event != null) 'categoryId': _event!.categoryId,
    };

    final ok = await ref.read(organizerEventsProvider.notifier).updateEvent(id, data);
    if (mounted) {
      setState(() => _isSaving = false);
      _snack(ok ? 'Event updated' : 'Update failed');
      if (ok) context.go(AppRoutes.organizerMyEvents);
    }
  }

  Future<void> _submit() async {
    final id = int.tryParse(widget.eventId);
    if (id == null) return;
    setState(() => _isSubmitting = true);
    final ok = await ref.read(organizerEventsProvider.notifier).submitEvent(id);
    if (mounted) {
      setState(() => _isSubmitting = false);
      _snack(ok ? 'Event submitted for review' : 'Submit failed');
      if (ok) context.go(AppRoutes.organizerMyEvents);
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return '';
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}  $h:$m';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _venueController.dispose();
    _venueAddressController.dispose();
    _cityController.dispose();
    _capacityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eventsState = ref.watch(organizerEventsProvider);
    if (_event == null && (eventsState is OrganizerEventsLoading || eventsState is OrganizerEventsInitial)) {
      return const Scaffold(
        backgroundColor: _bgDeep,
        body: Center(child: CircularProgressIndicator(color: _purple)),
      );
    }

    final status = _event?.status ?? 'DRAFT';

    return Scaffold(
      backgroundColor: _bgDeep,
      appBar: AppBar(
        backgroundColor: _bgDeep,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.go(AppRoutes.organizerMyEvents),
          child: const Icon(Icons.arrow_back_rounded, color: _textPrimary),
        ),
        title: const Text('Edit Event',
            style: TextStyle(color: _textPrimary, fontSize: 18, fontWeight: FontWeight.w800)),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: _isSaving ? null : _save,
              child: Icon(Icons.check_circle_rounded, color: _accentGreen, size: 24),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Event Image Section ────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [_purple.withValues(alpha: 0.3), _gradEnd.withValues(alpha: 0.2)],
                    ),
                  ),
                  child: Stack(
                    children: [
                      Center(child: Icon(Icons.event_rounded, size: 80, color: _purple.withValues(alpha: 0.3))),
                      Positioned(
                        bottom: 12,
                        right: 12,
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [_gradStart, _gradEnd]),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(child: Icon(Icons.camera_alt_rounded, color: _textPrimary, size: 20)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            _SectionHeader(title: 'BASIC INFO'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _TextInputField(label: 'Event Title', controller: _titleController, icon: Icons.event_rounded),
                  const SizedBox(height: 12),
                  _TextInputField(label: 'Description', controller: _descriptionController, icon: Icons.description_rounded, maxLines: 3),
                  const SizedBox(height: 12),
                  _TextInputField(label: 'Venue', controller: _venueController, icon: Icons.location_city_rounded),
                  const SizedBox(height: 12),
                  _TextInputField(label: 'Address', controller: _venueAddressController, icon: Icons.location_on_rounded),
                  const SizedBox(height: 12),
                  _TextInputField(label: 'City', controller: _cityController, icon: Icons.apartment_rounded),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _SectionHeader(title: 'DATE & TIME'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _DatePickerField(
                    label: 'Event Date & Time',
                    value: _eventDate,
                    display: _formatDate(_eventDate),
                    onPick: (dt) => setState(() => _eventDate = dt),
                  ),
                  const SizedBox(height: 12),
                  _DatePickerField(
                    label: 'End Date & Time',
                    value: _endDate,
                    display: _formatDate(_endDate),
                    onPick: (dt) => setState(() => _endDate = dt),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _SectionHeader(title: 'CAPACITY'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _TextInputField(label: 'Total Capacity', controller: _capacityController, icon: Icons.people_rounded, keyboardType: TextInputType.number),
                  if (_event?.ticketType == 'GENERAL_ADMISSION') ...[
                    const SizedBox(height: 12),
                    _TextInputField(label: 'Price (LKR)', controller: _priceController, icon: Icons.currency_exchange_rounded, keyboardType: TextInputType.number),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),

            _SectionHeader(title: 'STATUS'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _bgCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline_rounded, color: _accentBlue, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Current Status', style: TextStyle(color: _textSecondary, fontSize: 11, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Text(status, style: TextStyle(color: _statusColor(status), fontSize: 13, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                    if (_event?.rejectionNotes != null)
                      Expanded(
                        child: Text(_event!.rejectionNotes!,
                            style: TextStyle(color: Colors.red.withValues(alpha: 0.8), fontSize: 11)),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            _SectionHeader(title: 'QUICK ACTIONS'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _ActionCard(
                    icon: Icons.grid_3x3_rounded,
                    title: 'Manage Seat Map',
                    description: 'Configure seating arrangement',
                    onTap: () => context.go(AppRoutes.buildOrganizerSeatMapEditor(widget.eventId)),
                  ),
                  const SizedBox(height: 10),
                  _ActionCard(
                    icon: Icons.local_offer_rounded,
                    title: 'Set Pricing',
                    description: 'Configure ticket prices',
                    onTap: () => context.go(AppRoutes.buildOrganizerPricingSetup(widget.eventId)),
                  ),
                  const SizedBox(height: 10),
                  _ActionCard(
                    icon: Icons.people_alt_rounded,
                    title: 'View Bookings',
                    description: 'See all ticket bookings',
                    onTap: () => context.go(AppRoutes.organizerBookings),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Action buttons ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _isSaving ? null : _save,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(colors: [_gradStart, _gradEnd]),
                      ),
                      child: Center(
                        child: _isSaving
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: _textPrimary, strokeWidth: 2))
                            : const Text('Save Changes', style: TextStyle(color: _textPrimary, fontSize: 14, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ),
                  if (status == 'DRAFT') ...[
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: _isSubmitting ? null : _submit,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: _purpleLight.withValues(alpha: 0.4)),
                        ),
                        child: Center(
                          child: _isSubmitting
                              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: _purpleLight, strokeWidth: 2))
                              : const Text('Submit for Review', style: TextStyle(color: _purpleLight, fontSize: 14, fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: _OrganizerBottomNav(selectedIndex: 1),
    );
  }
}

// ── Shared widgets ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Text(title,
          style: TextStyle(
              color: _textSecondary, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
    );
  }
}

class _TextInputField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final int maxLines;
  final bool readOnly;
  final TextInputType keyboardType;

  const _TextInputField({
    required this.label,
    required this.controller,
    required this.icon,
    this.maxLines = 1,
    this.readOnly = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<_TextInputField> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<_TextInputField> {
  bool _focused = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() => setState(() => _focused = _focusNode.hasFocus));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _focused ? _purple.withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        readOnly: widget.readOnly,
        maxLines: widget.maxLines,
        keyboardType: widget.keyboardType,
        decoration: InputDecoration(
          hintText: widget.label,
          hintStyle: TextStyle(color: _textSecondary.withValues(alpha: 0.5), fontSize: 13),
          prefixIcon: Icon(widget.icon, color: _textSecondary, size: 18),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
        style: const TextStyle(color: _textPrimary, fontSize: 13),
        cursorColor: _purple,
      ),
    );
  }
}

class _DatePickerField extends StatelessWidget {
  final String label;
  final DateTime? value;
  final String display;
  final Function(DateTime) onPick;

  const _DatePickerField({
    required this.label,
    required this.value,
    required this.display,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: value ?? DateTime.now(),
          firstDate: DateTime.now().subtract(const Duration(days: 365)),
          lastDate: DateTime(2099),
        );
        if (date == null || !context.mounted) return;
        final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
        if (time == null) return;
        onPick(DateTime(date.year, date.month, date.day, time.hour, time.minute));
      },
      child: Container(
        decoration: BoxDecoration(
          color: _bgCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Icon(Icons.calendar_today_rounded, color: _textSecondary, size: 18),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  display.isNotEmpty ? display : label,
                  style: TextStyle(
                    color: display.isNotEmpty ? _textPrimary : _textSecondary.withValues(alpha: 0.5),
                    fontSize: 13,
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

class _ActionCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  State<_ActionCard> createState() => _ActionCardState();
}

class _ActionCardState extends State<_ActionCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _hovered ? 1.02 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _bgCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _hovered ? _purple.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.08),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _purple.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(child: Icon(widget.icon, color: _purpleLight, size: 20)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.title, style: const TextStyle(color: _textPrimary, fontSize: 13, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 2),
                      Text(widget.description, style: TextStyle(color: _textSecondary.withValues(alpha: 0.6), fontSize: 11)),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded,
                    color: _hovered ? _purpleLight : _textSecondary, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
                    Icon(item['icon'] as IconData, color: isSel ? _purpleLight : _textSecondary, size: 24),
                    const SizedBox(height: 4),
                    Text(item['label'] as String,
                        style: TextStyle(color: isSel ? _purpleLight : _textSecondary, fontSize: 11, fontWeight: FontWeight.w600)),
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
