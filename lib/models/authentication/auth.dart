import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService with ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = "";
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  final firebaseAuth = FirebaseAuth.instance;

  Future signInWithGoogle() async {
    setLoading(true);
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) return Future.value(false);

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await firebaseAuth.signInWithCredential(credential);
      setLoading(false);
      return userCredential.user;
    } on SocketException {
      setLoading(false);
      setMessage("No internet, please connect to internet!");
    } catch (e) {
      setLoading(false);
      setMessage(e.toString());
    }
  }

  Future createUserWithEmailAndPassword(
      String email, String password, String name) async {
    setLoading(true);
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user!.updateDisplayName(name);
      setLoading(false);
      return userCredential.user;
    } on SocketException {
      setLoading(false);
      setMessage("No internet, please connect to internet!");
    } catch (e) {
      setLoading(false);
      setMessage(e.toString());
    }
    notifyListeners();
  }

  Future loginUserWithEmailAndPassword(String email, String password) async {
    setLoading(true);
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      setLoading(false);
      return userCredential.user;
    } on SocketException {
      setLoading(false);
      setMessage("No internet, please connect to internet!");
    } catch (e) {
      setLoading(false);
      setMessage(e.toString());
    }
    notifyListeners();
  }

  Future signOut() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      print(e);
    }
  }

  void setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  void setMessage(String val) {
    _errorMessage = val;
    notifyListeners();
  }

  Stream<User> get user =>
      FirebaseAuth.instance.userChanges().map((event) => event!);
}
