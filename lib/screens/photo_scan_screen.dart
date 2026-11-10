import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/waste_entry.dart';
import '../services/ai_classifier_service.dart';
import '../services/firebase_service.dart';

class PhotoScanScreen extends StatefulWidget {
  const PhotoScanScreen({super.key});

  @override
  State<PhotoScanScreen> createState() => _PhotoScanScreenState();
}

class _PhotoScanScreenState extends State<PhotoScanScreen>
    with SingleTickerProviderStateMixin {
  final _picker = ImagePicker();
  XFile? _selectedImage;
  Uint8List? _imageBytes;
  WastePreset? _selectedPreset;
  bool _isAnalyzing = false;
  String _statusText = 'Align waste item within the frame';
  ScanResult? _result;
  late AnimationController _animController;
  late Animation<double> _scanAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _scanAnimation = Tween<double>(begin: 0.05, end: 0.95).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final file = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (file != null) {
        final bytes = await file.readAsBytes();
        setState(() {
          _selectedImage = file;
          _imageBytes = bytes;
          _selectedPreset = null;
          _result = null;
        });
        _runClassification(file: file);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Camera/Gallery access: $e')),
      );
    }
  }

  Future<void> _selectPreset(WastePreset preset) async {
    setState(() {
      _selectedPreset = preset;
      _selectedImage = null;
      _imageBytes = null;
      _result = null;
    });
    _runClassification(preset: preset);
  }

  Future<void> _runClassification({XFile? file, WastePreset? preset}) async {
    setState(() {
      _isAnalyzing = true;
      _statusText = 'Analyzing visual texture & contours...';
    });

    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() => _statusText = 'Matching municipal segregation norms...');
    }

    final res = await AiClassifierService.instance.classifyImage(
      file: file,
      preset: preset,
    );

    if (mounted) {
      setState(() {
        _isAnalyzing = false;
        _result = res;
        _statusText = 'Classification completed!';
      });
    }
  }

  Future<void> _saveScannedEntry() async {
    if (_result == null) return;
    final r = _result!;
    await FirebaseService.instance.addEntry(
      type: r.wasteType,
      item: r.itemName,
      quantity: r.estimatedWeight,
    );
    await FirebaseService.instance.completeChallenge(r.ecoPointsEarned);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF174C38),
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Recorded "${r.itemName}"! Earned +${r.ecoPointsEarned} Eco Points.',
          ),
        ),
      );
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101F18),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Smart AI Waste Scanner',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Camera / Gallery Instructions',
            icon: const Icon(Icons.info_outline_rounded, color: Colors.white70),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('AI Vision Scanner'),
                  content: const Text(
                    'Position any household waste item in the viewfinder, or choose a photo from your gallery. '
                    'Our classifier automatically detects material composition, points to the correct municipal bin, and estimates item weight.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Got it'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            // Viewfinder Container
            Container(
              height: 290,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: _isAnalyzing
                      ? const Color(0xFF35A879)
                      : Colors.white.withOpacity(0.2),
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background Content: Image or Preset Emoji or Camera Prompt
                    if (_imageBytes != null)
                      Image.memory(
                        _imageBytes!,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      )
                    else if (_selectedPreset != null)
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _selectedPreset!.emoji,
                              style: const TextStyle(fontSize: 84),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _selectedPreset!.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.document_scanner_rounded,
                            size: 64,
                            color: Colors.white.withOpacity(0.5),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Point camera or upload a photo',
                            style: TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Or try sample presets below',
                            style: TextStyle(color: Colors.white38, fontSize: 11),
                          ),
                        ],
                      ),

                    // Laser Scanning Bar (visible when analyzing or idle)
                    AnimatedBuilder(
                      animation: _scanAnimation,
                      builder: (context, child) {
                        return Positioned(
                          top: 290 * _scanAnimation.value,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 3,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  _isAnalyzing
                                      ? const Color(0xFF35A879)
                                      : const Color(0xFF3986C8),
                                  Colors.transparent,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: (_isAnalyzing
                                          ? const Color(0xFF35A879)
                                          : const Color(0xFF3986C8))
                                      .withOpacity(0.8),
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    // Top Status Ticker
                    Positioned(
                      top: 14,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.65),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_isAnalyzing)
                              const Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: SizedBox(
                                  width: 12,
                                  height: 12,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Color(0xFF35A879),
                                  ),
                                ),
                              )
                            else
                              const Padding(
                                padding: EdgeInsets.only(right: 6),
                                child: Icon(
                                  Icons.radar_rounded,
                                  size: 14,
                                  color: Color(0xFF35A879),
                                ),
                              ),
                            Text(
                              _statusText,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Capture Controls
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _isAnalyzing
                        ? null
                        : () => _pickImage(ImageSource.camera),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF174C38),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: const Icon(Icons.camera_alt_rounded),
                    label: const Text('Take Photo'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isAnalyzing
                        ? null
                        : () => _pickImage(ImageSource.gallery),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white30),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: const Icon(Icons.photo_library_rounded),
                    label: const Text('Gallery'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Demo Preset Chips
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Instant Test Samples:',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: kDemoPresets.map((p) {
                  final isSelected = _selectedPreset?.name == p.name;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      selected: isSelected,
                      label: Text('${p.emoji} ${p.name.split(' ').first}'),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.white70,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                      backgroundColor: Colors.white.withOpacity(0.08),
                      selectedColor: const Color(0xFF174C38),
                      checkmarkColor: Colors.white,
                      side: BorderSide(
                        color: isSelected
                            ? const Color(0xFF35A879)
                            : Colors.white12,
                      ),
                      onSelected: _isAnalyzing ? null : (_) => _selectPreset(p),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            // AI Result Card
            if (_result != null) _buildResultCard(_result!),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(ScanResult r) {
    final w = kWasteTypes[r.wasteType];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: w.pale,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(w.icon, color: w.color, size: 26),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      r.itemName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF18352A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          w.name,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: w.color,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAF7F0),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${(r.confidence * 100).toStringAsFixed(1)}% match',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF174C38),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Text(
                      'EST. WEIGHT',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFB78128),
                      ),
                    ),
                    Text(
                      '${r.estimatedWeight} kg',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFB78128),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 14),

          // Bin & Recyclability highlight
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: w.pale,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Icon(Icons.delete_rounded, color: w.color, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Deposit into: ${r.binColorName}',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: w.color,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Segregation tips
          const Text(
            'Recommended Segregation Steps:',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: Color(0xFF18352A),
            ),
          ),
          const SizedBox(height: 6),
          ...r.instructions.map(
            (tip) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ',
                      style: TextStyle(
                          color: Color(0xFF35A879),
                          fontWeight: FontWeight.bold)),
                  Expanded(
                    child: Text(
                      tip,
                      style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF7D9187),
                          height: 1.3),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 18),

          // Record waste action button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton.icon(
              onPressed: _saveScannedEntry,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF174C38),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.add_task_rounded),
              label: Text(
                'Record Waste (+${r.ecoPointsEarned} Eco Points)',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
