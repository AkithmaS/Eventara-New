import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:eventara/core/router/app_routes.dart';

// ─── Color tokens ──────────────────────────────────────────────────────────
const _bgDeep = Color(0xFF0D0B1E);
const _bgCard = Color(0xFF151228);
const _purple = Color(0xFF7B5CF6);
const _purpleLight = Color(0xFF9B8AFB);
const _gradStart = Color(0xFF7B5CF6);
const _gradEnd = Color(0xFFE07BB0);
const _textPrimary = Color(0xFFFFFFFF);
const _textSecondary = Color(0xFFB0A8D0);
const _accentGreen = Color(0xFF4ECB71);
const _accentOrange = Color(0xFFF59E0B);
const _accentRed = Color(0xFFEF4444);

// ─── Data Models ──────────────────────────────────────────────────────────
class _CustomerData {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String joinDate;
  final String avatar;
  final String status;

  const _CustomerData({
    required this.id, required this.name, required this.email,
    required this.phone, required this.joinDate, required this.avatar,
    required this.status,
  });
}

class _OrganizerData {
  final String id;
  final String name;
  final String email;
  final String joinDate;
  final String avatar;
  final String status;

  const _OrganizerData({
    required this.id, required this.name, required this.email,
    required this.joinDate, required this.avatar, required this.status,
  });
}

class UserManagementPage extends StatefulWidget {
  final String? initialOrganizerStatus;
  const UserManagementPage({super.key, this.initialOrganizerStatus});
  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  String _orgStatus = 'Active';

  final List<_CustomerData> _customers = const [
    _CustomerData(id: '1', name: 'Elena Vance', email: 'elena.vance@eventara.com',
        phone: '+94 77 123 4567', joinDate: 'Jan 15, 2024', avatar: 'EV', status: 'active'),
    _CustomerData(id: '2', name: 'Sarah Jamlian', email: 'sarah.j@outlook.com',
        phone: '+94 71 234 5678', joinDate: 'Mar 10, 2024', avatar: 'SJ', status: 'active'),
    _CustomerData(id: '3', name: 'Jennifer Liu', email: 'jen.liu@company.com',
        phone: '+94 76 345 6789', joinDate: 'Jan 30, 2024', avatar: 'JL', status: 'active'),
    _CustomerData(id: '4', name: 'Amir Patel', email: 'amir.patel@gmail.com',
        phone: '+94 78 456 7890', joinDate: 'Apr 05, 2024', avatar: 'AP', status: 'active'),
    _CustomerData(id: '5', name: 'Nina Rossi', email: 'nina.rossi@mail.com',
        phone: '+94 75 567 8901', joinDate: 'Feb 20, 2024', avatar: 'NR', status: 'active'),
  ];

  final List<_OrganizerData> _organizers = const [
    _OrganizerData(id: '1', name: 'Marcus Chen', email: 'm.chen@gmail.com',
        joinDate: 'Feb 22, 2024', avatar: 'MC', status: 'suspended'),
    _OrganizerData(id: '2', name: 'David Ross', email: 'david@pro-productions.co',
        joinDate: 'Dec 05, 2023', avatar: 'DR', status: 'active'),
    _OrganizerData(id: '3', name: 'Lisa Wong', email: 'lisa@events.io',
        joinDate: 'Mar 18, 2024', avatar: 'LW', status: 'pending'),
    _OrganizerData(id: '4', name: 'Tom Brady', email: 'tom.b@shows.com',
        joinDate: 'Jan 09, 2024', avatar: 'TB', status: 'active'),
    _OrganizerData(id: '5', name: 'Priya Nair', email: 'priya@concerts.lk',
        joinDate: 'May 01, 2024', avatar: 'PN', status: 'pending'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // If coming from dashboard with Pending filter, switch to Organizers tab and set status
    if (widget.initialOrganizerStatus != null) {
      _tabController.animateTo(1);
      _orgStatus = widget.initialOrganizerStatus!;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<_CustomerData> get _filteredCustomers => _customers.where((c) =>
    c.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
    c.email.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

  List<_OrganizerData> get _filteredOrganizers => _organizers.where((o) =>
    (o.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
     o.email.toLowerCase().contains(_searchQuery.toLowerCase())) &&
    o.status.toLowerCase() == _orgStatus.toLowerCase()).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgDeep,
      appBar: AppBar(
        backgroundColor: _bgDeep,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_rounded, color: _textPrimary),
        ),
        title: const Text('User Management',
            style: TextStyle(color: _textPrimary, fontSize: 18, fontWeight: FontWeight.w800)),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              height: 40,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: _bgCard,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  gradient: const LinearGradient(colors: [_gradStart, _gradEnd]),
                  borderRadius: BorderRadius.circular(18),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: _textPrimary,
                unselectedLabelColor: _textSecondary,
                labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                tabs: const [Tab(text: 'Customers'), Tab(text: 'Organizers')],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // ── Search Bar ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Container(
              decoration: BoxDecoration(
                color: _bgCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: TextField(
                onChanged: (v) => setState(() => _searchQuery = v),
                style: const TextStyle(color: _textPrimary, fontSize: 13),
                decoration: const InputDecoration(
                  hintText: 'Search by name or email',
                  hintStyle: TextStyle(color: _textSecondary, fontSize: 13),
                  prefixIcon: Icon(Icons.search_rounded, color: _textSecondary, size: 18),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
                cursorColor: _purple,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // ── Tab Views ─────────────────────────────────────────────────
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildCustomerTab(), _buildOrganizerTab()],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildCustomerTab() {
    final list = _filteredCustomers;
    if (list.isEmpty) return _buildEmpty('No customers found');
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      itemCount: list.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) => _CustomerCard(
        customer: list[i],
        onViewDetails: () => context.go(
          AppRoutes.buildAdminCustomerDetail(list[i].id),
        ),
        onDeactivate: () => _showDeactivateDialog(context, list[i].name),
      ),
    );
  }

  Widget _buildOrganizerTab() {
    final statusOptions = ['Active', 'Suspended', 'Pending'];
    final list = _filteredOrganizers;
    return Column(
      children: [
        // Status filter chips
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
          child: SizedBox(
            height: 36,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: statusOptions.length,
              itemBuilder: (_, i) {
                final s = statusOptions[i];
                final sel = _orgStatus == s;
                return Padding(
                  padding: EdgeInsets.only(right: i < statusOptions.length - 1 ? 8 : 0),
                  child: GestureDetector(
                    onTap: () => setState(() => _orgStatus = s),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: sel ? const LinearGradient(colors: [_gradStart, _gradEnd]) : null,
                        color: sel ? null : _bgCard,
                        borderRadius: BorderRadius.circular(18),
                        border: sel ? null : Border.all(color: Colors.white.withValues(alpha: 0.1)),
                      ),
                      child: Text(s,
                          style: TextStyle(
                            color: sel ? _textPrimary : _textSecondary,
                            fontSize: 12, fontWeight: FontWeight.w600,
                          )),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Expanded(
          child: list.isEmpty
              ? _buildEmpty('No ${_orgStatus.toLowerCase()} organizers')
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) => _OrganizerCard(
                    organizer: list[i],
                    onViewDetails: () => context.go(
                      AppRoutes.buildAdminOrganizerDetail(list[i].id),
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildEmpty(String msg) => Center(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.people_outline_rounded, size: 48, color: _textSecondary.withValues(alpha: 0.3)),
      const SizedBox(height: 12),
      Text(msg, style: TextStyle(color: _textSecondary.withValues(alpha: 0.6), fontSize: 14)),
    ]),
  );

  void _showDeactivateDialog(BuildContext context, String name) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: _bgCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Deactivate Account',
            style: TextStyle(color: _textPrimary, fontWeight: FontWeight.w800)),
        content: Text('Are you sure you want to deactivate $name\'s account?'
            ' They will no longer be able to log in.',
            style: const TextStyle(color: _textSecondary, fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: _textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Deactivate',
                style: TextStyle(color: _accentRed, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _bgCard,
        border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(icon: Icons.dashboard_rounded, label: 'Dashboard',
                  onTap: () => context.go(AppRoutes.adminDashboard)),
              _NavItem(icon: Icons.people_rounded, label: 'Users', isActive: true, onTap: () {}),
              _NavItem(icon: Icons.event_rounded, label: 'Events',
                  onTap: () => context.go(AppRoutes.adminEvents)),
              _NavItem(icon: Icons.settings_rounded, label: 'Settings',
                  onTap: () => context.go(AppRoutes.adminSettings)),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Customer Card ──────────────────────────────────────────────────────────
class _CustomerCard extends StatelessWidget {
  final _CustomerData customer;
  final VoidCallback onViewDetails;
  final VoidCallback onDeactivate;

  const _CustomerCard({required this.customer, required this.onViewDetails, required this.onDeactivate});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 48, height: 48,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: [_gradStart, _gradEnd]),
                  ),
                  child: Center(
                    child: Text(customer.avatar,
                        style: const TextStyle(color: _textPrimary, fontSize: 15, fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(width: 12),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(customer.name,
                          style: const TextStyle(color: _textPrimary, fontSize: 13, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 3),
                      Text(customer.email,
                          style: TextStyle(color: _textSecondary.withValues(alpha: 0.8), fontSize: 11),
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 3),
                      Text('Joined ${customer.joinDate}',
                          style: TextStyle(color: _textSecondary.withValues(alpha: 0.5), fontSize: 10)),
                    ],
                  ),
                ),
                // Details arrow
                GestureDetector(
                  onTap: onViewDetails,
                  child: Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: _purple.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.arrow_forward_ios_rounded, color: _purpleLight, size: 14),
                  ),
                ),
              ],
            ),
          ),
          // Deactivate button
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: GestureDetector(
              onTap: onDeactivate,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: _accentRed.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _accentRed.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.block_rounded, color: _accentRed, size: 14),
                    const SizedBox(width: 6),
                    const Text('Deactivate Account',
                        style: TextStyle(color: _accentRed, fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Organizer Card ─────────────────────────────────────────────────────────
class _OrganizerCard extends StatelessWidget {
  final _OrganizerData organizer;
  final VoidCallback onViewDetails;
  const _OrganizerCard({required this.organizer, required this.onViewDetails});

  Color get _statusColor {
    switch (organizer.status) {
      case 'active': return _accentGreen;
      case 'suspended': return _accentRed;
      default: return _accentOrange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onViewDetails,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _bgCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Row(
          children: [
            Container(
              width: 48, height: 48,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [_gradStart, _gradEnd]),
              ),
              child: Center(
                child: Text(organizer.avatar,
                    style: const TextStyle(color: _textPrimary, fontSize: 15, fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(organizer.name,
                      style: const TextStyle(color: _textPrimary, fontSize: 13, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 3),
                  Text(organizer.email,
                      style: TextStyle(color: _textSecondary.withValues(alpha: 0.8), fontSize: 11),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 3),
                  Text('Joined ${organizer.joinDate}',
                      style: TextStyle(color: _textSecondary.withValues(alpha: 0.5), fontSize: 10)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: _statusColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: _statusColor.withValues(alpha: 0.3)),
              ),
              child: Text(organizer.status.toUpperCase(),
                  style: TextStyle(color: _statusColor, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.4)),
            ),
            const SizedBox(width: 8),
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                color: _purpleLight.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(7),
              ),
              child: const Icon(Icons.arrow_forward_ios_rounded, color: _purpleLight, size: 13),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Bottom Nav Item ─────────────────────────────────────────────────────────
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isActive;

  const _NavItem({required this.icon, required this.label, required this.onTap, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon, color: isActive ? _purpleLight : _textSecondary, size: 24),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(
          color: isActive ? _purpleLight : _textSecondary,
          fontSize: 11, fontWeight: FontWeight.w600,
        )),
      ]),
    );
  }
}
