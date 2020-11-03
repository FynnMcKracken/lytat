import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

Future<String> signInWithGoogle() async {
  await Firebase.initializeApp();

  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final UserCredential authResult = await _auth.signInWithCredential(credential);
  final User user = authResult.user;

  if (user != null) {
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final User currentUser = _auth.currentUser;
    assert(user.uid == currentUser.uid);

    print('FIREBASE: sign in with Google succeeded: $user');

    final QuerySnapshot result = await FirebaseFirestore.instance.collection('users').where('id', isEqualTo: user.uid).get();
    final List <DocumentSnapshot> documents = result.docs;
    if (documents.length == 0) {
      FirebaseFirestore.instance.collection('users').doc(user.uid).set(
          { 'nickname': user.displayName, 'photoUrl': user.photoURL, 'id': user.uid });
      print('FIREBASE: New user $user added to Firestore');
    }

    return '$user';
  }

  return null;
}

Future<void> signOutGoogle() async {
  await googleSignIn.signOut();

  print("FIREBASE: User signed out");
}