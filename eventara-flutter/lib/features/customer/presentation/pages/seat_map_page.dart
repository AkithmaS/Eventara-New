import 'package:flutter/material.dart';

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
const _accentRed = Color(0xFFFF6B6B);

class SeatMapPage extends StatefulWidget {
  final String eventId;

  const SeatMapPage({
    super.key,
    required this.eventId,
  });

  @override
  State<SeatMapPage> createState() => _SeatMapPageState();
}

class _SeatMapPageState extends State<SeatMapPage> {
  // Seat grid data: rows A-E, columns 1-9
  // 0 = available, 1 = locked, 2 = booked, 3 = selected
  final Map<String, List<int>> _seatGrid = {
    'A': [3, 3, 0, 3, 3, 0, 3, 3, 0],
    'B': [3, 3, 3, 2, 2, 3, 3, 3, 3],
    'C': [3, 3, 3, 3, 3, 3, 3, 3, 3],
    'D': [3, 3, 3, 3, 3, 3, 3, 3, 3],
    'E': [3, 3, 3, 3, 3, 3, 3, 3, 3],
  };

  final List<String> _selectedSeats = ['B12', 'B13'];
  final double _totalPrice = 300.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgDeep,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header with Back Button ──────────────────────────────────
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _bgCard,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.arrow_back_rounded,
                            color: _textPrimary,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Select Your Seat',
                          style: TextStyle(
                            color: _textPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Neon Jungle Festival',
                          style: TextStyle(
                            color: _textSecondary,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // ── Stage Label ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _purple.withValues(alpha: 0.3),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'S T A G E',
                    style: TextStyle(
                      color: _textSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 48),
            // ── Seat Grid ────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: _seatGrid.entries.map((rowEntry) {
                  final rowLabel = rowEntry.key;
                  final rowSeats = rowEntry.value;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Row label
                        Text(
                          rowLabel,
                          style: const TextStyle(
                            color: _textSecondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                        // Seats
                        ...List.generate(
                          rowSeats.length,
                          (colIndex) {
                            final seatStatus = rowSeats[colIndex];
                            final seatLabel = '$rowLabel${colIndex + 1}';

                            return GestureDetector(
                              onTap: seatStatus == 0 || seatStatus == 3
                                  ? () => _toggleSeatSelection(seatLabel)
                                  : null,
                              child: _SeatWidget(
                                status: seatStatus,
                                label: seatLabel,
                                isSelected: seatStatus == 3,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 40),
            // ── Selection Info Card ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _bgCard,
                  borderRadius: BorderRadius.circular(16),
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Selected: ${_selectedSeats.join(', ')}',
                              style: const TextStyle(
                                color: _textPrimary,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Zone A • LKR 300 total',
                              style: TextStyle(
                                color: _textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _purple.withValues(alpha: 0.3),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.add_rounded,
                              color: _purpleLight,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(color: Colors.white12, height: 12),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(
                          Icons.zoom_out_map_rounded,
                          color: _textSecondary,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Pinch to zoom for better view',
                            style: TextStyle(
                              color: _textSecondary.withValues(alpha: 0.7),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.info_outline_rounded,
                          color: _textSecondary,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Max 6 seats per booking',
                            style: TextStyle(
                              color: _textSecondary.withValues(alpha: 0.7),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      // ── Bottom Action Bar ────────────────────────────────────────────
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: _bgCard,
          border: Border(
            top: BorderSide(
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${_selectedSeats.length} seats',
                      style: TextStyle(
                        color: _textSecondary.withValues(alpha: 0.6),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'LKR ${_totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: _textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                // Proceed to Checkout button
                _ProceedButton(
                  onTap: () {
                    // TODO: Navigate to checkout
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _toggleSeatSelection(String seatLabel) {
    setState(() {
      if (_selectedSeats.contains(seatLabel)) {
        _selectedSeats.remove(seatLabel);
      } else {
        if (_selectedSeats.length < 6) {
          _selectedSeats.add(seatLabel);
        }
      }
    });
  }
}

/// Individual seat widget
class _SeatWidget extends StatelessWidget {
  final int status; // 0=available, 1=locked, 2=booked, 3=selected
  final String label;
  final bool isSelected;

  const _SeatWidget({
    required this.status,
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    Color seatColor;
    double seatSize = 24;

    switch (status) {
      case 0: // Available
        seatColor = _purple;
        break;
      case 1: // Locked
        seatColor = Colors.yellow.shade700;
        break;
      case 2: // Booked
        seatColor = _accentRed;
        break;
      case 3: // Selected or selectable
        seatColor = isSelected ? _accentGreen : _purple;
        break;
      default:
        seatColor = _purple;
    }

    return Container(
      width: seatSize,
      height: seatSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: seatColor,
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: _accentGreen.withValues(alpha: 0.5),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: status == 2 // Show X for booked seats
          ? const Center(
              child: Icon(
                Icons.close_rounded,
                color: _textPrimary,
                size: 12,
              ),
            )
          : null,
    );
  }
}

/// Proceed to Checkout button
class _ProceedButton extends StatefulWidget {
  final VoidCallback onTap;

  const _ProceedButton({required this.onTap});

  @override
  State<_ProceedButton> createState() => _ProceedButtonState();
}

class _ProceedButtonState extends State<_ProceedButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                colors: [_gradStart, _gradEnd],
              ),
              boxShadow: [
                BoxShadow(
                  color: _purple.withValues(alpha: 0.5),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Text(
              'Proceed to Checkout',
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
    );
  }
}
