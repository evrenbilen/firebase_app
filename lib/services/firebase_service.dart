import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_app/models/item.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  late final GoogleSignIn _googleSignIn;

  // Constructor to initialize GoogleSignIn with clientId
  FirebaseService({String? clientId}) {
    _googleSignIn = GoogleSignIn(
      clientId: clientId, // This will be used for web platform
      scopes: [
        'email',
        'profile',
      ],
    );
  }

  // Kimlik Doğrulama

  //✅authStateChanges getter'ını doğru tanımlayın:
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<UserCredential> createUserWithEmailAndPassword(
      String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    return await _auth.signOut();
  }

  // Google ile Giriş
  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser =
        await _googleSignIn.signIn().catchError((error) {
      print('Google Sign-In Error: $error');
      throw error;
    });

    if (googleUser == null) {
      throw Exception('Google Sign-In was canceled');
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  // Şifre Sıfırlama
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Kullanıcı Oturum Açmış mı Kontrol Et
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Firestore
  Future<void> addItem(Item item) async {
    await _firestore.collection('items').add(item.toFirestore());
  }

  Future<void> updateItem(Item item) async {
    await _firestore
        .collection('items')
        .doc(item.id)
        .update(item.toFirestore());
  }

  Future<void> deleteItem(String itemId) async {
    await _firestore.collection('items').doc(itemId).delete();
  }

  Stream<List<Item>> getItems() {
    return _firestore.collection('items').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Item.fromFirestore(doc.data(), doc.id))
          .toList();
    });
  }

// Depolama
// Gerekirse dosya yükleme/indirme işlemleri için işlevler ekleyin
}
