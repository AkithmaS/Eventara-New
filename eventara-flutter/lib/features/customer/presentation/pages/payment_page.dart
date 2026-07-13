import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:eventara/core/router/app_routes.dart';
import '../../data/repositories/event_repository_impl.dart';
import '../../domain/entities/event_entity.dart';
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
const _accentOrange = Color(0xFFD97744);

// ─── Provider for event detail ────────────────────────────────────────────

final _paymentEventProvider =
    FutureProvider.family<EventEntity, int>((ref, id) async {
  final repo = EventRepositoryImpl();
  return repo.getEventById(id);
});

class PaymentPage extends ConsumerStatefulWidget {
  final String eventId;

  const PaymentPage({
    super.key,
    required this.eventId,
  });

  @override
  ConsumerState<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends ConsumerState<PaymentPage> {
  late Timer _countdownTimer;
  int _remainingSeconds = 268; // 4:28 in seconds
  int _quantity = 1;

  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cardholderController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _countdownTimer.cancel();
        }
      });
    });
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _countdownTimer.cancel();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cardholderController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final id = int.tryParse(widget.eventId) ?? 0;
    final asyncEvent = ref.watch(_paymentEventProvider(id));

    return asyncEvent.when(
      loading: () => Scaffold(
        backgroundColor: _bgDeep,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: _purpleLight),
              const SizedBox(height: 16),
              Text(
                'Loading payment details...',
                style: TextStyle(color: _textSecondary),
              ),
            ],
          ),
        ),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: _bgDeep,
        appBar: AppBar(
          backgroundColor: _bgDeep,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: _textPrimary),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 48,
                  color: _accentOrange,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Unable to load event',
                  style: TextStyle(
                    color: _textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  e.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => ref.refresh(_paymentEventProvider(id)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _purple,
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
      data: (event) => _buildPaymentPage(context, event),
    );
  }

  Widget _buildPaymentPage(BuildContext context, EventEntity event) {
    final subtotal = event.ticketPrice * _quantity;
    final serviceFee = subtotal * 0.05; // 5% service fee
    final total = subtotal + serviceFee;
    
    return Scaffold(
      backgroundColor: _bgDeep,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────────
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        final eventId = widget.eventId;
                        context.go(AppRoutes.buildCustomerEventDetail(eventId));
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
                    const Text(
                      'Checkout',
                      style: TextStyle(
                        color: _textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // ── Countdown Timer (only for seated events) ────────────────
            if (event.isSeated)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: _accentOrange.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _accentOrange.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        color: _accentOrange,
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Seats reserved for ${_formatTime(_remainingSeconds)}',
                          style: const TextStyle(
                            color: _textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (event.isSeated) const SizedBox(height: 24),
            // ── Order Summary ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: const TextStyle(
                      color: _textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_rounded,
                        color: _textSecondary,
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        event.eventDate,
                        style: const TextStyle(
                          color: _textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Event details table
                  _DetailRow(label: 'Venue', value: event.venueName),
                  const SizedBox(height: 12),
                  if (event.isSeated)
                    _DetailRow(label: 'Seats', value: 'Row B • Seat 12, 13'),
                  if (event.isSeated) const SizedBox(height: 12),
                  _DetailRow(label: 'Quantity', value: '$_quantity Ticket${_quantity > 1 ? 's' : ''}'),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // ── Quantity Selector (for general admission) ────────────────
            if (!event.isSeated)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'QUANTITY',
                      style: TextStyle(
                        color: _textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: _bgCard,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_rounded, color: _textPrimary),
                            onPressed: _quantity > 1
                                ? () => setState(() => _quantity--)
                                : null,
                          ),
                          Text(
                            _quantity.toString(),
                            style: const TextStyle(
                              color: _textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_rounded, color: _textPrimary),
                            onPressed: _quantity < event.availableCapacity
                                ? () => setState(() => _quantity++)
                                : null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            // ── Price Summary ────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Subtotal',
                        style: TextStyle(
                          color: _textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'LKR ${subtotal.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: _textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Service Fee',
                        style: TextStyle(
                          color: _textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'LKR ${serviceFee.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: _textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.white12, height: 1),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          color: _textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'LKR ${total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: _textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // ── Card Details (always shown) ─────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CARD DETAILS',
                    style: TextStyle(
                      color: _textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'CARD NUMBER',
                    style: TextStyle(
                      color: _textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _cardNumberController,
                    style: const TextStyle(
                      color: _textPrimary,
                      fontSize: 14,
                      letterSpacing: 2,
                    ),
                    decoration: InputDecoration(
                      hintText: '•••• •••• •••• 4242',
                      hintStyle: TextStyle(
                        color: _textSecondary.withValues(alpha: 0.5),
                      ),
                      suffixIcon: Icon(
                        Icons.edit_rounded,
                        color: _textSecondary.withValues(alpha: 0.5),
                        size: 18,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      filled: true,
                      fillColor: _bgCard,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'EXPIRY',
                              style: TextStyle(
                                color: _textSecondary,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _expiryController,
                              style: const TextStyle(
                                color: _textPrimary,
                                fontSize: 14,
                              ),
                              decoration: InputDecoration(
                                hintText: '12/26',
                                hintStyle: TextStyle(
                                  color: _textSecondary.withValues(alpha: 0.5),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                filled: true,
                                fillColor: _bgCard,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: Colors.white.withValues(alpha: 0.1),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: Colors.white.withValues(alpha: 0.1),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'CVV',
                              style: TextStyle(
                                color: _textSecondary,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _cvvController,
                              obscureText: true,
                              style: const TextStyle(
                                color: _textPrimary,
                                fontSize: 14,
                                letterSpacing: 1,
                              ),
                              decoration: InputDecoration(
                                hintText: '•••',
                                hintStyle: TextStyle(
                                  color: _textSecondary.withValues(alpha: 0.5),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                filled: true,
                                fillColor: _bgCard,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: Colors.white.withValues(alpha: 0.1),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: Colors.white.withValues(alpha: 0.1),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'CARDHOLDER NAME',
                    style: TextStyle(
                      color: _textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _cardholderController,
                    style: const TextStyle(
                      color: _textPrimary,
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Alex Johnson',
                      hintStyle: TextStyle(
                        color: _textSecondary.withValues(alpha: 0.5),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      filled: true,
                      fillColor: _bgCard,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(
                        Icons.info_outline_rounded,
                        color: _textSecondary,
                        size: 14,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'This is a simulated payment',
                        style: TextStyle(
                          color: _textSecondary.withValues(alpha: 0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
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
                      'AMOUNT TO PAY',
                      style: TextStyle(
                        color: _textSecondary.withValues(alpha: 0.6),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'LKR ${total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: _textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                _PayNowButton(
                  onTap: () async {
                    final eventId = int.tryParse(widget.eventId) ?? 0;
                    final booking = await ref
                        .read(bookingNotifierProvider.notifier)
                        .createBooking(eventId: eventId, quantity: _quantity);
                    if (!mounted) return;
                    if (booking != null) {
                      context.go(
                        AppRoutes.buildCustomerBookingConfirmation(
                          booking.id.toString(),
                          eventName: booking.eventName,
                          eventDate: event.eventDate,
                          venue: event.venueName,
                          holderName: booking.customerName,
                          seatsCount: booking.quantity.toString(),
                          totalPrice: booking.totalAmount.toStringAsFixed(2),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Booking failed. Please try again.')),
                      );
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
}

/// Detail row for order summary
class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: _textSecondary,
            fontSize: 13,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: _textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// Pay Now button with gradient and hover animation
class _PayNowButton extends StatefulWidget {
  final VoidCallback onTap;

  const _PayNowButton({required this.onTap});

  @override
  State<_PayNowButton> createState() => _PayNowButtonState();
}

class _PayNowButtonState extends State<_PayNowButton> {
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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
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
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Pay Now',
                  style: TextStyle(
                    color: _textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.lock_rounded,
                  color: _textPrimary,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
