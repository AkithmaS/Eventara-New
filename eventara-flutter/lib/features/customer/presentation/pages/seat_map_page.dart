import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:eventara/core/router/app_routes.dart';
import 'package:eventara/core/network/api_endpoints.dart';
import 'package:eventara/core/network/dio_client.dart';
import '../providers/booking_notifier.dart';

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

// Seat model
class SeatModel {
  final int id;
  final int eventId;
  final String rowLabel;
  final int seatNumber;
  final String status; // AVAILABLE, LOCKED, BOOKED, BLOCKED
  final int? zoneId;

  SeatModel({
    required this.id,
    required this.eventId,
    required this.rowLabel,
    required this.seatNumber,
    required this.status,
    this.zoneId,
  });

  factory SeatModel.fromJson(Map<String, dynamic> json) {
    return SeatModel(
      id: json['id'] as int,
      eventId: json['eventId'] as int,
      rowLabel: json['rowLabel'] as String,
      seatNumber: json['seatNumber'] as int,
      status: json['status'] as String,
      zoneId: json['zoneId'] as int?,
    );
  }

  String get seatLabel => '$rowLabel$seatNumber';
}

// Provider to fetch seats
final seatsProvider = FutureProvider.family<List<SeatModel>, String>((ref, eventId) async {
  final dio = DioClient.instance.dio;
  final endpoint = ApiEndpoints.seatMap(eventId);
  
  try {
    final response = await dio.get(endpoint);
    if (response.statusCode == 200) {
      final data = response.data as Map<String, dynamic>;
      final seatsList = (data['data'] as List<dynamic>)
          .map((e) => SeatModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return seatsList;
    }
    throw Exception('Failed to fetch seats');
  } catch (e) {
    throw Exception('Error fetching seats: $e');
  }
});

class SeatMapPage extends ConsumerStatefulWidget {
  final String eventId;

  const SeatMapPage({
    super.key,
    required this.eventId,
  });

  @override
  ConsumerState<SeatMapPage> createState() => _SeatMapPageState();
}

class _SeatMapPageState extends ConsumerState<SeatMapPage> {
  final List<int> _selectedSeatIds = []; // Store seat IDs
  final List<String> _selectedSeatLabels = []; // Store for display
  double _totalPrice = 0.0;

  @override
  Widget build(BuildContext context) {
    final seatsAsync = ref.watch(seatsProvider(widget.eventId));

    return Scaffold(
      backgroundColor: _bgDeep,
      body: seatsAsync.when(
        loading: () => const Scaffold(
          backgroundColor: _bgDeep,
          body: Center(
            child: CircularProgressIndicator(
              color: _purple,
            ),
          ),
        ),
        error: (err, stack) => Scaffold(
          backgroundColor: _bgDeep,
          body: Center(
            child: Text(
              'Error loading seats: $err',
              style: const TextStyle(color: _textPrimary),
            ),
          ),
        ),
        data: (seats) {
          // Group seats by row
          final seatsByRow = <String, List<SeatModel>>{};
          for (var seat in seats) {
            seatsByRow.putIfAbsent(seat.rowLabel, () => []).add(seat);
          }
          
          // Sort rows and seats
          final sortedRows = seatsByRow.keys.toList()..sort();
          for (var row in sortedRows) {
            seatsByRow[row]!.sort((a, b) => a.seatNumber.compareTo(b.seatNumber));
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header with Back Button ──────────────────────────────
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            context.go(AppRoutes.buildCustomerEventDetail(widget.eventId));
                          },
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
                    children: sortedRows.map((rowLabel) {
                      final rowSeats = seatsByRow[rowLabel]!;

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
                            ...rowSeats.map((seat) {
                              final isSelected = _selectedSeatIds.contains(seat.id);
                              final canSelect = seat.status == 'AVAILABLE' && !isSelected;

                              return GestureDetector(
                                onTap: canSelect || isSelected
                                    ? () => _toggleSeatSelection(seat)
                                    : null,
                                child: _SeatWidget(
                                  status: seat.status,
                                  label: seat.seatLabel,
                                  isSelected: isSelected,
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 40),
                // ── Selection Info Card ──────────────────────────────────
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
                                  'Selected: ${_selectedSeatLabels.join(', ')}',
                                  style: const TextStyle(
                                    color: _textPrimary,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'LKR ${_totalPrice.toStringAsFixed(2)} total',
                                  style: const TextStyle(
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
          );
        },
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
                      '${_selectedSeatIds.length} seats',
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
                  onTap: () async {
                    if (_selectedSeatIds.isEmpty) return;
                    final eventId = int.tryParse(widget.eventId) ?? 0;
                    
                    try {
                      await ref
                          .read(bookingNotifierProvider.notifier)
                          .createBooking(
                            eventId: eventId,
                            seatIds: _selectedSeatIds,
                          );
                      
                      if (mounted) {
                        context.go(AppRoutes.buildCustomerPayment(widget.eventId));
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $e')),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _toggleSeatSelection(SeatModel seat) {
    setState(() {
      if (_selectedSeatIds.contains(seat.id)) {
        _selectedSeatIds.remove(seat.id);
        _selectedSeatLabels.remove(seat.seatLabel);
      } else {
        if (_selectedSeatIds.length < 6) {
          _selectedSeatIds.add(seat.id);
          _selectedSeatLabels.add(seat.seatLabel);
        }
      }
      // TODO: Calculate price based on zone - for now use placeholder
      _totalPrice = _selectedSeatIds.length * 300.0;
    });
  }
}

/// Individual seat widget
class _SeatWidget extends StatelessWidget {
  final String status; // AVAILABLE, LOCKED, BOOKED, BLOCKED
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
      case 'AVAILABLE':
        seatColor = isSelected ? _accentGreen : _purple;
        break;
      case 'LOCKED':
        seatColor = Colors.yellow.shade700;
        break;
      case 'BOOKED':
        seatColor = _accentRed;
        break;
      case 'BLOCKED':
        seatColor = Colors.grey;
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
      child: status == 'BOOKED' // Show X for booked seats
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
