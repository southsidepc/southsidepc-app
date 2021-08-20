import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'constants.dart';
import 'helper.dart';
import 'authScreen.dart';
import 'user_base.dart';

void returnLoginSuccess(BuildContext context, dynamic result) {
  Navigator.popUntil(context, ModalRoute.withName(AuthScreen.routeName));
  Navigator.pop(context, result!); // returning non-null signals login success
}

class FireStoreUtils {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static Reference storage = FirebaseStorage.instance.ref();

  static Future<UserBase?> getCurrentUser(
      String uid, UserBase workspace) async {
    DocumentSnapshot<Map<String, dynamic>> userDocument =
        await firestore.collection(USERS).doc(uid).get();
    if (userDocument.data() != null && userDocument.exists) {
      print("getCurrentUser() : user found.");
      print("${userDocument.data()}");
      print("${userDocument.exists}");
      workspace.updateFromJson(userDocument.data()!);
      return workspace;
    } else {
      print("getCurrentUser() : user not found.");
      print("${userDocument.data()}");
      print("${userDocument.exists}");
      return null;
    }
  }

  static Future<UserBase> updateCurrentUser(UserBase user) async {
    return await firestore
        .collection(USERS)
        .doc(user.userID)
        .set(user.toJson())
        .then((document) {
      return user;
    });
  }

  static Future<String> uploadUserImageToFireStorage(
      File image, String userID) async {
    Reference upload = storage.child("images/$userID.png");
    UploadTask uploadTask = upload.putFile(image);
    var downloadUrl =
        await (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
    return downloadUrl.toString();
  }

  /// login with email and password with firebase
  /// @param email user email
  /// @param password user password
  static Future<dynamic> loginWithEmailAndPassword(
      String email, String password, UserBase output) async {
    try {
      auth.UserCredential result = await auth.FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      print("loginWithEmailAndPassword() : FirebaseAuth result = $result");
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await firestore.collection(USERS).doc(result.user?.uid ?? '').get();
      print("loginWithEmailAndPassword() : Snapshot = $documentSnapshot");
      if (documentSnapshot.exists) {
        output.updateFromJson(documentSnapshot.data() ?? {});
        print("loginWithEmailAndPassword() : output = $output");
        return output;
      }
      return null;
    } on auth.FirebaseAuthException catch (exception, s) {
      print(exception.toString() + '$s');
      switch ((exception).code) {
        case 'invalid-email':
          return 'Email address is malformed.';
        case 'wrong-password':
          return 'Wrong password.';
        case 'user-not-found':
          return 'No user corresponding to the given email address.';
        case 'user-disabled':
          return 'This user has been disabled.';
        case 'too-many-requests':
          return 'Too many attempts to sign in as this user.';
      }
      return 'Unexpected firebase error, Please try again.';
    } catch (e, s) {
      print('Login service exception: ' + e.toString() + '$s');
      return 'Login failed, Please try again.';
    }
  }

  static loginWithFacebook(UserBase defaultUser) async {
    FacebookAuth facebookAuth = FacebookAuth.instance;
    bool isLogged = await facebookAuth.accessToken != null;
    if (!isLogged) {
      LoginResult result = await facebookAuth
          .login(); // by default we request the email and the public profile
      if (result.status == LoginStatus.success) {
        // you are logged
        AccessToken? token = await facebookAuth.accessToken;
        return await handleFacebookLogin(
            await facebookAuth.getUserData(), token!, defaultUser);
      }
    } else {
      AccessToken? token = await facebookAuth.accessToken;
      return await handleFacebookLogin(
          await facebookAuth.getUserData(), token!, defaultUser);
    }
  }

  static handleFacebookLogin(Map<String, dynamic> userData, AccessToken token,
      UserBase defaultUser) async {
    auth.UserCredential authResult = await auth.FirebaseAuth.instance
        .signInWithCredential(
            auth.FacebookAuthProvider.credential(token.token));
    var user = await getCurrentUser(authResult.user?.uid ?? '', defaultUser);
    if (user != null) {
      user.email = userData['email'];
      user.name = userData['name'];
      user.profilePictureURL = userData['picture']['data']['url'];
      return await updateCurrentUser(user);
    } else {
      defaultUser.email = userData['email'] ?? '';
      defaultUser.name = userData['name'] ?? '';
      defaultUser.profilePictureURL = userData['picture']['data']['url'] ?? '';
      defaultUser.userID = authResult.user?.uid ?? '';
      String? errorMessage = await firebaseCreateNewUser(defaultUser);
      if (errorMessage == null) {
        return user;
      } else {
        return errorMessage;
      }
    }
  }

  /// save a new user document in the USERS table in firebase firestore
  /// returns an error message on failure or null on success
  static Future<String?> firebaseCreateNewUser(UserBase user) async =>
      await firestore
          .collection(USERS)
          .doc(user.userID)
          .set(user.toJson())
          .then((value) => null, onError: (e) => e);

  static firebaseSignUpWithEmailAndPassword(String emailAddress,
      String password, File? image, String name, UserBase defaultUser) async {
    try {
      auth.UserCredential result = await auth.FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailAddress, password: password);
      print(
          "firebaseSignUpWithEmailAndPassword() : FirebaseAuth result = $result");
      String profilePicUrl = '';
      if (image != null) {
        await updateProgress('Uploading image, Please wait...');
        profilePicUrl =
            await uploadUserImageToFireStorage(image, result.user?.uid ?? '');
      }
      defaultUser.email = emailAddress;
      defaultUser.name = name;
      defaultUser.profilePictureURL = profilePicUrl;
      defaultUser.userID = result.user?.uid ?? '';
      String? errorMessage = await firebaseCreateNewUser(defaultUser);
      if (errorMessage == null) {
        print("firebaseSignUpWithEmailAndPassword() : success");
        print("firebaseSignUpWithEmailAndPassword() : $defaultUser");
        return defaultUser;
      } else {
        return 'Couldn\'t sign up for firebase, Please try again.';
      }
    } on auth.FirebaseAuthException catch (error) {
      print(error.toString() + '${error.stackTrace}');
      String message = 'Couldn\'t sign up';
      switch (error.code) {
        case 'email-already-in-use':
          message = 'Email already in use, Please pick another email!';
          break;
        case 'invalid-email':
          message = 'Enter valid e-mail';
          break;
        case 'operation-not-allowed':
          message = 'Email/password accounts are not enabled';
          break;
        case 'weak-password':
          message = 'Password must be more than 5 characters';
          break;
        case 'too-many-requests':
          message = 'Too many requests, Please try again later.';
          break;
      }
      return message;
    } catch (e) {
      return 'Couldn\'t sign up';
    }
  }
}
