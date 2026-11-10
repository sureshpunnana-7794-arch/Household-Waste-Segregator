import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase_options.dart';
import '../models/waste_entry.dart';

class FirebaseService {
  static final FirebaseService instance = FirebaseService._internal();
  FirebaseService._internal();

  bool _isFirebaseReady = false;
  bool get isFirebaseReady => _isFirebaseReady;

  User? _currentUser;
  User? get currentUser => _currentUser;

  final _entriesController = StreamController<List<WasteEntry>>.broadcast();
  Stream<List<WasteEntry>> get entriesStream => _entriesController.stream;

  List<WasteEntry> _localCache = [
    WasteEntry(
      id: '1',
      type: 0,
      item: 'Vegetable & fruit peels',
      quantity: 0.8,
      date: DateTime.now().subtract(const Duration(hours: 3)),
      userId: 'local',
    ),
    WasteEntry(
      id: '2',
      type: 1,
      item: 'Cardboard & paper packaging',
      quantity: 1.2,
      date: DateTime.now().subtract(const Duration(hours: 6)),
      userId: 'local',
    ),
    WasteEntry(
      id: '3',
      type: 2,
      item: 'Aluminium beverage cans',
      quantity: 0.4,
      date: DateTime.now().subtract(const Duration(days: 1)),
      userId: 'local',
    ),
  ];
  List<WasteEntry> get currentEntries => List.unmodifiable(_localCache);

  int _cachedPoints = 120;
  int get cachedPoints => _cachedPoints;

  StreamSubscription? _firestoreSub;

  Future<void> initialize() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _isFirebaseReady = true;
      debugPrint('[FirebaseService] Firebase initialized successfully');

      FirebaseAuth.instance.authStateChanges().listen((user) {
        _currentUser = user;
        _setupDataStream();
      });

      if (FirebaseAuth.instance.currentUser == null) {
        try {
          await FirebaseAuth.instance.signInAnonymously();
        } catch (e) {
          debugPrint('[FirebaseService] Anonymous sign-in notice: $e');
        }
      }
    } catch (e) {
      _isFirebaseReady = false;
      debugPrint('[FirebaseService] Operating in local offline fallback: $e');
    }

    _entriesController.add(_localCache);
    if (_isFirebaseReady && FirebaseAuth.instance.currentUser != null) {
      _setupDataStream();
    }
  }

  void _setupDataStream() {
    _firestoreSub?.cancel();
    final uid = _currentUser?.uid;
    if (!_isFirebaseReady || uid == null) return;

    try {
      final collection = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('waste_entries')
          .orderBy('date', descending: false);

      _firestoreSub = collection.snapshots().listen((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          final entries = snapshot.docs.map((doc) {
            final data = doc.data();
            return WasteEntry.fromMap(data, doc.id);
          }).toList();
          _localCache = entries;
          _entriesController.add(_localCache);
        }
      }, onError: (err) {
        debugPrint('[FirebaseService] Firestore snapshot fallback: $err');
        _entriesController.add(_localCache);
      });

      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .snapshots()
          .listen((doc) {
        if (doc.exists && doc.data()?['points'] != null) {
          _cachedPoints = (doc.data()!['points'] as num).toInt();
        }
      }, onError: (_) {});
    } catch (e) {
      debugPrint('[FirebaseService] Firestore setup error: $e');
    }
  }

  Future<void> addEntry({
    required int type,
    required String item,
    required double quantity,
  }) async {
    final uid = _currentUser?.uid ?? 'local_user';
    final newId = DateTime.now().millisecondsSinceEpoch.toString();
    final entry = WasteEntry(
      id: newId,
      type: type,
      item: item,
      quantity: quantity,
      date: DateTime.now(),
      userId: uid,
    );

    _localCache.add(entry);
    _cachedPoints += 10;
    _entriesController.add(List.from(_localCache));

    if (_isFirebaseReady && _currentUser != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_currentUser!.uid)
            .collection('waste_entries')
            .doc(newId)
            .set(entry.toMap());

        await FirebaseFirestore.instance
            .collection('users')
            .doc(_currentUser!.uid)
            .set({
          'points': _cachedPoints,
          'lastActive': FieldValue.serverTimestamp(),
          'email': _currentUser!.email ?? 'Anonymous User',
        }, SetOptions(merge: true));
      } catch (e) {
        debugPrint('[FirebaseService] Cloud sync notice: $e');
      }
    }
  }

  Future<void> deleteEntry(String entryId) async {
    _localCache.removeWhere((e) => e.id == entryId);
    _entriesController.add(List.from(_localCache));

    if (_isFirebaseReady && _currentUser != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_currentUser!.uid)
            .collection('waste_entries')
            .doc(entryId)
            .delete();
      } catch (e) {
        debugPrint('[FirebaseService] Delete error: $e');
      }
    }
  }

  Future<void> completeChallenge(int bonusPoints) async {
    _cachedPoints += bonusPoints;
    if (_isFirebaseReady && _currentUser != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_currentUser!.uid)
            .set({'points': _cachedPoints}, SetOptions(merge: true));
      } catch (_) {}
    }
  }

  Future<String?> signInWithEmail(String email, String password) async {
    if (!_isFirebaseReady) return null;
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Authentication failed';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> signUpWithEmail(String email, String password) async {
    if (!_isFirebaseReady) return null;
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Registration failed';
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> signOut() async {
    if (_isFirebaseReady) {
      await FirebaseAuth.instance.signOut();
    }
    _currentUser = null;
    _setupDataStream();
  }
}
