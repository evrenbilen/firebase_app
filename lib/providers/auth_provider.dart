import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_app/services/firebase_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseService _service;
  User? _user;

  bool _isLoading = false;
  bool _isAuthenticated = false;

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  FirebaseService get firebaseService => _service; // Add this getter

  User? get user => _user;

  AuthProvider() : _service = FirebaseService(clientId: _getClientId()) {
    _authSubscription();
  }

  static String? _getClientId() {
    if (kIsWeb) {
      return dotenv.env['WEB_GOOGLE_CLIENT_ID'];
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return dotenv.env['ANDROID_GOOGLE_CLIENT_ID'];
      case TargetPlatform.iOS:
        return dotenv.env['IOS_GOOGLE_CLIENT_ID'];
      case TargetPlatform.macOS:
        return dotenv.env['MACOS_GOOGLE_CLIENT_ID'];
      case TargetPlatform.windows:
        return dotenv.env['WINDOWS_GOOGLE_CLIENT_ID'];
      default:
        return null;
    }
  }

  // Oturum Açma Durumunu Dinle
  void _authSubscription() {
    _service.authStateChanges.listen((User? user) {
      _user = user;
      _isAuthenticated = user != null;
      _isLoading = false;
      notifyListeners();
    });
  }

  // E-posta ve Şifre ile Giriş Yap
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _service.signInWithEmailAndPassword(email, password);
    } catch (e) {
      throw e;
    }
  }

  // E-posta ve Şifre ile Kaydol
  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _service.createUserWithEmailAndPassword(email, password);
    } catch (e) {
      throw e;
    }
  }

  // Google ile Giriş Yap
  Future<void> signInWithGoogle() async {
    try {
      await _service.signInWithGoogle();
    } catch (e) {
      throw e;
    }
  }

  // Çıkış Yap
  Future<void> signOut() async {
    await _service.signOut();
  }

  // Şifre Sıfırlama
  Future<void> sendPasswordResetEmail(String email) async {
    await _service.sendPasswordResetEmail(email);
  }
}
