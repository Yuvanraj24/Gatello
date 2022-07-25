import 'dart:developer' as dev;
import 'dart:math';


import '';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:overlay_support/overlay_support.dart';

import '../main.dart';

String? codeVerificationId;
int? forceResendToken;

getUID() {
  try {
    return FirebaseAuth.instance.currentUser!.uid;
  } catch (e) {
    toast(e.toString());
  }
}

Future getFCMToken() async {
  try {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    return await messaging.getToken();
  } catch (e) {
    toast(e.toString());
  }
}

Future<UserCredential> signUpAnonymous() async {
  return await FirebaseAuth.instance.signInAnonymously();
}

Future<UserCredential> signUpWithEmail({required String email, required String password, required BuildContext context}) async {
  return await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
}

Future<UserCredential> signInWithEmail({required String email, required String password}) async {
  final AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);
  return await signIn(credential);
}

// Future<UserCredential> signInWithGoogle() async {
//   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//   final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
//   final OAuthCredential credential = GoogleAuthProvider.credential(
//     accessToken: googleAuth?.accessToken,
//     idToken: googleAuth?.idToken,
//   );
//   return await signIn(credential);
// }

// Future<UserCredential> signInWithFacebook() async {
//   final LoginResult loginResult = await FacebookAuth.instance.login();
//   final OAuthCredential credential = FacebookAuthProvider.credential(loginResult.accessToken!.token);
//   return await signIn(credential);
// }

Future<UserCredential> signIn(AuthCredential credential) async {
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

Future updatePassword(String password) async {
  User? user = FirebaseAuth.instance.currentUser;
  return await user!.updatePassword(password);
}

//there wont be reauth for now
Future reAuth(AuthCredential credential) async {
  try {
    return await FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(credential);
  } on FirebaseAuthException catch (e) {
    toast(e.toString());
    // return await firebaseExceptionHandler(e);
  } catch (e) {
    toast(e.toString());
  }
}

Future signOut() async {
  try {
    return await FirebaseAuth.instance.signOut();
  } catch (e) {
    toast(e.toString());
  }
}

Future<UserCredential> linkCredential(AuthCredential credential) async {
  User? currentUser = FirebaseAuth.instance.currentUser;
  return await currentUser!.linkWithCredential(credential);
}

Future<User> unlinkCredential(String providerId) async {
  User? currentUser = FirebaseAuth.instance.currentUser;
  return await currentUser!.unlink(providerId);
}

// Future linkPhone(String phoneNumber) async {
//   try {
//     User? currentUser = FirebaseAuth.instance.currentUser;
//     if (currentUser != null) {
//       return await currentUser.linkWithPhoneNumber(phoneNumber);
//     }
//   } on FirebaseAuthException catch (e) {
//     toast(e.toString());
//     // return await firebaseExceptionHandler(e);
//   } catch (e) {
//     toast(e.toString());
//   }
// }

// Future phoneCredential(String smsCode) async {
//   try {
//     PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: codeVerificationId!, smsCode: smsCode);
//     // return await signIn(credential);
//     return credential;
//   } on FirebaseAuthException catch (e) {
//     toast(e.toString());
//     // return await firebaseExceptionHandler(e);
//   } catch (e) {
//     toast(e.toString());
//   }
// }

// Future verifyPhone({required String phoneNumber}) async {
//   final PhoneVerificationCompleted phoneVerificationCompleted = (PhoneAuthCredential credential) async {
//     // return await signIn(credential);
//   };

//   final PhoneVerificationFailed phoneVerificationFailed = (FirebaseAuthException e) {
//     toast(e.toString());
//   };

//   final PhoneCodeSent phoneCodeSent = (String verificationId, int? resendToken) async {
//     codeVerificationId = verificationId;
//     if (resendToken == null) return;
//     forceResendToken = resendToken;
//   };
//   final PhoneCodeAutoRetrievalTimeout phoneCodeAutoRetrievalTimeout = (String verificationId) {
//     codeVerificationId = verificationId;
//   };
//   try {
//     return await FirebaseAuth.instance.verifyPhoneNumber(
//         phoneNumber: phoneNumber,
//         verificationCompleted: phoneVerificationCompleted,
//         verificationFailed: phoneVerificationFailed,
//         codeSent: phoneCodeSent,
//         codeAutoRetrievalTimeout: phoneCodeAutoRetrievalTimeout,
//         forceResendingToken: forceResendToken ?? null);
//   } on FirebaseAuthException catch (e) {
//     toast(e.toString());
//     // return await firebaseExceptionHandler(e);
//   } catch (e) {
//     toast(e.toString());
//   }
// }

Future firebaseExceptionHandler(FirebaseAuthException e, {required BuildContext context}) async {
  if (e.code == 'account-exists-with-different-credential') {
    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      return await linkCredential(e.credential!);
    } else {
      return Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyApp(
              )));
    }
  } else {
    toast(e.toString());
  }
}

//web
// class PhoneAuthWeb {
//   late ConfirmationResult confirmationResult;

//   Future verifyPhoneWeb({required String phoneNumber}) async {
//     FirebaseAuth auth = FirebaseAuth.instance;
//     confirmationResult = await auth.signInWithPhoneNumber(
//       phoneNumber,
//       // RecaptchaVerifier(
//       //   container: 'recaptcha',
//       //   size: RecaptchaVerifierSize.compact,
//       //   theme: RecaptchaVerifierTheme.dark,
//       //   onSuccess: () {
//       //     toast("reCAPTCHA Completed!");
//       //   },
//       //   onError: (FirebaseAuthException error) {
//       //     toast(error.toString());
//       //   },
//       //   onExpired: () {
//       //     toast('reCAPTCHA Expired!');
//       //   },
//       // ),
//     );
//     codeVerificationId = confirmationResult.verificationId;
//     return confirmationResult;
//   }

//   Future<UserCredential> signInWithPhoneWeb({required String otp}) async {
//     return await confirmationResult.confirm(otp);
//   }
// }
