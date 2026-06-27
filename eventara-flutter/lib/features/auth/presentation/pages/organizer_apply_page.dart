import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// ─── Colour tokens (matching the landing page exactly) ─────────────────────
const _bgDeep = Color(0xFF0D0B1E);
const _bgCard = Color(0xFF151228);
const _purple = Color(0xFF7B5CF6);
const _purpleLight = Color(0xFF9B8AFB);
const _gradStart = Color(0xFF7B5CF6);
const _gradEnd = Color(0xFFE07BB0);
const _textPrimary = Color(0xFFFFFFFF);
const _textSecondary = Color(0xFFB0A8D0);

class OrganizerApplyPage extends ConsumerStatefulWidget {
  const OrganizerApplyPage({super.key});

  @override
  ConsumerState<OrganizerApplyPage> createState() => _OrganizerApplyPageState();
}

class _OrganizerApplyPageState extends ConsumerState<OrganizerApplyPage> {
  final _fullNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  final _orgNameCtrl = TextEditingController();
  final _eventDescCtrl = TextEditingController();
  final _websiteCtrl = TextEditingController();
  
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  String? _selectedOrgType;

  final List<String> _orgTypes = [
    'Corporate',
    'Non-Profit',
    'Educational',
    'Entertainment',
    'Sports',
    'Other',
  ];

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    _orgNameCtrl.dispose();
    _eventDescCtrl.dispose();
    _websiteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgDeep,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Back button ───────────────────────────────────────────
              GestureDetector(
                onTap: () => context.go('/login'),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: _textPrimary,
                  size: 24,
                ),
              ),
              const SizedBox(height: 32),
              // ── Heading ────────────────────────────────────────────────
              const Text(
                'Become an Organizer',
                style: TextStyle(
                  color: _textPrimary,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Fill in your details. Our team will review and get back to you via email.',
                style: TextStyle(
                  color: _textSecondary,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              // ── Personal Details Section ────────────────────────────
              _SectionHeader(label: 'Personal Details'),
              const SizedBox(height: 16),
              // Full Name
              _OrganizerTextField(
                controller: _fullNameCtrl,
                label: 'Full Name',
                icon: Icons.person_outline_rounded,
              ),
              const SizedBox(height: 16),
              // Email
              _OrganizerTextField(
                controller: _emailCtrl,
                label: 'Email',
                icon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              // Phone
              _OrganizerTextField(
                controller: _phoneCtrl,
                label: 'Phone Number',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              // Password
              _OrganizerTextField(
                controller: _passwordCtrl,
                label: 'Create Password',
                icon: Icons.lock_outline_rounded,
                obscure: !_showPassword,
                suffixIcon: GestureDetector(
                  onTap: () => setState(() => _showPassword = !_showPassword),
                  child: Icon(
                    _showPassword
                        ? Icons.visibility_rounded
                        : Icons.visibility_off_rounded,
                    color: _textSecondary,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Confirm Password
              _OrganizerTextField(
                controller: _confirmPasswordCtrl,
                label: 'Confirm Password',
                icon: Icons.lock_outline_rounded,
                obscure: !_showConfirmPassword,
                suffixIcon: GestureDetector(
                  onTap: () => setState(() => _showConfirmPassword = !_showConfirmPassword),
                  child: Icon(
                    _showConfirmPassword
                        ? Icons.visibility_rounded
                        : Icons.visibility_off_rounded,
                    color: _textSecondary,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // ── Organization Details Section ─────────────────────────
              _SectionHeader(label: 'Organization Details'),
              const SizedBox(height: 16),
              // Organization Name
              _OrganizerTextField(
                controller: _orgNameCtrl,
                label: 'Organization/Business Name',
                icon: Icons.business_outlined,
              ),
              const SizedBox(height: 16),
              // Organization Type Dropdown
              _OrgTypeDropdown(
                selectedValue: _selectedOrgType,
                items: _orgTypes,
                onChanged: (value) => setState(() => _selectedOrgType = value),
              ),
              const SizedBox(height: 16),
              // Event Description
              _OrganizerTextField(
                controller: _eventDescCtrl,
                label: 'Tell us about your events...',
                icon: Icons.description_outlined,
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              // Website or Social Media
              _OrganizerTextField(
                controller: _websiteCtrl,
                label: 'Website or Social Media Link (Optional)',
                icon: Icons.link_outlined,
              ),
              const SizedBox(height: 28),
              // ── Submit button ────────────────────────────────────────
              _SubmitButton(
                label: 'Submit Application',
                onTap: () {
                  // TODO: Implement organizer application submission
                },
              ),
              const SizedBox(height: 16),
              // ── Info message ───────────────────────────────────────────
              Center(
                child: Text(
                  'After submitting, your application will be\nreviewed by our team. You will be notified via\nemail once a decision has been made.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _textSecondary.withValues(alpha: 0.7),
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

/// Section header with purple left border
class _SectionHeader extends StatelessWidget {
  final String label;

  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: _purple,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            color: _textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

/// Reusable text field for organizer form
class _OrganizerTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType keyboardType;
  final bool obscure;
  final Widget? suffixIcon;
  final int maxLines;

  const _OrganizerTextField({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.obscure = false,
    this.suffixIcon,
    this.maxLines = 1,
  });

  @override
  State<_OrganizerTextField> createState() => _OrganizerTextFieldState();
}

class _OrganizerTextFieldState extends State<_OrganizerTextField> {
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
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _focused
                ? _purple.withValues(alpha: 0.5)
                : Colors.white.withValues(alpha: 0.08),
            width: 1.5,
          ),
        ),
        child: TextField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscure,
          maxLines: widget.maxLines,
          minLines: widget.maxLines == 1 ? 1 : null,
          style: const TextStyle(
            color: _textPrimary,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: widget.label,
            hintStyle: const TextStyle(
              color: _textSecondary,
              fontSize: 14,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 12, right: 8),
              child: Icon(
                widget.icon,
                color: _focused ? _purpleLight : _textSecondary,
                size: 20,
              ),
            ),
            suffixIcon: widget.suffixIcon != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: widget.suffixIcon,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}

/// Organization Type Dropdown
class _OrgTypeDropdown extends StatefulWidget {
  final String? selectedValue;
  final List<String> items;
  final Function(String?) onChanged;

  const _OrgTypeDropdown({
    required this.selectedValue,
    required this.items,
    required this.onChanged,
  });

  @override
  State<_OrgTypeDropdown> createState() => _OrgTypeDropdownState();
}

class _OrgTypeDropdownState extends State<_OrgTypeDropdown> {
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
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _focused
                ? _purple.withValues(alpha: 0.5)
                : Colors.white.withValues(alpha: 0.08),
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: DropdownButton<String>(
            value: widget.selectedValue,
            hint: Row(
              children: [
                Icon(
                  Icons.business_outlined,
                  color: _focused ? _purpleLight : _textSecondary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Organization Type',
                  style: TextStyle(
                    color: _textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            isExpanded: true,
            underline: const SizedBox.shrink(),
            style: const TextStyle(
              color: _textPrimary,
              fontSize: 16,
            ),
            dropdownColor: _bgCard,
            items: widget.items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: widget.onChanged,
            icon: Icon(
              Icons.expand_more_rounded,
              color: _focused ? _purpleLight : _textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

/// Submit button with hover scale animation
class _SubmitButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _SubmitButton({
    required this.label,
    required this.onTap,
  });

  @override
  State<_SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<_SubmitButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.03 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: const LinearGradient(
                colors: [_gradStart, _gradEnd],
              ),
              boxShadow: [
                BoxShadow(
                  color: _purple.withValues(alpha: 0.45),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.label,
                  style: const TextStyle(
                    color: _textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_forward_rounded,
                  color: _textPrimary,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
