import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  final FirebaseAuth _auth=FirebaseAuth.instance;

  Future signInWithEmailAndPassword(String email, String password)async{
    try{
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (_auth.currentUser != null) {
        print("login success");
        if (!_auth.currentUser!.emailVerified) {
          return 1;
        } else {
          return 2;
        }
      }
    }on FirebaseAuthException catch(e){
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> registerWithEmailAndPassword(String email, String password)async{
    try{
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e){
      if (e.code == 'email-already-in-use') {
        rethrow;
      } else {
        return false;
      }
    }
  }

  Future signOut() async{
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }

// void changePassword(String password) {
//   User user = _auth.currentUser;
//   //Pass in the password to updatePassword.
//   user.updatePassword(password).then((_) {
//     print("Successfully changed password");
//   }).catchError((error) {
//     print("Password can't be changed" + error.toString());
//     //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
//   });
// }
}