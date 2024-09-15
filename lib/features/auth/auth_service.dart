import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model/user_model.dart';

part 'auth_service.g.dart';

// auth서비스는 상태값은 firebaseAuth(User?), notifier로는 구글사인인(최초UserModel파베업로드,이후 lastSignedIn),
// 사인아웃 2개의 메소드만 있다.
@riverpod
class AuthService extends _$AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  User? build() => _auth.currentUser;

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? firebaseUser = userCredential.user;


      if (firebaseUser != null) {
        final userDoc = await _firestore.collection('users').doc(firebaseUser.uid).get();
        // 이게 UserModel 생성 시 파이어베이스에 동일한 데이터 구조 만드는 부분임
        if (!userDoc.exists) {
          final newUser = UserModel(
            uid: firebaseUser.uid,
            displayName: firebaseUser.displayName ?? '',
            email: firebaseUser.email ?? '',
            photoUrl: firebaseUser.photoURL ?? '',
            createdTime: DateTime.now(),
            lastSignedIn: DateTime.now(),
            // 나중에 기존 total spend, prize, userGame, winningRate 등등 있으면 기존꺼 쓰고 없으면 업데이트
            totalSpend: 0,
            totalPrize: 0,
            exp: 0,
            maxGames: 5,
            userComment: 'user comment here',
            coreNos: [],
          );

          // newUser 객체를 json형태로 저장하는 부분
          await _firestore.collection('users').doc(firebaseUser.uid).set(newUser.toJson());
        } else {
          await _firestore.collection('users').doc(firebaseUser.uid).update({
            'lastSignedIn': DateTime.now(),
          });

        }
        //초기에 _auth.currentUser가 null이었을 것이기 떄문에 사인인 후 아래 user로 업데이트 하는 부분
        state = firebaseUser;
      }
    } catch (e) {
      print('Google SignIn Failed : $e');
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    state = null;
  }
}