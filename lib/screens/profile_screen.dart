import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import 'auth_dialog.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final service = FirebaseService.instance;
  late TextEditingController _nameController;
  bool _isEditingName = false;
  String _displayName = 'Suresh Punnana';

  // Settings state
  int _householdMembers = 3;
  String _selectedWard = 'Ward 14 - Green Hills Sector';
  bool _dailyReminder = true;
  bool _hapticFeedback = true;
  String _unit = 'kg';

  final List<String> _wards = [
    'Ward 14 - Green Hills Sector',
    'Ward 07 - Eco Smart Township',
    'Ward 21 - Metro Central',
    'Ward 03 - Sunrise Colony',
  ];

  @override
  void initState() {
    super.initState();
    final user = service.currentUser;
    if (user != null && user.email != null && user.email!.isNotEmpty) {
      _displayName = user.email!.split('@').first;
    }
    _nameController = TextEditingController(text: _displayName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String _getLevelName(int points) {
    if (points >= 300) return 'Level 4: Earth Guardian 🌍';
    if (points >= 150) return 'Level 3: Waste Warrior 🛡️';
    if (points >= 50) return 'Level 2: Green Sprout 🌱';
    return 'Level 1: Eco Seedling 🍃';
  }

  double _getLevelProgress(int points) {
    if (points >= 300) return 1.0;
    if (points >= 150) return (points - 150) / 150.0;
    if (points >= 50) return (points - 50) / 100.0;
    return points / 50.0;
  }

  int _getNextTierPoints(int points) {
    if (points >= 300) return 500;
    if (points >= 150) return 300;
    if (points >= 50) return 150;
    return 50;
  }

  @override
  Widget build(BuildContext context) {
    final points = service.cachedPoints;
    final entries = service.currentEntries;
    final totalKg = entries.fold(0.0, (sum, e) => sum + e.quantity);
    final user = service.currentUser;
    final isAnon = user == null || user.isAnonymous;

    return Scaffold(
      backgroundColor: const Color(0xFFF6FAF7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Profile & Settings',
          style: TextStyle(
            color: Color(0xFF18352A),
            fontWeight: FontWeight.w900,
            fontSize: 20,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 36),
        children: [
          // User Profile Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF174C38).withOpacity(0.06),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 34,
                          backgroundColor: const Color(0xFF174C38),
                          child: Text(
                            _displayName.isNotEmpty
                                ? _displayName[0].toUpperCase()
                                : 'E',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Color(0xFF35A879),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.verified_rounded,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_isEditingName)
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _nameController,
                                    autofocus: true,
                                    decoration: const InputDecoration(
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 6, horizontal: 8),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.check,
                                      color: Color(0xFF35A879)),
                                  onPressed: () {
                                    setState(() {
                                      _displayName =
                                          _nameController.text.trim();
                                      _isEditingName = false;
                                    });
                                  },
                                ),
                              ],
                            )
                          else
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _displayName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF18352A),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () =>
                                      setState(() => _isEditingName = true),
                                  child: const Icon(
                                    Icons.edit_rounded,
                                    size: 16,
                                    color: Color(0xFF7D9187),
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(height: 3),
                          Text(
                            isAnon
                                ? 'Guest Explorer (Local Mode)'
                                : user.email ?? 'Verified Member',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF7D9187),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAF7F0),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  service.isFirebaseReady
                                      ? Icons.cloud_done_rounded
                                      : Icons.offline_pin_rounded,
                                  size: 12,
                                  color: const Color(0xFF35A879),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  service.isFirebaseReady
                                      ? 'Cloud Synced'
                                      : 'Local Cache Active',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF174C38),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Tier progress
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6FAF7),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _getLevelName(points),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF18352A),
                            ),
                          ),
                          Text(
                            '$points / ${_getNextTierPoints(points)} pts',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF35A879),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: _getLevelProgress(points),
                          minHeight: 8,
                          backgroundColor: const Color(0xFFE4F5EC),
                          valueColor: const AlwaysStoppedAnimation(
                            Color(0xFF35A879),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Environmental Impact Highlights
          _sectionHeader('Your Lifetime Impact'),
          const SizedBox(height: 10),
          Row(
            children: [
              _impactTile(
                '${totalKg.toStringAsFixed(1)} kg',
                'Waste Sorted',
                Icons.delete_sweep_rounded,
                const Color(0xFF249568),
                const Color(0xFFE4F5EC),
              ),
              const SizedBox(width: 12),
              _impactTile(
                '${(totalKg * 1.4).toStringAsFixed(1)} kg',
                'CO₂ Prevented',
                Icons.co2_rounded,
                const Color(0xFF3986C8),
                const Color(0xFFE8F2FC),
              ),
              const SizedBox(width: 12),
              _impactTile(
                '${(totalKg * 0.05).toStringAsFixed(1)}',
                'Trees Saved',
                Icons.forest_rounded,
                const Color(0xFFB78128),
                const Color(0xFFFBF2DF),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Household Preferences
          _sectionHeader('Household & Waste Settings'),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.people_alt_rounded,
                      color: Color(0xFF174C38)),
                  title: const Text('Household Members'),
                  subtitle: const Text('Calibrates waste benchmarks'),
                  trailing: DropdownButton<int>(
                    value: _householdMembers,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(value: 1, child: Text('1 person')),
                      DropdownMenuItem(value: 2, child: Text('2 people')),
                      DropdownMenuItem(value: 3, child: Text('3-4 people')),
                      DropdownMenuItem(value: 5, child: Text('5+ people')),
                    ],
                    onChanged: (v) =>
                        setState(() => _householdMembers = v ?? 3),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.location_city_rounded,
                      color: Color(0xFF174C38)),
                  title: const Text('Collection Ward / Zone'),
                  subtitle: Text(_selectedWard),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => SimpleDialog(
                        title: const Text('Select Municipal Ward'),
                        children: _wards
                            .map(
                              (w) => SimpleDialogOption(
                                onPressed: () {
                                  setState(() => _selectedWard = w);
                                  Navigator.pop(context);
                                },
                                child: Text(w),
                              ),
                            )
                            .toList(),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.alarm_rounded,
                      color: Color(0xFF174C38)),
                  title: const Text('Morning Reminder (8:00 AM)'),
                  subtitle: const Text('Notification to segregate daily waste'),
                  value: _dailyReminder,
                  activeColor: const Color(0xFF35A879),
                  onChanged: (v) {
                    setState(() => _dailyReminder = v);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(v
                            ? 'Morning reminder set for 8:00 AM'
                            : 'Daily reminders disabled'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.vibration_rounded,
                      color: Color(0xFF174C38)),
                  title: const Text('Haptic Confirmation'),
                  subtitle: const Text('Vibrate on successful AI scan'),
                  value: _hapticFeedback,
                  activeColor: const Color(0xFF35A879),
                  onChanged: (v) => setState(() => _hapticFeedback = v),
                ),
                const Divider(height: 1),
                ListTile(
                  leading:
                      const Icon(Icons.scale_rounded, color: Color(0xFF174C38)),
                  title: const Text('Measurement Units'),
                  trailing: SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'kg', label: Text('kg')),
                      ButtonSegment(value: 'lbs', label: Text('lbs')),
                    ],
                    selected: {_unit},
                    onSelectionChanged: (set) =>
                        setState(() => _unit = set.first),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Account & Cloud Operations
          _sectionHeader('Account & Cloud Sync'),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.sync_rounded,
                      color: Color(0xFF35A879)),
                  title: const Text('Firebase Sync Status'),
                  subtitle: Text(
                    service.isFirebaseReady
                        ? 'Real-time bidirectional synchronization active'
                        : 'Offline cache active (syncs when online)',
                    style: const TextStyle(fontSize: 11),
                  ),
                  trailing: Icon(
                    service.isFirebaseReady
                        ? Icons.check_circle_rounded
                        : Icons.info_outline_rounded,
                    color: const Color(0xFF35A879),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.account_circle_outlined,
                      color: Color(0xFF174C38)),
                  title: Text(isAnon ? 'Link Email / Login' : 'Switch Account'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(24)),
                      ),
                      builder: (context) => const AuthSheet(),
                    ).then((_) => setState(() {}));
                  },
                ),
                if (!isAnon) ...[
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.logout_rounded, color: Colors.red),
                    title: const Text('Sign Out',
                        style: TextStyle(color: Colors.red)),
                    onTap: () async {
                      await service.signOut();
                      setState(() {});
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Signed out')),
                        );
                      }
                    },
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 24),

          // App Details
          const Center(
            child: Column(
              children: [
                Text(
                  'EcoSort • Smart Household Waste Segregator',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7D9187),
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Version 1.0.0 (Release Build) • Material 3',
                  style: TextStyle(fontSize: 10, color: Color(0xFFB0C0B7)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w800,
        color: Color(0xFF18352A),
      ),
    );
  }

  Widget _impactTile(String value, String label, IconData icon, Color color,
      Color pale) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withOpacity(0.14)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: pale,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 14,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: Color(0xFF7D9187),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
