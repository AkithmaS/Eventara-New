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
const _accentGray = Color(0xFF3A3847);

class SeatMapEditorPage extends StatefulWidget {
  final String eventId;

  const SeatMapEditorPage({super.key, required this.eventId});

  @override
  State<SeatMapEditorPage> createState() => _SeatMapEditorPageState();
}

class _SeatMapEditorPageState extends State<SeatMapEditorPage> {
  // Seat grid: 4 rows (A-D), 7 columns
  // 0 = empty, 1 = available, 2 = premium, 3 = standard, 4 = economy, 5 = blocked
  late Map<String, List<int>> _seatGrid;
  late Map<String, Set<String>> _selectedSeats;
  String _currentZone = 'premium';

  @override
  void initState() {
    super.initState();
    _initializeSeatGrid();
    _selectedSeats = {
      'premium': {'A3'},
      'standard': {'B1', 'B2', 'B3', 'B4', 'B5', 'B6', 'B7'},
      'economy': {'C1', 'C2', 'C3', 'C4', 'C5', 'C6', 'C7'},
    };
  }

  void _initializeSeatGrid() {
    _seatGrid = {
      'A': [1, 1, 1, 1, 1, 0, 0],
      'B': [1, 1, 1, 1, 1, 1, 1],
      'C': [1, 1, 1, 1, 1, 1, 1],
      'D': [0, 0, 0, 0, 0, 0, 0],
    };
  }

  int _getTotalSeats() {
    int total = 0;
    _selectedSeats.forEach((zone, seats) {
      total += seats.length;
    });
    return total;
  }

  int _getZoneCount(String zone) => _selectedSeats[zone]?.length ?? 0;

  void _toggleSeat(String row, int col) {
    final seatId = '$row${col + 1}';
    setState(() {
      if (_selectedSeats[_currentZone]!.contains(seatId)) {
        _selectedSeats[_currentZone]!.remove(seatId);
      } else {
        _selectedSeats[_currentZone]!.add(seatId);
      }
    });
  }

  void _addRow() {
    // Add a new row
  }

  void _removeRow() {
    // Remove a row
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
                          'Seat Map Editor',
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
                        // Save seat map
                      },
                      child: const Text(
                        'Save',
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
              const SizedBox(height: 24),

              // ── Stage Label ──────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _purpleLight.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
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
              const SizedBox(height: 24),

              // ── Seat Editor Controls ─────────────────────────────────
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Add/Remove row buttons
                      Row(
                        children: [
                          _IconButton(
                            icon: Icons.add_rounded,
                            onTap: _addRow,
                          ),
                          const SizedBox(width: 12),
                          _IconButton(
                            icon: Icons.remove_rounded,
                            onTap: _removeRow,
                          ),
                        ],
                      ),
                      // Pan to view all
                      Text(
                        'PAN TO VIEW ALL',
                        style: TextStyle(
                          color: _textSecondary.withValues(alpha: 0.6),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      // Grid layout buttons
                      Row(
                        children: [
                          _IconButton(
                            icon: Icons.grid_3x3_rounded,
                            onTap: () {},
                          ),
                          const SizedBox(width: 12),
                          _IconButton(
                            icon: Icons.grid_4x4_rounded,
                            onTap: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ── Seat Grid ───────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _bgCard,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Column(
                    children: _seatGrid.entries.map((rowEntry) {
                      final row = rowEntry.key;
                      final seats = rowEntry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          children: [
                            // Row label
                            SizedBox(
                              width: 30,
                              child: Text(
                                row,
                                style: const TextStyle(
                                  color: _textSecondary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Seats
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: List.generate(seats.length, (colIndex) {
                                  final seatStatus = seats[colIndex];
                                  final seatId = '$row${colIndex + 1}';
                                  final zone = _getZoneForSeat(seatId);
                                  final isSelected = _selectedSeats[_currentZone]!.contains(seatId);

                                  return GestureDetector(
                                    onTap: seatStatus == 1
                                        ? () => _toggleSeat(row, colIndex)
                                        : null,
                                    child: _SeatWidget(
                                      seatStatus: seatStatus,
                                      zone: zone,
                                      isSelected: isSelected,
                                      label: '${colIndex + 1}',
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // ── Assign Zone Section ──────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Assign Zone',
                      style: TextStyle(
                        color: _textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _ZoneButton(
                          label: 'Premium',
                          color: _purple,
                          isSelected: _currentZone == 'premium',
                          onTap: () => setState(() => _currentZone = 'premium'),
                        ),
                        const SizedBox(width: 12),
                        _ZoneButton(
                          label: 'Standard',
                          color: _accentBlue,
                          isSelected: _currentZone == 'standard',
                          onTap: () => setState(() => _currentZone = 'standard'),
                        ),
                        const SizedBox(width: 12),
                        _ZoneButton(
                          label: 'Economy',
                          color: _accentGreen,
                          isSelected: _currentZone == 'economy',
                          onTap: () => setState(() => _currentZone = 'economy'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Zone Legend ──────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(16),
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
                      Text(
                        'ZONE LEGEND',
                        style: TextStyle(
                          color: _textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _LegendRow(
                        color: _purple,
                        label: 'Premium',
                        count: _getZoneCount('premium'),
                      ),
                      const SizedBox(height: 10),
                      _LegendRow(
                        color: _accentBlue,
                        label: 'Standard',
                        count: _getZoneCount('standard'),
                      ),
                      const SizedBox(height: 10),
                      _LegendRow(
                        color: _accentGreen,
                        label: 'Economy',
                        count: _getZoneCount('economy'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ── Capacity & Save ─────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CAPACITY',
                          style: TextStyle(
                            color: _textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${_getTotalSeats()} Seats',
                          style: const TextStyle(
                            color: _textPrimary,
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Save button
                    GestureDetector(
                      onTap: () {
                        // Save seat map
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: const LinearGradient(
                            colors: [_gradStart, _gradEnd],
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'Save Seat Map',
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

  String? _getZoneForSeat(String seatId) {
    for (var zone in _selectedSeats.entries) {
      if (zone.value.contains(seatId)) {
        return zone.key;
      }
    }
    return null;
  }
}

// ── Icon Button widget ───────────────────────────────────────────────────────
class _IconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconButton({required this.icon, required this.onTap});

  @override
  State<_IconButton> createState() => _IconButtonState();
}

class _IconButtonState extends State<_IconButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: _hovered ? _accentGray.withValues(alpha: 0.8) : _accentGray,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
            ),
          ),
          child: Center(
            child: Icon(
              widget.icon,
              color: _textSecondary,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Seat Widget ──────────────────────────────────────────────────────────────
class _SeatWidget extends StatelessWidget {
  final int seatStatus; // 0 = empty, 1 = available, 5 = blocked
  final String? zone;
  final bool isSelected;
  final String label;

  const _SeatWidget({
    required this.seatStatus,
    required this.zone,
    required this.isSelected,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    late Color seatColor;
    late double size;

    if (seatStatus == 0) {
      seatColor = Colors.transparent;
      size = 0;
      return const SizedBox.shrink();
    } else if (seatStatus == 5) {
      seatColor = _accentGray;
      size = 28;
    } else if (isSelected) {
      switch (zone) {
        case 'premium':
          seatColor = _purple;
          break;
        case 'standard':
          seatColor = _accentBlue;
          break;
        case 'economy':
          seatColor = _accentGreen;
          break;
        default:
          seatColor = _accentGray;
      }
      size = 28;
    } else {
      seatColor = _accentGray.withValues(alpha: 0.4);
      size = 28;
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: seatColor,
        borderRadius: BorderRadius.circular(6),
        border: isSelected
            ? Border.all(
                color: seatColor,
                width: 2,
              )
            : null,
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: seatColor.withValues(alpha: 0.4),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: seatStatus == 0
                ? Colors.transparent
                : isSelected
                    ? Colors.white
                    : _textSecondary.withValues(alpha: 0.5),
            fontSize: 9,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

// ── Zone Button widget ───────────────────────────────────────────────────────
class _ZoneButton extends StatefulWidget {
  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _ZoneButton({
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_ZoneButton> createState() => _ZoneButtonState();
}

class _ZoneButtonState extends State<_ZoneButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: widget.isSelected
                  ? widget.color
                  : widget.color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              border: widget.isSelected
                  ? null
                  : Border.all(
                      color: widget.color.withValues(alpha: 0.3),
                    ),
            ),
            child: Text(
              widget.label,
              style: TextStyle(
                color: widget.isSelected ? Colors.white : widget.color,
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

// ── Legend Row widget ────────────────────────────────────────────────────────
class _LegendRow extends StatelessWidget {
  final Color color;
  final String label;
  final int count;

  const _LegendRow({
    required this.color,
    required this.label,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(
            color: _textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        Text(
          '$count seats',
          style: const TextStyle(
            color: _textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
