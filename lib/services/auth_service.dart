
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  signInWithGoogle() async {
    // final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    // final GoogleSignInAuthentication gAuth = await gUser!.authentication;
    // final credential = GoogleAuthProvider.credential(
    //   accessToken: gAuth.accessToken,
    //   idToken: gAuth.idToken
    // );
    // return await FirebaseAuth.instance.signInWithCredential(credential);
    // return gAuth.idToken;

    final GoogleSignInAccount? googleSignInAccount =
    await GoogleSignIn().signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication
      googleSignInAuthentication =
      await googleSignInAccount.authentication;
      final AuthCredential credential =
      GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final UserCredential userCredential = await FirebaseAuth
          .instance
          .signInWithCredential(credential);

      final User user = userCredential.user!;
      final String? idToken = await user.getIdToken();
      return idToken;
    }
  }
}