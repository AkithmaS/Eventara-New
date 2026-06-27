import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../shared/widgets/brand_logo.dart';
import '../../core/router/app_routes.dart';

// ─── Colour tokens (matching the screenshots exactly) ────────────────────────
const _bgDeep = Color(0xFF0D0B1E); // near-black purple
const _bgCard = Color(0xFF151228); // card background
const _purple = Color(0xFF7B5CF6); // primary purple
const _purpleLight = Color(0xFF9B8AFB); // lighter purple (headline accent)
const _peach = Color(0xFFF4A261); // orange-peach accent on "Events"
const _gradStart = Color(0xFF7B5CF6); // CTA gradient start
const _gradEnd = Color(0xFFE07BB0); // CTA gradient end (pink)
const _textPrimary = Color(0xFFFFFFFF);
const _textSecondary = Color(0xFFB0A8D0);
const _iconBg = Color(0xFF211D3A);

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  late final AnimationController _heroFade;
  late final AnimationController _ticketFloat;
  late final AnimationController _scatter;

  @override
  void initState() {
    super.initState();
    _heroFade = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _ticketFloat = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _scatter = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _heroFade.dispose();
    _ticketFloat.dispose();
    _scatter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgDeep,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _NavBar(),
            _HeroSection(fadeCtrl: _heroFade),
            _TicketCardsSection(floatCtrl: _ticketFloat, scatterCtrl: _scatter),
            _FeaturesSection(),
            _ExploreByCategorySection(),
            _TestimonialsSection(),
            const _CtaBanner(),
            _Footer(),
          ],
        ),
      ),
    );
  }
}

// ─── 1. NAV BAR ──────────────────────────────────────────────────────────────
class _NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: _bgDeep,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const BrandLogo(),
          const SizedBox.shrink(),
        ],
      ),
    );
  }
}

// ─── 2. HERO SECTION ─────────────────────────────────────────────────────────
class _HeroSection extends StatelessWidget {
  final AnimationController fadeCtrl;
  const _HeroSection({required this.fadeCtrl});

  @override
  Widget build(BuildContext context) {
    final fade = CurvedAnimation(parent: fadeCtrl, curve: Curves.easeOut);
    final slide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(fade);

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0.0, -0.3),
          radius: 1.1,
          colors: [Color(0xFF1E1040), _bgDeep],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 48, 24, 40),
      child: FadeTransition(
        opacity: fade,
        child: SlideTransition(
          position: slide,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Headline
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                    letterSpacing: -0.5,
                    color: _textPrimary,
                  ),
                  children: [
                    TextSpan(text: 'Book\nUnforgettable\n'),
                    TextSpan(
                      text: 'Events',
                      style: TextStyle(
                        foreground: Paint()
                          ..shader = const LinearGradient(
                            colors: [_purpleLight, _peach],
                          ).createShader(Rect.fromLTWH(0, 0, 200, 60)),
                      ),
                    ),
                    TextSpan(text: ' In\nSeconds'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Subtitle
              const Text(
                'The premium ecosystem for secure ticketing, interactive seating, and seamless event management. Experience the future of events today.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _textSecondary,
                  fontSize: 15,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 36),
              // Primary CTA
              _GradientButton(
                label: 'Get Started',
                onTap: () => context.go('/login'),
              ),
              const SizedBox(height: 14),
              // Secondary CTA
              _OutlineButton(
                label: 'Become an Organizer',
                onTap: () => context.go('/organizer-apply'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── 3. TICKET CARDS SECTION ─────────────────────────────────────────────────
class _TicketCardsSection extends StatelessWidget {
  final AnimationController floatCtrl;
  final AnimationController scatterCtrl;
  const _TicketCardsSection({
    required this.floatCtrl,
    required this.scatterCtrl,
  });

  static const double _cardW = 300.0;
  static const double _cardH = 140.0;
  // Card 2 starts this many px to the right and below card 1
  static const double _offsetX = 100.0;
  static const double _offsetY = _cardH + 20.0; // card height + gap
  // Float travel distance
  static const double _floatAmp = 8.0;

  @override
  Widget build(BuildContext context) {
    final float1 = Tween<double>(begin: -_floatAmp, end: _floatAmp).animate(
      CurvedAnimation(parent: floatCtrl, curve: Curves.easeInOut),
    );
    final float2 = Tween<double>(begin: _floatAmp, end: -_floatAmp).animate(
      CurvedAnimation(parent: floatCtrl, curve: Curves.easeInOut),
    );

    // Canvas must hold both cards + float travel
    const canvasW = _cardW + _offsetX;
    const canvasH = _cardH + _offsetY + _floatAmp * 2 + 16;

    return Container(
      width: double.infinity,
      color: _bgDeep,
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: SizedBox(
          width: canvasW,
          height: canvasH,
          child: AnimatedBuilder(
            animation: floatCtrl,
            builder: (_, __) => Stack(
              clipBehavior: Clip.none,
              children: [
                // ── Card 1 — upper-left ──────────────────────────────────
                Positioned(
                  left: 0,
                  top: _floatAmp + float1.value,
                  child: _PassCard(
                    icon: Icons.confirmation_number_outlined,
                    label: 'GENERAL TICKET',
                    sublabel: 'General Admission',
                    gradientColors: const [
                      Color(0xFF7B3FBF),
                      Color(0xFF3D1F6E),
                    ],
                    dividerColor: Colors.white38,
                    tiltLeft: true,
                  ),
                ),
                // ── Card 2 — lower-right ─────────────────────────────────
                Positioned(
                  left: _offsetX,
                  top: _offsetY + _floatAmp + float2.value,
                  child: _PassCard(
                    icon: Icons.event_seat_outlined,
                    label: 'SEATED PASS',
                    sublabel: 'Zone A • Row 3',
                    gradientColors: const [
                      Color(0xFF5B6FD4),
                      Color(0xFF3ABCD4),
                    ],
                    dividerColor: Color(0xFF5BE8F0),
                    tiltLeft: false,
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

/// A single rectangular pass card with dot-grid texture and floating animation.
class _PassCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final String sublabel;
  final List<Color> gradientColors;
  final Color dividerColor;
  final bool tiltLeft;

  const _PassCard({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.gradientColors,
    required this.dividerColor,
    required this.tiltLeft,
  });

  @override
  State<_PassCard> createState() => _PassCardState();
}

class _PassCardState extends State<_PassCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    // Slight Z rotation to match the reference tilt
    final angle = widget.tiltLeft ? -0.06 : 0.06;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.03 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: Transform.rotate(
          angle: angle,
          child: Container(
            width: 300,
            height: 140,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: widget.gradientColors,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: widget.gradientColors[0].withValues(alpha: 0.35),
                  blurRadius: 32,
                  spreadRadius: 2,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Dot-grid texture
                Positioned.fill(
                  child: CustomPaint(painter: _DotGridPainter()),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                  child: Row(
                    children: [
                      Icon(widget.icon, color: Colors.white, size: 36),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.label,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(height: 2, width: 40, color: widget.dividerColor),
                            const SizedBox(height: 6),
                            Text(
                              widget.sublabel,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.76),
                                fontSize: 10,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: List.generate(3, (i) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Container(
                            width: i == 0 ? 10 : 7,
                            height: i == 0 ? 10 : 7,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: i == 0 ? Colors.white : Colors.white.withValues(alpha: 0.30),
                            ),
                          ),
                        )),
                      ),
                    ],
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

/// Faint dot-grid texture painted over the card background.
class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;
    const spacing = 18.0;
    for (double x = spacing; x < size.width; x += spacing) {
      for (double y = spacing; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DotGridPainter old) => false;
}

// ─── 4. FEATURES SECTION ─────────────────────────────────────────────────────
class _FeaturesSection extends StatelessWidget {
  static const _features = [
    _FeatureData(
      icon: Icons.weekend_rounded,
      iconColor: _purpleLight,
      title: 'Interactive Seating',
      description:
          'Easily browse available seats on a real-time seat map and pick your perfect spot in seconds.',
    ),
    _FeatureData(
      icon: Icons.qr_code_2_rounded,
      iconColor: _purpleLight,
      title: 'Instant QR Tickets',
      description:
          'Dynamic QR codes delivered instantly to the app, preventing fraud and scalping.',
    ),
    _FeatureData(
      icon: Icons.calendar_month_rounded,
      iconColor: _purpleLight,
      title: 'Event Management',
      description:
          'End-to-end dashboard for organizers to track sales, attendees, and logistics.',
    ),
    _FeatureData(
      icon: Icons.bar_chart_rounded,
      iconColor: _purpleLight,
      title: 'Analytics Dashboard',
      description:
          'Powerful data visualization for growth-driven organizers and event planners.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _bgDeep,
      padding: const EdgeInsets.fromLTRB(20, 56, 20, 48),
      child: Column(
        children: [
          const Text(
            'Premium Ticketing\nFeatures',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Engineered for security, built for speed, and designed for an elite user experience.',
            textAlign: TextAlign.center,
            style: TextStyle(color: _textSecondary, fontSize: 14, height: 1.6),
          ),
          const SizedBox(height: 32),
          ...List.generate(
            _features.length,
            (i) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _FeatureCard(data: _features[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureData {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  const _FeatureData({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
  });
}

class _FeatureCard extends StatefulWidget {
  final _FeatureData data;
  const _FeatureCard({required this.data});

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> {
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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: _hovered ? _bgCard.withValues(alpha: 0.9) : _bgCard,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _hovered 
                  ? _purple.withValues(alpha: 0.4)
                  : Colors.white.withValues(alpha: 0.06),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _hovered ? _purple.withValues(alpha: 0.3) : _iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  widget.data.icon,
                  color: _hovered ? _purpleLight : widget.data.iconColor,
                  size: 24,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.data.title,
                style: const TextStyle(
                  color: _textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.data.description,
                style: const TextStyle(
                  color: _textSecondary,
                  fontSize: 14,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── 5. EXPLORE BY CATEGORY ──────────────────────────────────────────────────
class _CatData {
  final String image;
  final bool isLandscape;
  const _CatData({required this.image, required this.isLandscape});
}

class _ExploreByCategorySection extends StatelessWidget {
  // Six categories mapped to their photos with aspect ratios
  // landscape = 16:9, portrait = 9:16
  static const _cats = [
    _CatData(image: 'assets/images/concert.jpg',    isLandscape: true),    // Entertainment
    _CatData(image: 'assets/images/sports.jpg',     isLandscape: false),   // Sports
    _CatData(image: 'assets/images/conference.jpg', isLandscape: true),    // Conferences
    _CatData(image: 'assets/images/esport.jpg',     isLandscape: false),   // Esports
    _CatData(image: 'assets/images/workshop.jpg',   isLandscape: true),    // Workshops
    _CatData(image: 'assets/images/wellness.jpg',   isLandscape: false),   // Wellness
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0F0B25), Color(0xFF140E2E)],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 56, 20, 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────────────
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w800,
                height: 1.2,
                letterSpacing: -0.5,
                color: _textPrimary,
              ),
              children: [
                const TextSpan(text: 'Trusted by\nindustries\n'),
                TextSpan(
                  text: 'like yours',
                  style: TextStyle(
                    foreground: Paint()
                      ..shader = const LinearGradient(
                        colors: [_purpleLight, _peach],
                      ).createShader(Rect.fromLTWH(0, 0, 200, 60)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // ── Row 1: Landscape (full width) ────────────────────────────
          SizedBox(
            width: double.infinity,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: _CatTile(data: _cats[0]),
            ),
          ),
          const SizedBox(height: 12),

          // ── Row 2: Two Portraits side by side ────────────────────────
          Row(
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: 9 / 16,
                  child: _CatTile(data: _cats[1]),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 9 / 16,
                  child: _CatTile(data: _cats[2]),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ── Row 3: Landscape (full width) ────────────────────────────
          SizedBox(
            width: double.infinity,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: _CatTile(data: _cats[3]),
            ),
          ),
          const SizedBox(height: 12),

          // ── Row 4: Two Portraits side by side ────────────────────────
          Row(
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: 9 / 16,
                  child: _CatTile(data: _cats[4]),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 9 / 16,
                  child: _CatTile(data: _cats[5]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Single photo tile with smooth animations (no labels)
class _CatTile extends StatefulWidget {
  final _CatData data;
  const _CatTile({required this.data});

  @override
  State<_CatTile> createState() => _CatTileState();
}

class _CatTileState extends State<_CatTile> with TickerProviderStateMixin {
  late AnimationController _scaleCtrl;
  late AnimationController _overlayCtrl;

  @override
  void initState() {
    super.initState();
    _scaleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 300),
    );
    _overlayCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      reverseDuration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    _overlayCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        _scaleCtrl.forward();
        _overlayCtrl.forward();
      },
      onExit: (_) {
        _scaleCtrl.reverse();
        _overlayCtrl.reverse();
      },
      child: AnimatedBuilder(
        animation: Listenable.merge([_scaleCtrl, _overlayCtrl]),
        builder: (context, child) {
          final scale = Tween<double>(begin: 1.0, end: 1.08).evaluate(_scaleCtrl);
          final overlayOpacity = Tween<double>(begin: 0.3, end: 0.5).evaluate(_overlayCtrl);
          
          return Transform.scale(
            scale: scale,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox.expand(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // ── Photo Background ────────────────────────────────
                    Image.asset(
                      widget.data.image,
                      fit: BoxFit.cover,
                    ),
                    
                    // ── Dark Overlay ────────────────────────────────────
                    Container(
                      color: Colors.black.withValues(alpha: overlayOpacity),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─── 6. TESTIMONIALS ─────────────────────────────────────────────────────────
class _TestimonialsSection extends StatelessWidget {
  static const _testimonials = [
    _TestimonialData(
      name: 'Marcus Chen',
      role: 'Festival Director',
      quote:
          '"The real-time verification system saved us from a massive ticketing bottleneck at the gates. Truly next-gen."',
      initials: 'MC',
      avatarColor: Color(0xFF3A3060),
    ),
    _TestimonialData(
      name: 'Sarah Jenkins',
      role: 'Tech Summit Founder',
      quote:
          '"The interactive 2D map is a game changer. Our VIP seats sold out 40% faster than last year."',
      initials: 'SJ',
      avatarColor: Color(0xFF3D1F35),
    ),
    _TestimonialData(
      name: 'David Rivera',
      role: 'Power User',
      quote:
          '"Clean, fast, and secure. Best ticketing app I\'ve used. No more stressing about fake resale tickets."',
      initials: 'DR',
      avatarColor: Color(0xFF1F2D40),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _bgDeep,
      padding: const EdgeInsets.fromLTRB(20, 56, 20, 48),
      child: Column(
        children: [
          const Text(
            'What People Say',
            style: TextStyle(
              color: _textPrimary,
              fontSize: 26,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 28),
          ...List.generate(
            _testimonials.length,
            (i) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _TestimonialCard(data: _testimonials[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _TestimonialData {
  final String name;
  final String role;
  final String quote;
  final String initials;
  final Color avatarColor;
  const _TestimonialData({
    required this.name,
    required this.role,
    required this.quote,
    required this.initials,
    required this.avatarColor,
  });
}

class _TestimonialCard extends StatefulWidget {
  final _TestimonialData data;
  const _TestimonialCard({required this.data});

  @override
  State<_TestimonialCard> createState() => _TestimonialCardState();
}

class _TestimonialCardState extends State<_TestimonialCard> {
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
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _bgCard,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: widget.data.avatarColor,
                    child: Text(
                      widget.data.initials,
                      style: const TextStyle(
                        color: _textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.data.name,
                        style: const TextStyle(
                          color: _textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        widget.data.role,
                        style: const TextStyle(
                          color: _textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                widget.data.quote,
                style: const TextStyle(
                  color: _textSecondary,
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── 7. CTA BANNER ───────────────────────────────────────────────────────────
class _CtaBanner extends StatefulWidget {
  const _CtaBanner();

  @override
  State<_CtaBanner> createState() => _CtaBannerState();
}

class _CtaBannerState extends State<_CtaBanner> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _bgDeep,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 48),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedScale(
          scale: _hovered ? 1.03 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF7B4FCF),
                  Color(0xFF9B5CF6),
                  Color(0xFFBB6EC2),
                  Color(0xFFD4848A),
                  Color(0xFFE8A87C),
                ],
                stops: [0.0, 0.25, 0.5, 0.75, 1.0],
              ),
            ),
            child: Column(
              children: [
                const Text(
                  'Ready to\nHost?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _textPrimary,
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Join the most advanced event ecosystem in the world. Start selling tickets in minutes.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFEEE0FF),
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: _AnimatedButtonWrapper(
                    onTap: () => context.go(AppRoutes.organizerCreateEvent),
                    child: TextButton(
                      onPressed: () => context.go(AppRoutes.organizerCreateEvent),
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFF0D0B1E),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Launch Your Event',
                        style: TextStyle(
                          color: _textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
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

// ─── 8. FOOTER ───────────────────────────────────────────────────────────────
class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF080614),
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BrandLogo(
            fontSize: 18,
            textColor: _textPrimary,
          ),
          const SizedBox(height: 10),
          const Text(
            'Elevating event experiences globally through elite technology and design.',
            style: TextStyle(color: _textSecondary, fontSize: 13, height: 1.6),
          ),
          const SizedBox(height: 32),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _FooterColumn(
                  title: 'PLATFORM',
                  links: ['About', 'Features', 'Pricing', 'Organizers'],
                ),
              ),
              Expanded(
                child: _FooterColumn(
                  title: 'CONNECT',
                  links: ['Contact', 'Twitter', 'Instagram', 'LinkedIn'],
                ),
              ),
            ],
          ),
          const SizedBox(height: 36),
          const Divider(color: Color(0xFF2A2540), thickness: 1),
          const SizedBox(height: 16),
          const Text(
            '© 2026 Eventara. All rights reserved.',
            style: TextStyle(color: Color(0xFF5A5280), fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _FooterColumn extends StatelessWidget {
  final String title;
  final List<String> links;
  const _FooterColumn({required this.title, required this.links});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: _textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 14),
        ...links.map(
          (l) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              l,
              style: const TextStyle(color: _textPrimary, fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── SHARED BUTTON WIDGETS ───────────────────────────────────────────────────

/// Animated button wrapper - applies common scale animation (1.0→1.03, 200ms, easeOut)
class _AnimatedButtonWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  const _AnimatedButtonWrapper({required this.child, required this.onTap});

  @override
  State<_AnimatedButtonWrapper> createState() => _AnimatedButtonWrapperState();
}

class _AnimatedButtonWrapperState extends State<_AnimatedButtonWrapper> {
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
          child: widget.child,
        ),
      ),
    );
  }
}

/// Full-width gradient button (primary CTA)
class _GradientButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _GradientButton({required this.label, required this.onTap});

  @override
  State<_GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<_GradientButton> {
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
            height: 58,
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
            child: Center(
              child: Text(
                widget.label,
                style: const TextStyle(
                  color: _textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Full-width dark outline button (secondary CTA)
class _OutlineButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _OutlineButton({required this.label, required this.onTap});

  @override
  State<_OutlineButton> createState() => _OutlineButtonState();
}

class _OutlineButtonState extends State<_OutlineButton> {
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
            height: 58,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: const Color(0xFF1A1530),
              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            ),
            child: Center(
              child: Text(
                widget.label,
                style: const TextStyle(
                  color: _textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Small pill button used in the nav bar
class _PillButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final LinearGradient gradient;
  const _PillButton({
    required this.label,
    required this.onTap,
    required this.gradient,
  });

  @override
  State<_PillButton> createState() => _PillButtonState();
}

class _PillButtonState extends State<_PillButton> {
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              gradient: widget.gradient,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text(
              widget.label,
              style: const TextStyle(
                color: _textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
