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
const _accentBlue = Color(0xFF4ECDC4);

class CreateEventPage extends ConsumerStatefulWidget {
  const CreateEventPage({super.key});

  @override
  ConsumerState<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends ConsumerState<CreateEventPage> {
  final _titleCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _venueNameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _maxCapacityCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();

  DateTime? _eventDate;
  DateTime? _endDate;
  String _selectedTicketType = 'GENERAL_ADMISSION';
  int? _selectedCategoryId;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descriptionCtrl.dispose();
    _venueNameCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    _maxCapacityCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  String? _validate() {
    if (_titleCtrl.text.isEmpty) return 'Title is required';
    if (_descriptionCtrl.text.isEmpty) return 'Description is required';
    if (_eventDate == null) return 'Event date is required';
    if (_endDate == null) return 'End date is required';
    if (_venueNameCtrl.text.isEmpty) return 'Venue name is required';
    if (_addressCtrl.text.isEmpty) return 'Address is required';
    if (_cityCtrl.text.isEmpty) return 'City is required';
    if (_maxCapacityCtrl.text.isEmpty) return 'Capacity is required';
    if (_selectedCategoryId == null) return 'Category is required';
    if (_selectedTicketType == 'GENERAL_ADMISSION' && _priceCtrl.text.isEmpty) {
      return 'Price is required for General Admission';
    }
    return null;
  }

  Future<void> _submit({bool asDraft = false}) async {
    final error = _validate();
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    setState(() => _isSubmitting = true);

    final data = {
      'title': _titleCtrl.text,
      'description': _descriptionCtrl.text,
      'eventDate': _eventDate!.toIso8601String(),
      'endDate': _endDate!.toIso8601String(),
      'venueName': _venueNameCtrl.text,
      'venueAddress': _addressCtrl.text,
      'city': _cityCtrl.text,
      'ticketType': _selectedTicketType,
      'maxCapacity': int.tryParse(_maxCapacityCtrl.text) ?? 0,
      'categoryId': _selectedCategoryId,
      if (_selectedTicketType == 'GENERAL_ADMISSION' && _priceCtrl.text.isNotEmpty)
        'generalAdmissionPrice': double.tryParse(_priceCtrl.text),
    };

    final ok = await ref.read(organizerEventsProvider.notifier).createEvent(data);

    if (mounted) {
      setState(() => _isSubmitting = false);
      if (ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event created successfully')),
        );
        context.go(AppRoutes.organizerMyEvents);
      } else {
        final state = ref.read(organizerEventsProvider);
        final msg = state is OrganizerEventsError ? state.message : 'Failed to create event';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      backgroundColor: _bgDeep,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => context.go(AppRoutes.organizerMyEvents),
                          child: const Icon(Icons.arrow_back_rounded,
                              color: _textPrimary, size: 24),
                        ),
                        const SizedBox(width: 12),
                        const Text('Create Event',
                            style: TextStyle(
                                color: _textPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Event Details Section ────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionHeader('EVENT DETAILS'),
                    const SizedBox(height: 14),
                    _FormField(label: 'Event Title', icon: Icons.text_fields_rounded, controller: _titleCtrl, hintText: 'Enter event title'),
                    const SizedBox(height: 12),

                    // Category Dropdown
                    categoriesAsync.when(
                      loading: () => const Center(child: CircularProgressIndicator(color: _purple)),
                      error: (e, _) => Text('Failed to load categories', style: TextStyle(color: _textSecondary)),
                      data: (categories) => _CategorySelect(
                        categories: categories,
                        selectedId: _selectedCategoryId,
                        onChanged: (id) => setState(() => _selectedCategoryId = id),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _FormField(label: 'Describe your event...', icon: Icons.description_rounded, controller: _descriptionCtrl, hintText: 'Tell people what your event is about', maxLines: 3),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // ── Date & Time Section ──────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionHeader('DATE & TIME'),
                    const SizedBox(height: 14),
                    _DatePickerField(
                      label: 'Event Date & Time',
                      value: _eventDate,
                      onPick: (dt) => setState(() => _eventDate = dt),
                    ),
                    const SizedBox(height: 12),
                    _DatePickerField(
                      label: 'End Date & Time',
                      value: _endDate,
                      onPick: (dt) => setState(() => _endDate = dt),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // ── Venue Section ───────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionHeader('VENUE'),
                    const SizedBox(height: 14),
                    _FormField(label: 'Venue Name', icon: Icons.location_city_rounded, controller: _venueNameCtrl, hintText: 'Enter venue name'),
                    const SizedBox(height: 12),
                    _FormField(label: 'Full Address', icon: Icons.location_on_rounded, controller: _addressCtrl, hintText: 'Street address'),
                    const SizedBox(height: 12),
                    _FormField(label: 'City', icon: Icons.apartment_rounded, controller: _cityCtrl, hintText: 'City name'),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // ── Ticket Type Section ──────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionHeader('TICKET TYPE'),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        _TicketTypeTab(
                          label: 'General Admission',
                          isSelected: _selectedTicketType == 'GENERAL_ADMISSION',
                          onTap: () => setState(() => _selectedTicketType = 'GENERAL_ADMISSION'),
                        ),
                        const SizedBox(width: 12),
                        _TicketTypeTab(
                          label: 'Seated',
                          isSelected: _selectedTicketType == 'SEATED',
                          onTap: () => setState(() => _selectedTicketType = 'SEATED'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _FormField(
                            label: 'Max Capacity',
                            icon: Icons.people_rounded,
                            controller: _maxCapacityCtrl,
                            hintText: '0',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        if (_selectedTicketType == 'GENERAL_ADMISSION') ...[
                          const SizedBox(width: 12),
                          Expanded(
                            child: _LkrPriceField(controller: _priceCtrl),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // ── Action Buttons ──────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: _isSubmitting ? null : () => _submit(asDraft: true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: _purpleLight.withValues(alpha: 0.3)),
                          ),
                          child: const Center(
                            child: Text('Save as Draft',
                                style: TextStyle(
                                    color: _purpleLight,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: _isSubmitting ? null : () => _submit(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(colors: [_gradStart, _gradEnd]),
                          ),
                          child: Center(
                            child: _isSubmitting
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                        color: _textPrimary, strokeWidth: 2))
                                : const Text('Submit for Review',
                                    style: TextStyle(
                                        color: _textPrimary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ── DatePickerField ──────────────────────────────────────────────────────────
class _DatePickerField extends StatefulWidget {
  final String label;
  final DateTime? value;
  final Function(DateTime) onPick;

  const _DatePickerField({
    required this.label,
    required this.value,
    required this.onPick,
  });

  @override
  State<_DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<_DatePickerField> {
  bool _focused = false;

  String _format(DateTime? dt) {
    if (dt == null) return '';
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}  $h:$m';
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _focused = true),
      onExit: (_) => setState(() => _focused = false),
      child: GestureDetector(
        onTap: () async {
          final date = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2099),
          );
          if (date == null || !context.mounted) return;
          final time = await showTimePicker(
              context: context, initialTime: TimeOfDay.now());
          if (time == null) return;
          final combined = DateTime(date.year, date.month, date.day, time.hour, time.minute);
          widget.onPick(combined);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: _bgCard,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _focused
                  ? _purple.withValues(alpha: 0.4)
                  : Colors.white.withValues(alpha: 0.08),
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Icon(Icons.calendar_today_rounded,
                    color: _focused ? _purpleLight : _textSecondary, size: 18),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.value != null ? _format(widget.value) : widget.label,
                    style: TextStyle(
                        color: widget.value != null
                            ? _textPrimary
                            : _textSecondary.withValues(alpha: 0.5),
                        fontSize: 14),
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

// ── Category Select ──────────────────────────────────────────────────────────
class _CategorySelect extends StatelessWidget {
  final List<CategoryModel> categories;
  final int? selectedId;
  final Function(int?) onChanged;

  const _CategorySelect({
    required this.categories,
    required this.selectedId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _bgCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: DropdownButton<int>(
          value: selectedId,
          hint: Row(
            children: [
              Icon(Icons.category_rounded, color: _textSecondary, size: 18),
              const SizedBox(width: 8),
              Text('Select Category',
                  style: TextStyle(
                      color: _textSecondary.withValues(alpha: 0.5), fontSize: 13)),
            ],
          ),
          onChanged: onChanged,
          underline: const SizedBox(),
          isExpanded: true,
          dropdownColor: _bgCard,
          icon: Icon(Icons.expand_more_rounded, color: _textSecondary, size: 20),
          style: const TextStyle(color: _textPrimary, fontSize: 14),
          items: categories
              .map((cat) => DropdownMenuItem<int>(
                    value: cat.id,
                    child: Row(
                      children: [
                        Icon(Icons.category_rounded,
                            color: _textSecondary, size: 16),
                        const SizedBox(width: 8),
                        Text(cat.name),
                      ],
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

// ── LKR Price Field ──────────────────────────────────────────────────────────
class _LkrPriceField extends StatefulWidget {
  final TextEditingController controller;
  const _LkrPriceField({required this.controller});

  @override
  State<_LkrPriceField> createState() => _LkrPriceFieldState();
}

class _LkrPriceFieldState extends State<_LkrPriceField> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _focused = true),
      onExit: (_) => setState(() => _focused = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: _bgCard,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _focused
                ? _purple.withValues(alpha: 0.4)
                : Colors.white.withValues(alpha: 0.08),
            width: 1.5,
          ),
        ),
        child: TextField(
          controller: widget.controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: _textPrimary, fontSize: 14),
          decoration: InputDecoration(
            hintText: '0.00',
            hintStyle: TextStyle(
                color: _textSecondary.withValues(alpha: 0.5), fontSize: 13),
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 12, right: 8),
              child: Center(
                widthFactor: 1,
                child: Text(
                  'LKR',
                  style: TextStyle(
                    color: _focused ? _purpleLight : _textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Section Header widget ────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(title,
        style: TextStyle(
            color: _textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8));
  }
}

// ── Form Field widget ────────────────────────────────────────────────────────
class _FormField extends StatefulWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final TextInputType keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;

  const _FormField({
    required this.label,
    required this.icon,
    required this.controller,
    required this.hintText,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.onTap,
  });

  @override
  State<_FormField> createState() => _FormFieldState();
}

class _FormFieldState extends State<_FormField> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _focused = true),
      onExit: (_) => setState(() => _focused = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: _bgCard,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _focused
                ? _purple.withValues(alpha: 0.4)
                : Colors.white.withValues(alpha: 0.08),
            width: 1.5,
          ),
        ),
        child: TextField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          maxLines: widget.maxLines,
          minLines: widget.maxLines == 1 ? 1 : widget.maxLines,
          readOnly: widget.readOnly,
          onTap: widget.onTap,
          style: const TextStyle(color: _textPrimary, fontSize: 14),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(
                color: _textSecondary.withValues(alpha: 0.5), fontSize: 13),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 12, right: 8),
              child: Icon(widget.icon,
                  color: _focused ? _purpleLight : _textSecondary, size: 18),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Ticket Type Tab widget ──────────────────────────────────────────────────
class _TicketTypeTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TicketTypeTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            color: isSelected ? _purple : _bgCard,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? _purple : Colors.white.withValues(alpha: 0.1),
            ),
          ),
          child: Center(
            child: Text(label,
                style: TextStyle(
                    color: isSelected ? _textPrimary : _textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700)),
          ),
        ),
      ),
    );
  }
}
