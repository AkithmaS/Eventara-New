import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
const _accentGreen = Color(0xFF4ECB71);

class PricingSetupPage extends ConsumerStatefulWidget {
  final String eventId;

  const PricingSetupPage({super.key, required this.eventId});

  @override
  ConsumerState<PricingSetupPage> createState() => _PricingSetupPageState();
}

class _PricingSetupPageState extends ConsumerState<PricingSetupPage> {
  // Zones: name, price, controller
  final List<_ZoneEntry> _zones = [
    _ZoneEntry(name: 'Premium', price: TextEditingController(text: '5000'), color: _purple),
    _ZoneEntry(name: 'Standard', price: TextEditingController(text: '3500'), color: _accentBlue),
    _ZoneEntry(name: 'Economy', price: TextEditingController(text: '2000'), color: _accentGreen),
  ];

  bool _isSaving = false;

  @override
  void dispose() {
    for (final z in _zones) { z.price.dispose(); }
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    final id = int.tryParse(widget.eventId);
    if (id == null) { setState(() => _isSaving = false); return; }

    final zoneData = _zones.map((z) => {
      'zoneName': z.name,
      'price': double.tryParse(z.price.text) ?? 0.0,
    }).toList();

    final ok = await ref.read(organizerEventsProvider.notifier).saveZonePricing(id, zoneData);

    if (mounted) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ok ? 'Pricing saved' : 'Failed to save pricing')),
      );
    }
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
                          child: const Icon(Icons.arrow_back_rounded, color: _textPrimary, size: 24),
                        ),
                        const SizedBox(width: 12),
                        const Text('Pricing Setup', style: TextStyle(color: _textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
                      ],
                    ),
                    GestureDetector(
                      onTap: _isSaving ? null : _save,
                      child: Text(_isSaving ? 'Saving...' : 'SAVE',
                          style: const TextStyle(color: _purpleLight, fontSize: 13, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text('ZONE CONFIGURATION',
                    style: TextStyle(color: _textSecondary, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8)),
              ),
              const SizedBox(height: 14),

              // ── Zone Cards ────────────────────────────────────────────
              ...List.generate(_zones.length, (i) {
                final zone = _zones[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: _bgCard,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(width: 12, height: 12, decoration: BoxDecoration(color: zone.color, shape: BoxShape.circle)),
                            const SizedBox(width: 8),
                            Text(zone.name, style: const TextStyle(color: _textPrimary, fontSize: 14, fontWeight: FontWeight.w700)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text('Price (LKR)', style: TextStyle(color: _textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        _PriceInputField(controller: zone.price),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 28),

              // ── Save Button ──────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: GestureDetector(
                  onTap: _isSaving ? null : _save,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: const LinearGradient(colors: [_gradStart, _gradEnd]),
                    ),
                    child: Center(
                      child: _isSaving
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: _textPrimary, strokeWidth: 2))
                          : const Text('Save Pricing', style: TextStyle(color: _textPrimary, fontSize: 15, fontWeight: FontWeight.w700)),
                    ),
                  ),
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

// ── Zone Entry model ─────────────────────────────────────────────────────────
class _ZoneEntry {
  final String name;
  final TextEditingController price;
  final Color color;

  _ZoneEntry({required this.name, required this.price, required this.color});
}

// ── Price Input Field ────────────────────────────────────────────────────────
class _PriceInputField extends StatefulWidget {
  final TextEditingController controller;
  const _PriceInputField({required this.controller});

  @override
  State<_PriceInputField> createState() => _PriceInputFieldState();
}

class _PriceInputFieldState extends State<_PriceInputField> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _focused = true),
      onExit: (_) => setState(() => _focused = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _focused ? _purple.withValues(alpha: 0.4) : Colors.white.withValues(alpha: 0.1),
            width: 1.5,
          ),
        ),
        child: TextField(
          controller: widget.controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: _textPrimary, fontSize: 14, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            hintText: '0.00',
            hintStyle: TextStyle(color: _textSecondary.withValues(alpha: 0.3), fontSize: 14),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 12, right: 8),
              child: Center(
                widthFactor: 1,
                child: Text(
                  'LKR',
                  style: TextStyle(
                    color: _textSecondary.withValues(alpha: 0.6),
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
