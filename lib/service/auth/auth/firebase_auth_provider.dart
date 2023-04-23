import 'package:firebase_auth/firebase_auth.dart';
import 'package:mynotes/service/auth/auth/auth_provider.dart';
import 'package:mynotes/service/auth/auth/auth_user.dart';

import 'auth_exceptions.dart';

class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<AuthUser?> createUser(
      {required String email, required String password}) async {
    // TODO: implement createUser
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      final user = currentUser;
      if (user != null){
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
          throw WeakPasswordAuthException();
      } else if (e.code == 'email-already-in-use') {
          throw EmailAlreadyInUseAuthException();
      } else if (e.code == 'invalid-email') {
          throw InvalidEmailAuthException();
      } else {
          throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if(user != null){
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser?> logIn({required String email, required String password}) async {
    // TODO: implement logIn
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      final user = currentUser;
      if (user != null){
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e){
      if (e.code == 'wrong-password') {
        throw UserNotFoundAuthException();
      } else if (e.code == 'wrong-password'){
        throw WrongPasswordAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (e) {
        throw GenericAuthException();
    }
  }

  @override
  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null){
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotFoundAuthException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null){
      await user.sendEmailVerification();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }
}


