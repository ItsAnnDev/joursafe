import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService extends ChangeNotifier{
  // Instance of auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Instance of firestore
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  
  // EMAIL METHOD
  Future<UserCredential> signInWithEmailAndPassword(
    String email, String password) async {
    try {
      // sign in
      UserCredential userCredential = 
        await _firebaseAuth.signInWithEmailAndPassword(
          email: email, 
          password: password
        );

        // add a new document for the user in users collection if it doesn't already exists
         _fireStore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
      }, SetOptions(merge: true));

        return userCredential;
    } 
    // catch any errors
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // create a new user
  Future<UserCredential> signUpWithEmailandPassword(String email, password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, 
        password: password,
      );

      // after creating the user, create a new document for the user in the users collection
      _fireStore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
      });

      // redirect to the setup account page after succesful registration
      

      return  userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // sign user out
  Future<void> signOut()  async {
    return await FirebaseAuth.instance.signOut();
  }

    // Google Sign In
  signInWithGoogle() async {
    // begin interactive sign in process
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // obtain auth details from request
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

    // create a new credential for user
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // finally, lets sign in
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}