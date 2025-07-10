import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign in with Email & Password
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  // Register with Email & Password
  Future<User?> registerWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  // Google Sign-In
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignIn signIn = GoogleSignIn.instance;

      await signIn.initialize(); // optional with clientId/serverClientId

      await signIn.authenticate();

      // Receive the sign-in event
      GoogleSignInAccount? signedUser;
      await signIn.authenticationEvents
          .firstWhere(
        (event) => event is GoogleSignInAuthenticationEventSignIn,
      )
          .then((event) {
        signedUser = (event as GoogleSignInAuthenticationEventSignIn).user;
      });

      if (signedUser == null) return null;

      final googleAuth = await signedUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth?.idToken,
      );

      final userCred =
          await FirebaseAuth.instance.signInWithCredential(credential);
      return userCred.user;
    } catch (e) {
      print("Google Sign-In failed: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await GoogleSignIn.instance.disconnect();
    await _auth.signOut();
  }
}
