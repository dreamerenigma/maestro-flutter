import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:maestro/features/authentication/models/create_user_req.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../../features/authentication/models/signin_user_req.dart';

abstract class AuthFirebaseService {

  Future<Either> signUp(CreateUserReq createUserReq);
  Future<Either> signIn(SignInUserReq signInUserReq);
  Future<Either> googleSignIn();
  Future<Either> googleSignUp();
  Future<Either> appleSignIn();
  Future<Either> appleSignUp();
}

class AuthFirebaseServiceImpl extends AuthFirebaseService {

  @override
  Future<Either> signUp(CreateUserReq createUserReq) async {
    try {
      var data = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: createUserReq.email,
        password: createUserReq.password,
      );

      FirebaseFirestore.instance.collection('Users').doc(data.user?.uid).set({
        'id': createUserReq.id,
        'createdAt': createUserReq.createdAt,
        'name': createUserReq.name,
        'email': data.user?.email,
        'gender': createUserReq.gender,
        'age': createUserReq.age,
        'image': createUserReq.image,
      });

      return const Right('Signup was Successful');
    } on FirebaseAuthException catch (e) {
      String message = '';

      if (e.code == 'week-password') {
        message = 'The password provided is too week';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists with that email.';
      }

      return Left(message);
    }
  }

  @override
  Future<Either> signIn(SignInUserReq signInUserReq) async {
    try {

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: signInUserReq.email,
        password: signInUserReq.password,
      );

      return const Right('Signin was Successful');

    } on FirebaseAuthException catch(e) {
      String message = '';

      if (e.code == 'invalid-email') {
        message = 'Not user found for that email';
      } else if (e.code == 'invalid-credential') {
        message = 'Wrong password provided for that user';
      }

      return Left(message);
    }
  }

  @override
  Future<Either<String, String>> googleSignIn() async {
    try {
      log('Starting Google Sign-In process...');

      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      log('Successfully signed out previous session.');

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        log('Google Sign-In aborted by user');
        return const Left('Google sign-in aborted');
      }
      log('Google Sign-In successful: ${googleUser.email}');

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      log('Google authentication successful.');

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user == null) {
        log('Firebase Auth sign-in failed');
        return const Left('Google sign-in failed');
      }

      log('Successfully signed in with Firebase: ${user.email}');

      final userDoc = await FirebaseFirestore.instance.collection('Users').doc(user.uid).get();
      if (!userDoc.exists) {
        log('User does not exist in Firestore, creating new user...');
        await FirebaseFirestore.instance.collection('Users').doc(user.uid).set({
          'id': user.uid,
          'name': user.displayName,
          'email': user.email,
          'image': user.photoURL,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      log('User created or found in Firestore.');

      return const Right('Google Sign-In was Successful');
    } on FirebaseAuthException catch (e) {
      log('Firebase Auth Exception: ${e.message}');
      return Left(e.message ?? 'An error occurred');
    } catch (e) {
      log('Unexpected error: $e');
      return const Left('An unexpected error occurred');
    }
  }

  @override
  Future<Either<String, String>> googleSignUp() async {
    try {
      log('Starting Google Sign-Up process...');

      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      log('Successfully signed out previous session.');

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        log('Google Sign-Up aborted by user');
        return const Left('Google sign-up aborted');
      }
      log('Google Sign-Up successful: ${googleUser.email}');

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      log('Google authentication successful.');

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user == null) {
        log('Firebase Auth sign-up failed');
        return const Left('Google sign-up failed');
      }

      log('Successfully signed in with Firebase: ${user.email}');

      final userDoc = await FirebaseFirestore.instance.collection('Users').doc(user.uid).get();
      if (!userDoc.exists) {
        log('Creating new user in Firestore...');
        await FirebaseFirestore.instance.collection('Users').doc(user.uid).set({
          'id': user.uid,
          'name': user.displayName,
          'email': user.email,
          'image': user.photoURL,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      log('User created or found in Firestore.');

      return const Right('Google Sign-Up was Successful');
    } on FirebaseAuthException catch (e) {
      log('Firebase Auth Exception: ${e.message}');
      return Left(e.message ?? 'An error occurred');
    } catch (e) {
      log('Unexpected error: $e');
      return const Left('An unexpected error occurred');
    }
  }

  @override
  Future<Either> appleSignIn() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: 'com.example.clientid',
          redirectUri: Uri.parse('https://example.com/callbacks/sign_in_with_apple'),
        ),
      );

      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      await FirebaseAuth.instance.signInWithCredential(oauthCredential);

      return const Right('Apple Sign-In was Successful');
    } on PlatformException catch (e) {
      return Left(e.message ?? 'An error occurred');
    } on FirebaseAuthException catch (e) {
      return Left(e.message ?? 'An error occurred');
    }
  }

  @override
  Future<Either> appleSignUp() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: 'com.example.clientid',
          redirectUri: Uri.parse('https://example.com/callbacks/sign_in_with_apple'),
        ),
      );

      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      await FirebaseAuth.instance.signInWithCredential(oauthCredential);

      return const Right('Apple Sign-In was Successful');
    } on PlatformException catch (e) {
      return Left(e.message ?? 'An error occurred');
    } on FirebaseAuthException catch (e) {
      return Left(e.message ?? 'An error occurred');
    }
  }
}
