import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:eventara/core/router/app_routes.dart';
import 'package:eventara/core/network/api_endpoints.dart';
import 'package:eventara/core/network/dio_client.dart';
import '../../../auth/presentation/providers/auth_notifier.dart';

// ─── Colour tokens ──────────────────────────────────────────────────────────
const _bgDeep = Color(0xFF0D0B1E);
const _bgCard = Color(0xFF151228);
const _purple = Color(0xFF7B5CF6);
const _purpleLight = Color(0xFF9B8AFB);
const _gradStart = Color(0xFF7B5CF6);
const _gradEnd = Color(0xFFE07BB0);
const _textPrimary = Color(0xFFFFFFFF);
const _textSecondary = Color(0xFFB0A8D0);

// User Model
class UserModel {
  final int id;
  final String fullName;
  final String email;
  final String? phoneNumber;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.phoneNumber,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String?,
    );
  }
}

// Provider to fetch user profile
final userProfileProvider = FutureProvider<UserModel>((ref) async {
  final dio = DioClient.instance.dio;
  try {
    final response = await dio.get(ApiEndpoints.userProfile);
    if (response.statusCode == 200) {
      final data = response.data as Map<String, dynamic>;
      final userData = data['data'] as Map<String, dynamic>;
      return UserModel.fromJson(userData);
    }
    throw Exception('Failed to fetch user profile');
  } catch (e) {
    throw Exception('Error fetching user profile: $e');
  }
});

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: _bgDeep,
      body: userAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: _purple),
        ),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: _textSecondary, size: 48),
              const SizedBox(height: 16),
              Text(
                'Error loading profile',
                textAlign: TextAlign.center,
                style: const TextStyle(color: _textPrimary, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                err.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: _textSecondary, fontSize: 12),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () => ref.invalidate(userProfileProvider),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: const LinearGradient(
                      colors: [_gradStart, _gradEnd],
                    ),
                  ),
                  child: const Text(
                    'Retry',
                    style: TextStyle(
                      color: _textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        data: (user) {
          return _buildProfileView(user);
        },
      ),
      bottomNavigationBar: _BottomNavBar(),
    );
  }

  Widget _buildProfileView(UserModel user) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            // ── Header with Back and Settings ────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => context.go(AppRoutes.customerHome),
                    child: Container(
                      width: 40,
                      height: 40,
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
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    'Profile',
                    style: TextStyle(
                      color: _purpleLight,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _bgCard,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.settings_rounded,
                        color: _textPrimary,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // ── Profile Header ──────────────────────────────────────
            Center(
              child: Column(
                children: [
                  // Avatar with border
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _purple,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _purple.withValues(alpha: 0.3),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [_gradStart, _gradEnd],
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.person_rounded,
                          size: 50,
                          color: _textPrimary.withValues(alpha: 0.8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // User name
                  Text(
                    user.fullName,
                    style: const TextStyle(
                      color: _textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Email
                  Text(
                    user.email,
                    style: TextStyle(
                      color: _textSecondary.withValues(alpha: 0.8),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _purple.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _purple.withValues(alpha: 0.4),
                      ),
                    ),
                    child: const Text(
                      'CUSTOMER',
                      style: TextStyle(
                        color: _purpleLight,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // ── Account Section ─────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Account',
                    style: TextStyle(
                      color: _textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _ProfileMenuItem(
                    icon: Icons.person_outline_rounded,
                    title: 'Personal Information',
                    onTap: () {
                      _showPersonalInformationModal(context, user);
                    },
                  ),
                  const SizedBox(height: 8),
                  _ProfileMenuItem(
                    icon: Icons.lock_outline_rounded,
                    title: 'Change Password',
                    onTap: () {
                      _showChangePasswordModal(context);
                    },
                  ),
                  const SizedBox(height: 8),
                  _ProfileMenuItem(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // ── Bookings Section ────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bookings',
                    style: TextStyle(
                      color: _textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _ProfileMenuItem(
                    icon: Icons.confirmation_number_outlined,
                    title: 'My Tickets',
                    onTap: () => context.go(AppRoutes.customerMyTickets),
                  ),
                  const SizedBox(height: 8),
                  _ProfileMenuItem(
                    icon: Icons.history_rounded,
                    title: 'Booking History',
                    onTap: () => context.go(AppRoutes.customerBookingHistory),
                  ),
                  const SizedBox(height: 8),
                  _ProfileMenuItem(
                    icon: Icons.cancel_outlined,
                    title: 'Cancelled Bookings',
                    onTap: () => context.go(AppRoutes.customerBookingHistory),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // ── Logout Button ───────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GestureDetector(
                onTap: () {
                  _showLogoutDialog(context);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.red.withValues(alpha: 0.3),
                    ),
                    color: Colors.red.withValues(alpha: 0.05),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.logout_rounded,
                          color: Colors.red.shade400,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Log Out',
                          style: TextStyle(
                            color: Colors.red.shade400,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
        ),
      ),
    );
  }

  void _showPersonalInformationModal(BuildContext context, UserModel user) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _bgCard,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _PersonalInformationView(
        user: user,
        onEdit: () {
          Navigator.pop(context);
          _showEditPersonalInformationModal(context, user);
        },
      ),
    );
  }

  void _showEditPersonalInformationModal(BuildContext context, UserModel user) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _bgCard,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) => _EditPersonalInformationView(
        user: user,
        onSave: (name, contact) {
          Navigator.pop(context);
          // Don't invalidate - just close the modal
          // The user data will be refreshed when they navigate away and back
        },
      ),
    );
  }

  void _showChangePasswordModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _bgCard,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) => const _ChangePasswordView(),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _bgCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ),
        title: const Text(
          'Log Out',
          style: TextStyle(
            color: _textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'Are you sure you want to log out?',
          style: TextStyle(
            color: _textSecondary,
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: _textSecondary),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(authNotifierProvider.notifier).logout();
              if (context.mounted) context.go(AppRoutes.login);
            },
            child: Text(
              'Log Out',
              style: TextStyle(color: Colors.red.shade400),
            ),
          ),
        ],
      ),
    );
  }
}

/// Personal Information View
class _PersonalInformationView extends StatelessWidget {
  final UserModel user;
  final VoidCallback onEdit;

  const _PersonalInformationView({
    required this.user,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // Header
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: _textSecondary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Personal Information',
            style: TextStyle(
              color: _textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 20),
          // Name
          _InformationField(
            label: 'Full Name',
            value: user.fullName,
          ),
          const SizedBox(height: 16),
          // Email
          _InformationField(
            label: 'Email',
            value: user.email,
          ),
          const SizedBox(height: 16),
          // Contact Number
          _InformationField(
            label: 'Contact Number',
            value: user.phoneNumber ?? 'Not set',
          ),
          const SizedBox(height: 24),
          // Edit Button
          GestureDetector(
            onTap: onEdit,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                  colors: [_gradStart, _gradEnd],
                ),
              ),
              child: const Center(
                child: Text(
                  'Edit Information',
                  style: TextStyle(
                    color: _textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
      ),
    );
  }
}

/// Edit Personal Information View
class _EditPersonalInformationView extends StatefulWidget {
  final UserModel user;
  final Function(String name, String contact) onSave;

  const _EditPersonalInformationView({
    required this.user,
    required this.onSave,
  });

  @override
  State<_EditPersonalInformationView> createState() =>
      _EditPersonalInformationViewState();
}

class _EditPersonalInformationViewState
    extends State<_EditPersonalInformationView> {
  late TextEditingController _nameController;
  late TextEditingController _contactController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.fullName);
    _contactController =
        TextEditingController(text: widget.user.phoneNumber ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (_nameController.text.isEmpty || _contactController.text.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All fields are required')),
        );
      }
      return;
    }

    setState(() => _isSaving = true);

    try {
      final dio = DioClient.instance.dio;
      print('Saving profile with: ${_nameController.text}, ${_contactController.text}');
      
      final response = await dio.put(
        ApiEndpoints.updateProfile,
        data: {
          'fullName': _nameController.text,
          'phoneNumber': _contactController.text,
        },
      );
      
      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
        
        // Wait a bit for the snackbar to show, then close
        await Future.delayed(const Duration(milliseconds: 500));
        
        if (mounted) {
          Navigator.pop(context);
          widget.onSave(_nameController.text, _contactController.text);
        }
      }
    } catch (e) {
      print('Error updating profile: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: _textSecondary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Edit Personal Information',
              style: TextStyle(
                color: _textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 20),
            // Name Field
            _EditField(
              label: 'Full Name',
              controller: _nameController,
            ),
            const SizedBox(height: 16),
            // Contact Number Field
            _EditField(
              label: 'Contact Number',
              controller: _contactController,
            ),
            const SizedBox(height: 24),
            // Save Button
            Opacity(
              opacity: _isSaving ? 0.5 : 1.0,
              child: GestureDetector(
                onTap: _isSaving ? null : _saveChanges,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      colors: [_gradStart, _gradEnd],
                    ),
                  ),
                  child: Center(
                    child: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: _textPrimary,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Save Changes',
                            style: TextStyle(
                              color: _textPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

/// Change Password View
class _ChangePasswordView extends StatefulWidget {
  const _ChangePasswordView();

  @override
  State<_ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<_ChangePasswordView> {
  late TextEditingController _currentPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;
  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    if (_newPasswordController.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Password must be at least 8 characters')),
      );
      return;
    }

    setState(() => _isUpdating = true);

    try {
      final dio = DioClient.instance.dio;
      await dio.post(
        ApiEndpoints.changePassword,
        data: {
          'currentPassword': _currentPasswordController.text,
          'newPassword': _newPasswordController.text,
          'confirmPassword': _confirmPasswordController.text,
        },
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password changed successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUpdating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: _textSecondary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Change Password',
              style: TextStyle(
                color: _textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 20),
            // Current Password
            _PasswordField(
              label: 'Current Password',
              controller: _currentPasswordController,
              obscure: !_showCurrentPassword,
              onToggleVisibility: () {
                setState(() => _showCurrentPassword = !_showCurrentPassword);
              },
            ),
            const SizedBox(height: 16),
            // New Password
            _PasswordField(
              label: 'New Password',
              controller: _newPasswordController,
              obscure: !_showNewPassword,
              onToggleVisibility: () {
                setState(() => _showNewPassword = !_showNewPassword);
              },
            ),
            const SizedBox(height: 16),
            // Confirm Password
            _PasswordField(
              label: 'Confirm Password',
              controller: _confirmPasswordController,
              obscure: !_showConfirmPassword,
              onToggleVisibility: () {
                setState(() => _showConfirmPassword = !_showConfirmPassword);
              },
            ),
            const SizedBox(height: 24),
            // Submit Button
            Opacity(
              opacity: _isUpdating ? 0.5 : 1.0,
              child: GestureDetector(
                onTap: _isUpdating ? null : _changePassword,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      colors: [_gradStart, _gradEnd],
                    ),
                  ),
                  child: Center(
                    child: _isUpdating
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: _textPrimary,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Update Password',
                            style: TextStyle(
                              color: _textPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

/// Information Field (Read-only)
class _InformationField extends StatelessWidget {
  final String label;
  final String value;

  const _InformationField({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: _textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: _bgDeep,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),
          child: Text(
            value,
            style: const TextStyle(
              color: _textPrimary,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}

/// Edit Field (Text input)
class _EditField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const _EditField({
    required this.label,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: _textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: const TextStyle(color: _textPrimary),
          decoration: InputDecoration(
            hintText: 'Enter $label',
            hintStyle: TextStyle(
              color: _textSecondary.withValues(alpha: 0.5),
            ),
            filled: true,
            fillColor: _bgDeep,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: _purple,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}

/// Password Field with visibility toggle
class _PasswordField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onToggleVisibility;

  const _PasswordField({
    required this.label,
    required this.controller,
    required this.obscure,
    required this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: _textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          style: const TextStyle(color: _textPrimary),
          decoration: InputDecoration(
            hintText: 'Enter $label',
            hintStyle: TextStyle(
              color: _textSecondary.withValues(alpha: 0.5),
            ),
            filled: true,
            fillColor: _bgDeep,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: _purple,
              ),
            ),
            suffixIcon: GestureDetector(
              onTap: onToggleVisibility,
              child: Icon(
                obscure ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                color: _textSecondary,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}

/// Menu item for profile options
class _ProfileMenuItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  State<_ProfileMenuItem> createState() => _ProfileMenuItemState();
}

class _ProfileMenuItemState extends State<_ProfileMenuItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: _hovered ? _bgCard.withValues(alpha: 0.8) : _bgCard,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _hovered
                  ? _purple.withValues(alpha: 0.2)
                  : Colors.white.withValues(alpha: 0.05),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    widget.icon,
                    color: _hovered ? _purpleLight : _textSecondary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    widget.title,
                    style: TextStyle(
                      color: _hovered ? _textPrimary : _textSecondary,
                      fontSize: 14,
                      fontWeight: _hovered ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: _textSecondary.withValues(alpha: 0.5),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bottom Navigation Bar
class _BottomNavBar extends StatefulWidget {
  const _BottomNavBar();

  @override
  State<_BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<_BottomNavBar> {
  int _selectedIndex = 3; // Profile is index 3

  final List<Map<String, dynamic>> _navItems = [
    {'icon': Icons.home_rounded, 'label': 'Home'},
    {'icon': Icons.search_rounded, 'label': 'Explore'},
    {'icon': Icons.bookmark_rounded, 'label': 'My Tickets'},
    {'icon': Icons.person_rounded, 'label': 'Profile'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _bgCard,
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.08),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_navItems.length, (index) {
              final item = _navItems[index];
              final isSelected = _selectedIndex == index;
              return MouseRegion(
                onEnter: (_) {},
                child: GestureDetector(
                  onTap: () {
                    setState(() => _selectedIndex = index);
                    switch (index) {
                      case 0:
                        context.go(AppRoutes.customerHome);
                        break;
                      case 1:
                        context.go(AppRoutes.customerAllEvents);
                        break;
                      case 2:
                        context.go(AppRoutes.customerMyTickets);
                        break;
                      case 3:
                        context.go(AppRoutes.customerProfile);
                        break;
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        item['icon'],
                        color: isSelected ? _purpleLight : _textSecondary,
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['label'],
                        style: TextStyle(
                          color: isSelected ? _purpleLight : _textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
