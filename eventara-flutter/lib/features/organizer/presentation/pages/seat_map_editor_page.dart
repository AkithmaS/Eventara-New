import 'dart:convert';
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
const _accentGray = Color(0xFF3A3847);

class SeatMapEditorPage extends ConsumerStatefulWidget {
  final String eventId;

  const SeatMapEditorPage({super.key, required this.eventId});

  @override
  ConsumerState<SeatMapEditorPage> createState() => _SeatMapEditorPageState();
}

class _SeatMapEditorPageState extends ConsumerState<SeatMapEditorPage> {
  late Map<String, List<int>> _seatGrid;
  late Map<String, Set<String>> _selectedSeats;
  String _currentZone = 'premium';
  bool _isSaving = false;

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
    _selectedSeats.forEach((zone, seats) { total += seats.length; });
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

  String? _getZoneForSeat(String seatId) {
    for (var zone in _selectedSeats.entries) {
      if (zone.value.contains(seatId)) return zone.key;
    }
    return null;
  }

  Future<void> _saveSeatMap() async {
    setState(() => _isSaving = true);
    final id = int.tryParse(widget.eventId);
    if (id == null) { setState(() => _isSaving = false); return; }

    // Build JSON: { rows: [{ row, seats: [{ col, zone }] }] }
    final seatData = <Map<String, dynamic>>[];
    _seatGrid.forEach((row, seats) {
      for (int col = 0; col < seats.length; col++) {
        if (seats[col] == 1) {
          final seatId = '$row${col + 1}';
          final zone = _getZoneForSeat(seatId);
          seatData.add({
            'rowLabel': row,
            'seatNumber': col + 1,
            'zone': zone,
            'status': 'AVAILABLE',
          });
        }
      }
    });

    final json = jsonEncode({'seats': seatData});
    final ok = await ref.read(organizerEventsProvider.notifier).saveSeatMap(id, json);

    if (mounted) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ok ? 'Seat map saved' : 'Failed to save seat map')),
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
                        const Text('Seat Map Editor', style: TextStyle(color: _textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
                      ],
                    ),
                    GestureDetector(
                      onTap: _isSaving ? null : _saveSeatMap,
                      child: Text(_isSaving ? 'Saving...' : 'Save',
                          style: const TextStyle(color: _purpleLight, fontSize: 13, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Stage ──────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _purpleLight.withValues(alpha: 0.3), width: 1.5),
                  ),
                  child: const Center(
                    child: Text('S T A G E', style: TextStyle(color: _textSecondary, fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 2.0)),
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
                    border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                  ),
                  child: Column(
                    children: _seatGrid.entries.map((rowEntry) {
                      final row = rowEntry.key;
                      final seats = rowEntry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          children: [
                            SizedBox(width: 30, child: Text(row, style: const TextStyle(color: _textSecondary, fontSize: 14, fontWeight: FontWeight.w700))),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: List.generate(seats.length, (colIndex) {
                                  final seatStatus = seats[colIndex];
                                  final seatId = '$row${colIndex + 1}';
                                  final zone = _getZoneForSeat(seatId);
                                  final isSelected = _selectedSeats[_currentZone]!.contains(seatId);
                                  return GestureDetector(
                                    onTap: seatStatus == 1 ? () => _toggleSeat(row, colIndex) : null,
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

              // ── Assign Zone ──────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Assign Zone', style: TextStyle(color: _textPrimary, fontSize: 15, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _ZoneButton(label: 'Premium', color: _purple, isSelected: _currentZone == 'premium', onTap: () => setState(() => _currentZone = 'premium')),
                        const SizedBox(width: 12),
                        _ZoneButton(label: 'Standard', color: _accentBlue, isSelected: _currentZone == 'standard', onTap: () => setState(() => _currentZone = 'standard')),
                        const SizedBox(width: 12),
                        _ZoneButton(label: 'Economy', color: _accentGreen, isSelected: _currentZone == 'economy', onTap: () => setState(() => _currentZone = 'economy')),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Legend ────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _bgCard,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ZONE LEGEND', style: TextStyle(color: _textSecondary, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                      const SizedBox(height: 12),
                      _LegendRow(color: _purple, label: 'Premium', count: _getZoneCount('premium')),
                      const SizedBox(height: 10),
                      _LegendRow(color: _accentBlue, label: 'Standard', count: _getZoneCount('standard')),
                      const SizedBox(height: 10),
                      _LegendRow(color: _accentGreen, label: 'Economy', count: _getZoneCount('economy')),
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
                    Text('CAPACITY', style: TextStyle(color: _textSecondary, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                    const SizedBox(height: 8),
                    Text('${_getTotalSeats()} Seats', style: const TextStyle(color: _textPrimary, fontSize: 28, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: _isSaving ? null : _saveSeatMap,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: const LinearGradient(colors: [_gradStart, _gradEnd]),
                        ),
                        child: Center(
                          child: _isSaving
                              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: _textPrimary, strokeWidth: 2))
                              : const Text('Save Seat Map', style: TextStyle(color: _textPrimary, fontSize: 15, fontWeight: FontWeight.w700)),
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

// ── Seat Widget ──────────────────────────────────────────────────────────────
class _SeatWidget extends StatelessWidget {
  final int seatStatus;
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
    if (seatStatus == 0) return const SizedBox.shrink();

    Color seatColor;
    if (seatStatus == 5) {
      seatColor = _accentGray;
    } else if (isSelected) {
      switch (zone) {
        case 'premium': seatColor = _purple; break;
        case 'standard': seatColor = _accentBlue; break;
        case 'economy': seatColor = _accentGreen; break;
        default: seatColor = _accentGray;
      }
    } else {
      seatColor = _accentGray.withValues(alpha: 0.4);
    }

    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: seatColor,
        borderRadius: BorderRadius.circular(6),
        boxShadow: isSelected ? [BoxShadow(color: seatColor.withValues(alpha: 0.4), blurRadius: 8, spreadRadius: 1)] : null,
      ),
      child: Center(
        child: Text(label,
            style: TextStyle(
                color: isSelected ? Colors.white : _textSecondary.withValues(alpha: 0.5),
                fontSize: 9,
                fontWeight: FontWeight.w700)),
      ),
    );
  }
}

// ── Zone Button ───────────────────────────────────────────────────────────────
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
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: widget.isSelected ? widget.color : widget.color.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
          border: widget.isSelected ? null : Border.all(color: widget.color.withValues(alpha: 0.3)),
        ),
        child: Text(widget.label,
            style: TextStyle(
                color: widget.isSelected ? Colors.white : widget.color,
                fontSize: 13,
                fontWeight: FontWeight.w700)),
      ),
    );
  }
}

// ── Legend Row ────────────────────────────────────────────────────────────────
class _LegendRow extends StatelessWidget {
  final Color color;
  final String label;
  final int count;

  const _LegendRow({required this.color, required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 10),
        Text(label, style: const TextStyle(color: _textSecondary, fontSize: 13, fontWeight: FontWeight.w600)),
        const Spacer(),
        Text('$count seats', style: const TextStyle(color: _textPrimary, fontSize: 13, fontWeight: FontWeight.w700)),
      ],
    );
  }
}
