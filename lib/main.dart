import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'models/waste_entry.dart';
import 'services/firebase_service.dart';
import 'screens/photo_scan_screen.dart';
import 'screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.instance.initialize();
  runApp(const EcoSortApp());
}

const forest = Color(0xFF174C38);
const leaf = Color(0xFF35A879);
const mint = Color(0xFFEAF7F0);
const ink = Color(0xFF18352A);
const muted = Color(0xFF7D9187);

class EcoSortApp extends StatelessWidget {
  const EcoSortApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EcoSort - Household Waste Segregator',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF6FAF7),
        colorScheme: ColorScheme.fromSeed(
          seedColor: leaf,
          brightness: Brightness.light,
        ),
        fontFamily: 'Roboto',
      ),
      home: const EcoHome(),
    );
  }
}

class EcoHome extends StatefulWidget {
  const EcoHome({super.key});
  @override
  State<EcoHome> createState() => _EcoHomeState();
}

class _EcoHomeState extends State<EcoHome> {
  int tab = 0;
  bool challengeCompleted = false;
  final service = FirebaseService.instance;

  double get total =>
      service.currentEntries.fold(0, (sum, e) => sum + e.quantity);

  double byType(int type) => service.currentEntries
      .where((e) => e.type == type)
      .fold(0, (s, e) => s + e.quantity);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<WasteEntry>>(
      stream: service.entriesStream,
      initialData: service.currentEntries,
      builder: (context, snapshot) {
        final pages = [
          _dashboard(),
          _segregate(),
          _guide(),
          _impact(),
          const ProfileScreen(),
        ];
        return Scaffold(
          body: SafeArea(
            child: IndexedStack(
              index: tab.clamp(0, pages.length - 1),
              children: pages,
            ),
          ),
          floatingActionButton: tab == 0 || tab == 1
              ? FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PhotoScanScreen(),
                      ),
                    ).then((_) => setState(() {}));
                  },
                  backgroundColor: forest,
                  foregroundColor: Colors.white,
                  icon: const Icon(Icons.document_scanner_rounded),
                  label: const Text(
                    'Smart Scan',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              : null,
          bottomNavigationBar: NavigationBar(
            height: 72,
            selectedIndex: tab,
            onDestinationSelected: (v) {
              if (v == 2) {
                // Tapping Center Scanner opens photo scan
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PhotoScanScreen(),
                  ),
                ).then((_) => setState(() {}));
              } else {
                setState(() => tab = v);
              }
            },
            backgroundColor: Colors.white,
            indicatorColor: mint,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.grid_view_rounded),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.delete_sweep_rounded),
                label: 'Segregate',
              ),
              NavigationDestination(
                icon: Icon(Icons.camera_alt_rounded),
                label: 'Scan',
              ),
              NavigationDestination(
                icon: Icon(Icons.menu_book_rounded),
                label: 'Guide',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_rounded),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _dashboard() {
    final entries = service.currentEntries;
    final user = service.currentUser;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 80),
      children: [
        Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: forest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.energy_savings_leaf_rounded,
                color: Colors.white,
                size: 27,
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'EcoSort',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w900,
                      color: ink,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        service.isFirebaseReady
                            ? Icons.cloud_done_rounded
                            : Icons.offline_bolt_rounded,
                        size: 12,
                        color: leaf,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        service.isFirebaseReady
                            ? 'Firebase Live Sync'
                            : 'Local Storage Ready',
                        style: const TextStyle(fontSize: 10, color: muted),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            CircleAvatar(
              backgroundColor: mint,
              child: IconButton(
                tooltip: 'Profile & Settings',
                onPressed: () => setState(() => tab = 4),
                icon: Icon(
                  user != null && !user.isAnonymous
                      ? Icons.person_rounded
                      : Icons.person_outline_rounded,
                  color: forest,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Hero Card
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF174C38), Color(0xFF2D9068)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(26),
            boxShadow: [
              BoxShadow(
                color: forest.withOpacity(.16),
                blurRadius: 20,
                offset: const Offset(0, 9),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'MAKE EVERY\nWASTE COUNT.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        height: 1.12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: .4,
                      ),
                    ),
                  ),
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.14),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.recycling_rounded,
                      color: Colors.white,
                      size: 43,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 13),
              Text(
                'You have recorded ${total.toStringAsFixed(1)} kg of household waste.',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(height: 17),
              Row(
                children: [
                  _heroMetric('${service.cachedPoints}', 'ECO POINTS'),
                  const SizedBox(width: 25),
                  _heroMetric('${entries.length}', 'ENTRIES'),
                  const Spacer(),
                  FilledButton.tonal(
                    onPressed: () => setState(() => tab = 1),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: forest,
                    ),
                    child: const Text('Add waste'),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        // Smart Photo Scan Card Banner
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF101F18), Color(0xFF1A3D2D)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: leaf.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.camera_alt_rounded,
                  color: Color(0xFF68D391),
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Smart AI Photo Scanner',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Scan items with camera to auto-classify & earn points',
                      style: TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                  ],
                ),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PhotoScanScreen(),
                    ),
                  ).then((_) => setState(() {}));
                },
                style: FilledButton.styleFrom(
                  backgroundColor: leaf,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                child: const Text('Scan'),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),
        _sectionTitle('Your waste at a glance', 'TODAY'),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: kWasteTypes.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.55,
          ),
          itemBuilder: (context, i) {
            final w = kWasteTypes[i];
            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(19),
                border: Border.all(color: w.color.withOpacity(.12)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: w.pale,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(w.icon, color: w.color, size: 18),
                      ),
                      const Spacer(),
                      Icon(Icons.arrow_outward_rounded,
                          color: w.color, size: 15),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    '${byType(i).toStringAsFixed(1)} kg',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 19,
                      color: ink,
                    ),
                  ),
                  Text(
                    w.name,
                    style: const TextStyle(
                      fontSize: 11,
                      color: muted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        _sectionTitle('Today’s eco challenge', 'DAILY'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF8E9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE9B8),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.emoji_events_rounded,
                  color: Color(0xFFB78128),
                  size: 25,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Plastic-free evening',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: ink,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      challengeCompleted
                          ? 'Completed! Earned +20 points.'
                          : 'Avoid single-use plastic today to earn bonus points.',
                      style: const TextStyle(fontSize: 11, color: muted),
                    ),
                  ],
                ),
              ),
              if (!challengeCompleted)
                FilledButton.tonal(
                  onPressed: () async {
                    await service.completeChallenge(20);
                    setState(() => challengeCompleted = true);
                    _message('Challenge completed! +20 Eco Points earned.');
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFFFE9B8),
                    foregroundColor: const Color(0xFFB78128),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                  child: const Text('Claim +20'),
                )
              else
                const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFFB78128),
                ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _sectionTitle('Recent activity', 'LATEST'),
        const SizedBox(height: 8),
        if (entries.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'No waste entries yet. Add your first entry!',
              style: TextStyle(color: muted),
            ),
          )
        else
          ...entries.reversed.take(5).map((e) => _activityTile(e)),
      ],
    );
  }

  Widget _heroMetric(String value, String label) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 9,
              letterSpacing: 1,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      );

  Widget _sectionTitle(String title, String tag) => Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: ink,
              ),
            ),
          ),
          Text(
            tag,
            style: const TextStyle(
              color: muted,
              fontSize: 9,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      );

  Widget _segregate() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 80),
      children: [
        const Text(
          'Sort your waste',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: ink,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'Choose a category or use smart AI camera scanner.',
          style: TextStyle(color: muted, fontSize: 13),
        ),
        const SizedBox(height: 18),

        // Interactive Smart Scan Launcher
        InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const PhotoScanScreen(),
              ),
            ).then((_) => setState(() {}));
          },
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF174C38), Color(0xFF28795A)],
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.document_scanner_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Launch Smart Photo Scan',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Camera / Gallery automatic waste recognition',
                        style: TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white70,
                  size: 16,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        ...List.generate(kWasteTypes.length, (i) {
          final w = kWasteTypes[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => _addEntry(i),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: w.color.withOpacity(.16)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: w.pale,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(w.icon, color: w.color, size: 27),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            w.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: ink,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            w.examples,
                            style:
                                const TextStyle(fontSize: 11, color: muted),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${byType(i).toStringAsFixed(1)} kg',
                          style: TextStyle(
                            color: w.color,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Icon(
                          Icons.add_circle_rounded,
                          color: leaf,
                          size: 22,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _guide() {
    final tips = [
      [
        'Wet waste',
        'Keep food scraps in a covered green bin. Compost fruit and vegetable peels where possible.',
        Icons.eco_rounded,
        kWasteTypes[0].color
      ],
      [
        'Dry waste',
        'Keep paper, cardboard and plastic clean and dry. Rinse containers before recycling.',
        Icons.inventory_2_rounded,
        kWasteTypes[1].color
      ],
      [
        'Metallic waste',
        'Separate metal cans and scrap. Store sharp edges safely before handing them over.',
        Icons.hardware_rounded,
        kWasteTypes[2].color
      ],
      [
        'Sanitary waste',
        'Wrap sanitary waste securely and follow your local municipal collection instructions.',
        Icons.health_and_safety_rounded,
        kWasteTypes[3].color
      ],
    ];
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 80),
      children: [
        const Text(
          'Disposal guide',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: ink,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'Small habits. A big difference.',
          style: TextStyle(color: muted, fontSize: 13),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            color: mint,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            children: [
              Icon(Icons.lightbulb_rounded, color: leaf, size: 30),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Remember: segregate waste at the source. Never mix sanitary waste with recyclables.',
                  style: TextStyle(
                    color: forest,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        ...tips.map(
          (t) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    color: (t[3] as Color).withOpacity(.12),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(t[2] as IconData, color: t[3] as Color),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t[0] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          color: ink,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        t[1] as String,
                        style: const TextStyle(
                          color: muted,
                          fontSize: 12,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const Text(
          'Local disposal rules may differ. Follow your municipal waste collection guidance.',
          style: TextStyle(color: muted, fontSize: 10),
        ),
      ],
    );
  }

  Widget _impact() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 80),
      children: [
        const Text(
          'Your green impact',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: ink,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'See how your household is building better habits.',
          style: TextStyle(color: muted, fontSize: 13),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: forest,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'TOTAL WASTE RECORDED',
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 10,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${total.toStringAsFixed(1)} kg',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Every separated item is a step towards a cleaner community.',
                style: TextStyle(color: Colors.white70, fontSize: 11),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        const Text(
          'Category distribution',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: ink,
          ),
        ),
        const SizedBox(height: 14),
        ...List.generate(kWasteTypes.length, (i) {
          final w = kWasteTypes[i];
          final ratio = total == 0 ? 0.0 : byType(i) / total;
          return Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(w.icon, color: w.color, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        w.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: ink,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Text(
                      '${byType(i).toStringAsFixed(1)} kg',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: ink,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: ratio,
                    minHeight: 9,
                    backgroundColor: w.pale,
                    valueColor: AlwaysStoppedAnimation(w.color),
                  ),
                ),
              ],
            ),
          );
        }),
        Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F2FC),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            children: [
              Icon(Icons.public_rounded, color: Color(0xFF3986C8), size: 30),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'All data is synchronized with Firebase and backed by offline local cache.',
                  style: TextStyle(color: ink, fontSize: 11, height: 1.4),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Collection planner',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: ink,
          ),
        ),
        const SizedBox(height: 10),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 14),
          tileColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          leading: const CircleAvatar(
            backgroundColor: mint,
            child: Icon(Icons.calendar_month_rounded, color: forest),
          ),
          title: const Text(
            'Plan a waste pickup',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          ),
          subtitle: const Text(
            'Schedule a collection day reminder',
            style: TextStyle(fontSize: 10, color: muted),
          ),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: _schedulePickupDialog,
        ),
      ],
    );
  }

  Widget _activityTile(WasteEntry e) {
    final w = kWasteTypes[e.type];
    final dateStr = DateFormat('MMM d, h:mm a').format(e.date);

    return Dismissible(
      key: Key(e.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red.shade100,
        child: const Icon(Icons.delete_outline, color: Colors.red),
      ),
      onDismissed: (_) {
        service.deleteEntry(e.id);
        _message('Entry removed');
      },
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        leading: CircleAvatar(
          backgroundColor: w.pale,
          child: Icon(w.icon, color: w.color, size: 19),
        ),
        title: Text(
          e.item,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13,
            color: ink,
          ),
        ),
        subtitle: Text(
          '${w.name} • $dateStr',
          style: const TextStyle(fontSize: 10, color: muted),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${e.quantity.toStringAsFixed(1)} kg',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: w.color,
                fontSize: 12,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 18, color: muted),
              onPressed: () {
                service.deleteEntry(e.id);
                _message('Entry removed');
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addEntry(int type) async {
    final itemController = TextEditingController();
    final qtyController = TextEditingController(text: '0.5');
    final w = kWasteTypes[type];

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add ${w.name.toLowerCase()}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: itemController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Waste item',
                hintText: 'e.g. Vegetable peels, carton',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: qtyController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Quantity (kg)',
                hintText: '0.5',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final q = double.tryParse(qtyController.text.trim());
              final name = itemController.text.trim();
              if (name.isEmpty || q == null || q <= 0) return;
              service.addEntry(type: type, item: name, quantity: q);
              Navigator.pop(context, true);
            },
            child: const Text('Save entry'),
          ),
        ],
      ),
    );

    itemController.dispose();
    qtyController.dispose();

    if (result == true && mounted) {
      _message('Waste recorded! You earned 10 Eco Points.');
    }
  }

  Future<void> _schedulePickupDialog() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (date != null && mounted) {
      _message(
        'Pickup scheduled for ${DateFormat('EEEE, MMM d').format(date)}! Reminder set.',
      );
    }
  }

  void _message(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
