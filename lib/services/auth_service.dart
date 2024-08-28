import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/photoslibrary'
    ]
  );

  Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      final account = await _googleSignIn.signIn();
      return account;
    } catch (e) {
      print("Error signing in with Google: $e");
      return null;
    }
  }

  Future<void> signOutGoogle() async {
    try {
      await _googleSignIn.signOut();  // Signs out from the app
      await _googleSignIn.disconnect(); // Disconnects the account
      print("User signed out and disconnected from Google");
    } catch (e) {
      print("Error signing out from Google: $e");
    }
  }

  GoogleSignInAccount? get currentUser => _googleSignIn.currentUser;
}