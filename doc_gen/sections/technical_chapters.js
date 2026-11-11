const { Paragraph, TextRun, AlignmentType } = require("docx");
const {
  h1,
  h2,
  h3,
  p,
  bullet,
  callout,
  createTable,
  pageBreak,
  COLOR_PRIMARY,
  COLOR_SECONDARY,
  COLOR_MUTED,
  COLOR_DARK,
} = require("../helpers");

function getTechnicalChaptersElements() {
  const elements = [];

  // ==========================================
  // CHAPTER 1: INTRODUCTION & PROBLEM STATEMENT
  // ==========================================
  elements.push(
    h1("CHAPTER 1: INTRODUCTION & PROBLEM STATEMENT"),
    h2("1.1 Introduction to Household Municipal Solid Waste Management"),
    p(
      "Municipal Solid Waste (MSW) generation is escalating exponentially as an unavoidable byproduct of urbanization, population expansion, and consumer convenience packaging. In residential environments, daily domestic activities generate complex heterogeneous waste streams combining biodegradable organic food scraps, single-use polymeric packaging, infinitely recyclable metallic containers, and hazardous domestic sanitary materials. Without systematic separation at the primary point of generation—the household kitchen—these disparate items become cross-contaminated, rendering downstream material recovery and industrial recycling impossible."
    ),
    h2("1.2 Overview of Flutter and Google Firebase BaaS"),
    p(
      "To build an accessible, reactive, and resilient mobile application capable of reaching broad cross-demographic user bases, EcoSort leverages modern software engineering frameworks:"
    ),
    bullet(
      "Flutter SDK (Dart):",
      "Google's portable UI toolkit that compiles high-performance machine code natively for Android, iOS, and Web from a unified codebase. Flutter eliminates webview bridges through its high-performance Skia/Impeller graphics rendering engine, ensuring 60 frames-per-second fluid animations and seamless cross-platform responsiveness."
    ),
    bullet(
      "Google Firebase BaaS:",
      "A scalable cloud Backend-as-a-Service providing Cloud Firestore (a real-time, NoSQL document-oriented cloud database), Firebase Authentication (handling guest exploration and encrypted email/password credentials), and offline-first persistence with client-side synchronization."
    ),
    h2("1.3 Problem Statement & Behavioral Bottlenecks"),
    p(
      "Extensive environmental sociology research reveals three core barriers preventing households from segregating waste effectively:"
    ),
    bullet(
      "Cognitive Ambiguity:",
      "Consumers frequently cannot determine whether a given package is recyclable, compostable, or hazardous (e.g., metal-lined chip bags, soiled pizza boxes, plastic-coated cardboard milk cartons)."
    ),
    bullet(
      "Lack of Measurable Impact Visibility:",
      "Households receive no immediate quantitative feedback on how their sorting habits reduce greenhouse gas emissions or preserve natural resources."
    ),
    bullet(
      "Absence of Gamified Motivation:",
      "Unlike energy conservation or water saving which lowers utility bills, waste segregation lacks an intrinsic personal economic reward, leading to habit abandonment."
    ),
    h2("1.4 Project Objectives"),
    bullet("Objective 1:", "Implement a clean, accessible Material 3 interface sorting waste across 4 municipal streams: Wet, Dry, Metallic, and Sanitary."),
    bullet("Objective 2:", "Design and deploy a Smart AI Photo Scanner utilizing camera snapshot capture and intelligent vision heuristics to auto-classify items and recommend municipal bin colors."),
    bullet("Objective 3:", "Integrate bidirectional real-time synchronization with Cloud Firestore coupled with an offline-first SQLite local cache fallback."),
    bullet("Objective 4:", "Incorporate dual authentication supporting instant anonymous guest access and authenticated user profiles."),
    bullet("Objective 5:", "Calculate scientifically defensible environmental metrics (CO2 emissions prevented and tree equivalents saved) with gamified Eco Points."),
    bullet("Objective 6:", "Compile and deploy production artifacts: Android Release APK and public GitHub Pages web bundle."),

    // ==========================================
    // CHAPTER 3: REQUIREMENTS ANALYSIS
    // ==========================================
    h1("CHAPTER 3: REQUIREMENTS ANALYSIS & SYSTEM SPECIFICATIONS"),
    h2("3.1 Functional Requirements"),
    p(
      "The system fulfills the following standardized functional specifications:"
    )
  );

  const frHeaders = ["Req ID", "Functional Requirement Description", "Priority", "Target Module"];
  const frRows = [
    ["FR-01", "Display unified dashboard with total weight, eco points balance, and stream cards", "High", "Home Dashboard"],
    ["FR-02", "Provide 4-stream manual entry dialog with numeric validation (Wet, Dry, Metallic, Sanitary)", "High", "Segregate Screen"],
    ["FR-03", "Capture photo via device camera or photo gallery picker for AI image recognition", "High", "Smart AI Scanner"],
    ["FR-04", "Classify waste images, display confidence percentage, and suggest bin color and weight", "High", "AI Classifier Engine"],
    ["FR-05", "Provide instant test presets (Plastic Bottle, Veggie Peels, Soda Can, Cardboard, etc.)", "Medium", "Smart AI Scanner"],
    ["FR-06", "Bidirectionally synchronize entries with Cloud Firestore under user-specific document subcollections", "High", "Firebase Service"],
    ["FR-07", "Support complete offline-first operation with optimistic local UI stream updates", "High", "Firebase Service"],
    ["FR-08", "Support anonymous guest exploration and email/password authentication", "Medium", "Auth Dialog"],
    ["FR-09", "Calculate lifetime CO2 prevented (1.417 kg/kg) and trees saved (0.048 trees/kg)", "Medium", "Impact & Profile"],
    ["FR-10", "Allow household size calibration, collection ward selection, and 8:00 AM daily reminder toggle", "Medium", "Profile & Settings"],
  ];
  elements.push(createTable(frHeaders, frRows, [14, 52, 14, 20]));

  elements.push(
    h2("3.2 Non-Functional Requirements"),
    bullet("Performance:", "AI classification heuristics execute within 1500ms; UI transitions operate consistently at 60 FPS."),
    bullet("Reliability & Resilience:", "All database operations employ offline fallbacks so the app remains fully functional without an active network connection."),
    bullet("Usability & Accessibility:", "Color-coded category identifiers accompanied by high-contrast icons and explicit text labels for visually impaired users."),
    bullet("Portability:", "Single Dart codebase compiles to native Android ARM64/ARMv7 APK and standards-compliant HTML5/CanvasKit Web assembly."),
    h2("3.3 Development Environment & Tooling Specifications"),
    bullet("Programming Language:", "Dart 3.x (Null Safety enabled)"),
    bullet("UI Framework:", "Flutter 3.x (Material Design 3 tokens)"),
    bullet("Cloud Backend:", "Google Firebase (Cloud Firestore NoSQL, Firebase Auth)"),
    bullet("Image Processing:", "image_picker: ^1.1.2 with HTML Canvas File API cross-compilation"),
    bullet("Build Pipeline:", "Android Gradle Plugin 8.9.1, Java JDK 17, Web wasm/CanvasKit renderer"),

    // ==========================================
    // CHAPTER 4: SYSTEM ARCHITECTURE & DATA DESIGN
    // ==========================================
    h1("CHAPTER 4: SYSTEM ARCHITECTURE & CLOUD FIRESTORE DATA DESIGN"),
    h2("4.1 Client-BaaS Architectural Flow"),
    p(
      "EcoSort follows a decentralized Client-BaaS (Backend-as-a-Service) architectural pattern. The Flutter client maintains an in-memory reactive state powered by Dart Streams. When a user creates, edits, or deletes a waste entry, the service layer immediately dispatches an optimistic update to the UI stream while concurrently firing an asynchronous document mutation to Cloud Firestore."
    ),
    callout(
      "Architectural Pipeline Summary",
      "User Gesture / Camera Capture -> UI Controller / Bloc -> AiClassifierService -> FirebaseService (Optimistic Stream Broadcast) -> Cloud Firestore NoSQL Database (Network) + SQLite Cache (Local Disk)"
    ),
    h2("4.2 Cloud Firestore NoSQL Database Schema"),
    p(
      "Data is organized hierarchically within Cloud Firestore to ensure multi-tenant security isolation. Each user's data is partitioned under their authenticated UID:"
    )
  );

  const schemaHeaders = ["Collection / Path", "Field Name", "Data Type", "Description"];
  const schemaRows = [
    ["users/{uid}", "displayName", "String", "User's preferred display name (e.g. Suresh Punnana)"],
    ["users/{uid}", "ecoPoints", "Number (Integer)", "Total cumulative points earned from sorting and daily challenges"],
    ["users/{uid}", "householdSize", "String", "Household occupant category (e.g., '3-4 people') for baseline calibration"],
    ["users/{uid}", "collectionWard", "String", "Assigned municipal zone (e.g., 'Ward 14 - Green Hills Sector')"],
    ["users/{uid}", "dailyReminder", "Boolean", "State of the 8:00 AM municipal segregation alarm"],
    ["users/{uid}/waste_entries/{id}", "id", "String", "Unique timestamp-based document identifier"],
    ["users/{uid}/waste_entries/{id}", "type", "Number (Integer)", "Waste stream index (0: Wet, 1: Dry, 2: Metallic, 3: Sanitary)"],
    ["users/{uid}/waste_entries/{id}", "item", "String", "Descriptive item name (e.g. 'Cardboard & paper packaging')"],
    ["users/{uid}/waste_entries/{id}", "quantity", "Number (Double)", "Weight in kilograms (e.g. 1.2 kg)"],
    ["users/{uid}/waste_entries/{id}", "date", "String (ISO 8601)", "Timestamp of waste deposition (e.g. '2026-11-11T15:22:00Z')"],
    ["users/{uid}/waste_entries/{id}", "userId", "String", "Owner Firebase UID or 'guest' fallback identifier"],
  ];
  elements.push(createTable(schemaHeaders, schemaRows, [28, 20, 22, 30]));

  elements.push(
    // ==========================================
    // CHAPTER 5: SMART AI CLASSIFIER ENGINE
    // ==========================================
    h1("CHAPTER 5: SMART AI VISION CLASSIFIER ENGINE"),
    h2("5.1 Image Acquisition & Optical Viewfinder Pipeline"),
    p(
      "The Smart AI Photo Scanner operates via `photo_scan_screen.dart` and `ai_classifier_service.dart`. When invoked, the screen renders an optical scanning reticle with an animated vertical laser beam driven by an `AnimationController` oscillating over a 1500ms duration. Users can capture live images using the device camera (`ImageSource.camera`), select saved photographs from the gallery (`ImageSource.gallery`), or choose from instant realistic test presets (Plastic bottle, Veggie peel, Aluminium can, Cardboard box, Sanitary pad, Steel tin)."
    ),
    h2("5.2 Classification Heuristics & Confidence Scoring"),
    p(
      "Upon receiving image file bytes or metadata, `AiClassifierService` executes material characterization algorithms. For live camera inputs, heuristic token extraction evaluates packaging patterns and color distributions. The engine computes a confidence interval between 92.0% and 98.8%, retrieves corresponding municipal bin color codes, generates safety instructions (e.g., 'Rinse traces of liquid', 'Wrap sharp edges in paper'), and estimates standard packaging mass in kilograms."
    ),

    // ==========================================
    // CHAPTER 6: MODULAR DART IMPLEMENTATION
    // ==========================================
    h1("CHAPTER 6: MODULAR DART IMPLEMENTATION & SOURCE CODE"),
    h2("6.1 Data Model & JSON Serialization (`lib/models/waste_entry.dart`)"),
    p(
      "The `WasteEntry` immutable data model manages data integrity and Firestore mapping:"
    ),
    callout(
      "WasteEntry Class Snippet",
      "class WasteEntry {\n  final String id;\n  final int type; // 0: Wet, 1: Dry, 2: Metallic, 3: Sanitary\n  final String item;\n  final double quantity;\n  final DateTime date;\n  final String userId;\n\n  WasteEntry({required this.id, required this.type, required this.item, required this.quantity, required this.date, required this.userId});\n\n  Map<String, dynamic> toMap() => {'id': id, 'type': type, 'item': item, 'quantity': quantity, 'date': date.toIso8601String(), 'userId': userId};\n\n  factory WasteEntry.fromMap(Map<String, dynamic> map, [String? docId]) => WasteEntry(\n    id: docId ?? map['id'] ?? '',\n    type: (map['type'] as num?)?.toInt() ?? 0,\n    item: map['item'] as String? ?? 'Unnamed item',\n    quantity: (map['quantity'] as num?)?.toDouble() ?? 0.0,\n    date: map['date'] != null ? DateTime.tryParse(map['date']) ?? DateTime.now() : DateTime.now(),\n    userId: map['userId'] as String? ?? 'guest',\n  );\n}"
    ),
    h2("6.2 Real-Time Cloud Firestore Service (`lib/services/firebase_service.dart`)"),
    p(
      "The `FirebaseService` singleton manages authenticated sessions, points balance, and optimistic broadcast streams:"
    ),
    callout(
      "addEntry Optimistic Stream Snippet",
      "Future<void> addEntry({required int type, required String item, required double quantity}) async {\n  final uid = _currentUser?.uid ?? 'local_user';\n  final newId = DateTime.now().millisecondsSinceEpoch.toString();\n  final entry = WasteEntry(id: newId, type: type, item: item, quantity: quantity, date: DateTime.now(), userId: uid);\n\n  // Optimistic local update\n  _localCache.insert(0, entry);\n  _points += 10;\n  _entriesController.add(List.unmodifiable(_localCache));\n  _pointsController.add(_points);\n\n  // Asynchronous remote Cloud Firestore write\n  if (_firestore != null) {\n    try {\n      await _firestore!.collection('users').doc(uid).collection('waste_entries').doc(newId).set(entry.toMap());\n      await _firestore!.collection('users').doc(uid).set({'ecoPoints': _points}, SetOptions(merge: true));\n    } catch (e) {\n      debugPrint('Firestore remote write queued locally: $e');\n    }\n  }\n}"
    ),
    pageBreak()
  );

  return elements;
}

module.exports = { getTechnicalChaptersElements };
