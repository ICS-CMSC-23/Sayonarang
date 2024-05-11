import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAuthAPI {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<User?> getUser() {
    return auth.authStateChanges();
  }

  Future<void> signUp(
      String name,
      String username,
      String email,
      String password,
      String contactNum,
      // List<String> addresses,
      String addresses,
      String proof,
      String role) async {
    UserCredential credential;

    try {
      credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // print(credential);

      // save user's other details to Firestore
      final docRef = await db.collection("users").add({
        'userId': credential.user!.uid,
        'name': name,
        'username': username,
        'contactNum': contactNum,
        'addresses': addresses,
        'proof': proof,
        'role': role,
        'status': role == 'org' ? 'pending' : '',
      });

      print('New User added with ID: ${docRef.id}');
    } on FirebaseAuthException catch (e) {
      //possible to return something more useful
      //than just print an error message to improve UI/UX
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<String> signIn(String email, String password) async {
    UserCredential credential;
    try {
      final credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      // print(credential);
      return '';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        //possible to return something more useful
        //than just print an error message to improve UI/UX
        print('No user found for that email.');
        return 'User not found';
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        return 'Wrong password';
      }
    } catch (e) {
      // print(e);
      return e.toString();
    }
    return 'Invalid credentials';
  }

  Future<void> signOut() async {
    await auth.signOut();
  }
}
