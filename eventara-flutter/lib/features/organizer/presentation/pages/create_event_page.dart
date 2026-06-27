import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  // Form controllers
  final _titleCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  final _startTimeCtrl = TextEditingController();
  final _endTimeCtrl = TextEditingController();
  final _venueNameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _maxCapacityCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();

  String _selectedCategory = 'Music';
  String _selectedTicketType = 'General Admission';

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descriptionCtrl.dispose();
    _dateCtrl.dispose();
    _startTimeCtrl.dispose();
    _endTimeCtrl.dispose();
    _venueNameCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    _maxCapacityCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                          onTap: () => context.pop(),
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            color: _textPrimary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Create Event',
                          style: TextStyle(
                            color: _textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        // Save draft
                      },
                      child: const Text(
                        'Save Draft',
                        style: TextStyle(
                          color: _purpleLight,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Event Banner Upload ──────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: () {
                    // Upload banner
                  },
                  child: Container(
                    height: 140,
                    decoration: BoxDecoration(
                      color: _bgCard,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: _accentBlue.withValues(alpha: 0.3),
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: _purple.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.image_rounded,
                                color: _accentBlue,
                                size: 24,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Tap to upload event banner',
                            style: TextStyle(
                              color: _textPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Recommended size: 1200x600px',
                            style: TextStyle(
                              color: _textSecondary.withValues(alpha: 0.6),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // ── Event Details Section ────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SectionHeader('EVENT DETAILS'),
                    const SizedBox(height: 14),
                    // Event Title
                    _FormField(
                      label: 'Event title',
                      icon: Icons.text_fields_rounded,
                      controller: _titleCtrl,
                      hintText: 'Enter event title',
                    ),
                    const SizedBox(height: 12),
                    // Category Select
                    _FormSelect(
                      label: 'Select Category',
                      icon: Icons.category_rounded,
                      value: _selectedCategory,
                      items: ['Music', 'Sports', 'Theatre', 'Comedy', 'Meetup', 'Food'],
                      onChanged: (value) => setState(() => _selectedCategory = value),
                    ),
                    const SizedBox(height: 12),
                    // Description
                    _FormField(
                      label: 'Describe your event...',
                      icon: Icons.description_rounded,
                      controller: _descriptionCtrl,
                      hintText: 'Tell people what your event is about',
                      maxLines: 3,
                    ),
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
                    const _SectionHeader('DATE & TIME'),
                    const SizedBox(height: 14),
                    // Date picker
                    _FormField(
                      label: 'mm/dd/yyyy',
                      icon: Icons.calendar_today_rounded,
                      controller: _dateCtrl,
                      hintText: 'Select date',
                      readOnly: true,
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2099),
                        );
                        if (date != null) {
                          _dateCtrl.text =
                              '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
                        }
                      },
                    ),
                    const SizedBox(height: 14),
                    // Start & End time
                    Row(
                      children: [
                        Expanded(
                          child: _TimePickerField(
                            label: 'Start Time',
                            controller: _startTimeCtrl,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _TimePickerField(
                            label: 'End Time',
                            controller: _endTimeCtrl,
                          ),
                        ),
                      ],
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
                    const _SectionHeader('VENUE'),
                    const SizedBox(height: 14),
                    _FormField(
                      label: 'Venue Name',
                      icon: Icons.location_city_rounded,
                      controller: _venueNameCtrl,
                      hintText: 'Enter venue name',
                    ),
                    const SizedBox(height: 12),
                    _FormField(
                      label: 'Full Address',
                      icon: Icons.location_on_rounded,
                      controller: _addressCtrl,
                      hintText: 'Street address',
                    ),
                    const SizedBox(height: 12),
                    _FormField(
                      label: 'City',
                      icon: Icons.apartment_rounded,
                      controller: _cityCtrl,
                      hintText: 'City name',
                    ),
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
                    const _SectionHeader('TICKET TYPE'),
                    const SizedBox(height: 14),
                    // Ticket type tabs
                    Row(
                      children: [
                        _TicketTypeTab(
                          label: 'General Admission',
                          isSelected: _selectedTicketType == 'General Admission',
                          onTap: () => setState(() => _selectedTicketType = 'General Admission'),
                        ),
                        const SizedBox(width: 12),
                        _TicketTypeTab(
                          label: 'Seated',
                          isSelected: _selectedTicketType == 'Seated',
                          onTap: () => setState(() => _selectedTicketType = 'Seated'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Capacity & Price
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
                        const SizedBox(width: 12),
                        Expanded(
                          child: _FormField(
                            label: 'Price (LKR)',
                            icon: Icons.attach_money_rounded,
                            controller: _priceCtrl,
                            hintText: '0.00',
                            keyboardType: TextInputType.number,
                          ),
                        ),
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
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: _purpleLight.withValues(alpha: 0.3),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'Save as Draft',
                            style: TextStyle(
                              color: _purpleLight,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
                            colors: [_gradStart, _gradEnd],
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'Submit for Review',
                            style: TextStyle(
                              color: _textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
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

// ── Section Header widget ────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: _textSecondary,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
      ),
    );
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
          style: const TextStyle(
            color: _textPrimary,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: _textSecondary.withValues(alpha: 0.5),
              fontSize: 13,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 12, right: 8),
              child: Icon(
                widget.icon,
                color: _focused ? _purpleLight : _textSecondary,
                size: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Form Select widget ───────────────────────────────────────────────────────
class _FormSelect extends StatelessWidget {
  final String label;
  final IconData icon;
  final String value;
  final List<String> items;
  final Function(String) onChanged;

  const _FormSelect({
    required this.label,
    required this.icon,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _bgCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: DropdownButton<String>(
          value: value,
          onChanged: (newValue) {
            if (newValue != null) onChanged(newValue);
          },
          underline: const SizedBox(),
          isExpanded: true,
          dropdownColor: _bgCard,
          icon: Icon(
            Icons.expand_more_rounded,
            color: _textSecondary,
            size: 20,
          ),
          style: const TextStyle(
            color: _textPrimary,
            fontSize: 14,
          ),
          items: items
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Row(
                      children: [
                        Icon(Icons.category_rounded, color: _textSecondary, size: 16),
                        const SizedBox(width: 8),
                        Text(item),
                      ],
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

// ── Time Picker Field widget ─────────────────────────────────────────────────
class _TimePickerField extends StatefulWidget {
  final String label;
  final TextEditingController controller;

  const _TimePickerField({
    required this.label,
    required this.controller,
  });

  @override
  State<_TimePickerField> createState() => _TimePickerFieldState();
}

class _TimePickerFieldState extends State<_TimePickerField> {
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Icon(
                Icons.schedule_rounded,
                color: _focused ? _purpleLight : _textSecondary,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  readOnly: true,
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (time != null) {
                      widget.controller.text = time.format(context);
                    }
                  },
                  style: const TextStyle(
                    color: _textPrimary,
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.label,
                    hintStyle: TextStyle(
                      color: _textSecondary.withValues(alpha: 0.5),
                      fontSize: 13,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null) {
                    widget.controller.text = time.format(context);
                  }
                },
                child: Icon(
                  Icons.access_time_rounded,
                  color: _textSecondary.withValues(alpha: 0.6),
                  size: 18,
                ),
              ),
            ],
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
              color: isSelected
                  ? _purple
                  : Colors.white.withValues(alpha: 0.1),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? _textPrimary : _textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
