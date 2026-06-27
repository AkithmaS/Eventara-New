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
const _accentGreen = Color(0xFF4ECB71);

class PricingSetupPage extends StatefulWidget {
  final String eventId;

  const PricingSetupPage({super.key, required this.eventId});

  @override
  State<PricingSetupPage> createState() => _PricingSetupPageState();
}

class _PricingSetupPageState extends State<PricingSetupPage> {
  // Premium zone
  final _premiumPriceCtrl = TextEditingController(text: '5000');
  bool _premiumEarlyBird = false;
  final _premiumEarlyCtrl = TextEditingController();

  // Standard zone
  final _standardPriceCtrl = TextEditingController(text: '3500');
  bool _standardEarlyBird = true;
  final _standardEarlyCtrl = TextEditingController(text: '2800');

  // Economy zone
  final _economyPriceCtrl = TextEditingController(text: '2000');
  bool _economyEarlyBird = false;
  final _economyEarlyCtrl = TextEditingController();

  @override
  void dispose() {
    _premiumPriceCtrl.dispose();
    _premiumEarlyCtrl.dispose();
    _standardPriceCtrl.dispose();
    _standardEarlyCtrl.dispose();
    _economyPriceCtrl.dispose();
    _economyEarlyCtrl.dispose();
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
                          'Pricing Setup',
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
                        // Save pricing
                      },
                      child: const Text(
                        'SAVE',
                        style: TextStyle(
                          color: _purpleLight,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Active Event Card ────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _bgCard,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Event image
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              _purple.withValues(alpha: 0.2),
                              _gradEnd.withValues(alpha: 0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.music_note_rounded,
                          color: _purple.withValues(alpha: 0.3),
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Event details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ACTIVE EVENT',
                              style: TextStyle(
                                color: _textSecondary,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Neon Nights Music Fest',
                              style: TextStyle(
                                color: _textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // ── Zone Configuration ──────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'ZONE CONFIGURATION',
                  style: TextStyle(
                    color: _textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // ── Premium Zone Card ───────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _ZonePricingCard(
                  zoneColor: _purple,
                  zoneName: 'Premium Zone',
                  seatCount: 24,
                  priceController: _premiumPriceCtrl,
                  enableEarlyBird: _premiumEarlyBird,
                  onEarlyBirdToggle: (value) {
                    setState(() => _premiumEarlyBird = value);
                  },
                  earlyBirdController: _premiumEarlyCtrl,
                  earlyBirdInfo: 'Enable discounted pre-sale rates',
                ),
              ),
              const SizedBox(height: 16),

              // ── Standard Zone Card ──────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _ZonePricingCard(
                  zoneColor: _accentBlue,
                  zoneName: 'Standard Zone',
                  seatCount: 48,
                  priceController: _standardPriceCtrl,
                  enableEarlyBird: _standardEarlyBird,
                  onEarlyBirdToggle: (value) {
                    setState(() => _standardEarlyBird = value);
                  },
                  earlyBirdController: _standardEarlyCtrl,
                  earlyBirdInfo: 'Active for first 10 tickets',
                ),
              ),
              const SizedBox(height: 16),

              // ── Economy Zone Card ───────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _ZonePricingCard(
                  zoneColor: _accentGreen,
                  zoneName: 'Economy Zone',
                  seatCount: 32,
                  priceController: _economyPriceCtrl,
                  enableEarlyBird: _economyEarlyBird,
                  onEarlyBirdToggle: (value) {
                    setState(() => _economyEarlyBird = value);
                  },
                  earlyBirdController: _economyEarlyCtrl,
                  earlyBirdInfo: 'Enable discounted pre-sale rates',
                ),
              ),
              const SizedBox(height: 28),

              // ── Price Summary ───────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _bgCard.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PRICE SUMMARY',
                        style: TextStyle(
                          color: _textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _SummaryRow(
                        label: 'Premium (24 seats)',
                        price: 'LKR ${_premiumPriceCtrl.text}',
                      ),
                      const SizedBox(height: 8),
                      _SummaryRow(
                        label: 'Standard (48 seats)',
                        price: 'LKR ${_standardPriceCtrl.text}',
                      ),
                      const SizedBox(height: 8),
                      _SummaryRow(
                        label: 'Economy (32 seats)',
                        price: 'LKR ${_economyPriceCtrl.text}',
                      ),
                      const SizedBox(height: 12),
                      Divider(
                        color: Colors.white.withValues(alpha: 0.1),
                        height: 1,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Revenue Potential',
                            style: TextStyle(
                              color: _textPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'LKR ${_calculateTotal()}',
                            style: const TextStyle(
                              color: _purpleLight,
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // ── Save Button ──────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: GestureDetector(
                  onTap: () {
                    // Save pricing configuration
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: const LinearGradient(
                        colors: [_gradStart, _gradEnd],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _purple.withValues(alpha: 0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'Save Pricing',
                        style: TextStyle(
                          color: _textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
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

  String _calculateTotal() {
    int premium = int.tryParse(_premiumPriceCtrl.text) ?? 0;
    int standard = int.tryParse(_standardPriceCtrl.text) ?? 0;
    int economy = int.tryParse(_economyPriceCtrl.text) ?? 0;
    int total = (premium * 24) + (standard * 48) + (economy * 32);
    return total.toString();
  }
}

// ── Zone Pricing Card widget ────────────────────────────────────────────────
class _ZonePricingCard extends StatelessWidget {
  final Color zoneColor;
  final String zoneName;
  final int seatCount;
  final TextEditingController priceController;
  final bool enableEarlyBird;
  final Function(bool) onEarlyBirdToggle;
  final TextEditingController earlyBirdController;
  final String earlyBirdInfo;

  const _ZonePricingCard({
    required this.zoneColor,
    required this.zoneName,
    required this.seatCount,
    required this.priceController,
    required this.enableEarlyBird,
    required this.onEarlyBirdToggle,
    required this.earlyBirdController,
    required this.earlyBirdInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          // Zone header
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: zoneColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  zoneName,
                  style: const TextStyle(
                    color: _textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: zoneColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '$seatCount seats',
                  style: TextStyle(
                    color: zoneColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Standard price
          _PriceLabel('Standard Price (LKR)'),
          const SizedBox(height: 8),
          _PriceInputField(controller: priceController),
          const SizedBox(height: 14),

          // Early bird toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Early Bird Discount',
                    style: TextStyle(
                      color: _textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    earlyBirdInfo,
                    style: TextStyle(
                      color: _textSecondary.withValues(alpha: 0.7),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              Switch(
                value: enableEarlyBird,
                onChanged: onEarlyBirdToggle,
                activeColor: zoneColor,
                activeTrackColor: zoneColor.withValues(alpha: 0.3),
                inactiveThumbColor: _textSecondary.withValues(alpha: 0.5),
                inactiveTrackColor: Colors.white.withValues(alpha: 0.1),
              ),
            ],
          ),

          // Early bird price (shown when enabled)
          if (enableEarlyBird) ...[
            const SizedBox(height: 14),
            _PriceLabel('Early Bird Price (LKR)'),
            const SizedBox(height: 8),
            _PriceInputField(controller: earlyBirdController),
          ],
        ],
      ),
    );
  }
}

// ── Price Label widget ───────────────────────────────────────────────────────
class _PriceLabel extends StatelessWidget {
  final String label;

  const _PriceLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: _textSecondary,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

// ── Price Input Field widget ────────────────────────────────────────────────
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
            color: _focused
                ? _purple.withValues(alpha: 0.4)
                : Colors.white.withValues(alpha: 0.1),
            width: 1.5,
          ),
        ),
        child: TextField(
          controller: widget.controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(
            color: _textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: '0.00',
            hintStyle: TextStyle(
              color: _textSecondary.withValues(alpha: 0.3),
              fontSize: 14,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 12, right: 8),
              child: Icon(
                Icons.attach_money_rounded,
                color: _textSecondary.withValues(alpha: 0.6),
                size: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Summary Row widget ───────────────────────────────────────────────────────
class _SummaryRow extends StatelessWidget {
  final String label;
  final String price;

  const _SummaryRow({required this.label, required this.price});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: _textSecondary.withValues(alpha: 0.8),
            fontSize: 12,
          ),
        ),
        Text(
          price,
          style: const TextStyle(
            color: _textPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
