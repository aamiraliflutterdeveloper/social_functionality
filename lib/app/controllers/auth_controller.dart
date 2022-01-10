import 'package:social_media_application/app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_media_application/app/routes/app_pages.dart';

class AuthController extends GetxController {
  var isSkipIntro = false.obs;
  var isAuth = false.obs;

  GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _currentUser;
  UserCredential? userCredential;
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  var user = UserModel().obs;

  Future<void> firstInitialized() async {
     await autoLogin().then((value) {
       if(value) {
         isAuth.value = true;
       }
     });

     await skipIntro().then((value) {
       if(value) {
         isSkipIntro.value = true;
       }
     });

  }

  Future<bool> skipIntro() async{
    final box = GetStorage();
    if(box.read('skipIntro') !=null || box.read('skipIntro') == true) {
      return true;
    } return false;
  }

  Future<bool> autoLogin() async{
    try{
      final isSignIn = await _googleSignIn.isSignedIn();
      if(isSignIn) {
        await _googleSignIn
            .signInSilently()
            .then((value) => _currentUser = value);
        final googleAuth = await _currentUser!.authentication;

        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );

        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) => userCredential = value);

        print("USER CREDENTIAL");
        print(userCredential);

        // masukan data ke firebase...
        CollectionReference users = _firebaseFirestore.collection('users');

        await users.doc(_currentUser!.email).update({
          "lastSignInTime":
          userCredential!.user!.metadata.lastSignInTime!.toIso8601String(),
        });

        final currUser = await users.doc(_currentUser!.email).get();
        final currUserData = currUser.data() as Map<String, dynamic>;

        user(UserModel.fromJson(currUserData));
        return true;
      }
      return false;
    } catch (err){
      print(err);
      return false;
    }
  }

 Future<void> login() async{
    try{
        await _googleSignIn.signIn().then((value) {
          _currentUser = value;
        });
        final isSignIn = await _googleSignIn.isSignedIn();
        if(isSignIn) {
          final googleAuth = await _currentUser!.authentication;
          final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
          );
          await FirebaseAuth.instance.signInWithCredential(credential).then((value) {
            userCredential = value;
          });
          print("user credentails are: $userCredential");

          //local storage
          final box = GetStorage();
          if (box.read('skipIntro') != null) {
            box.remove('skipIntro');
          }
          box.write('skipIntro', true);

         //users table.
          CollectionReference users = _firebaseFirestore.collection('users');
          final checkUser = await users.doc(_currentUser!.email).get();
          if(checkUser.data() == null) {
            users.doc(_currentUser!.email).set({
              "uid": userCredential!.user!.uid,
              "name": _currentUser!.displayName,
              "keyName": _currentUser!.displayName!.substring(0, 1).toUpperCase(),
              "email": _currentUser!.email,
              "photoUrl": _currentUser!.photoUrl ?? "noimage",
              "status": "",
              "creationTime":
              userCredential!.user!.metadata.creationTime!.toIso8601String(),
              "lastSignInTime": userCredential!.user!.metadata.lastSignInTime!
                  .toIso8601String(),
              "updatedTime": DateTime.now().toIso8601String(),
            });
          } else {
            users.doc(_currentUser!.email).update({
              "lastSignInTime": userCredential!.user!.metadata.lastSignInTime!
                  .toIso8601String(),
              "updatedTime": DateTime.now().toIso8601String(),
            });
          }

          final currUser = await users.doc(_currentUser!.email).get();
          final currentUserData = currUser.data() as Map<String, dynamic>;
          user(UserModel.fromJson(currentUserData));
          print(_currentUser);
          isAuth.value = true;
          Get.offAllNamed(Routes.HOME);
        } else {
            print("user is not signed in: please sign in");
          }
    } catch(error){
      print(error);
    }
  }

  Future<void> logout() async{
   await _googleSignIn.signOut();
   await _googleSignIn.disconnect();
   Get.offAllNamed(Routes.LOGIN);
  }


}


