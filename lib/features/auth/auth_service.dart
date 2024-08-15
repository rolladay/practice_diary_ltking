import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model/user_model.dart';


part 'auth_service.g.dart';

@riverpod
class AuthService extends _$AuthService {
  // 인스턴스 생성
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //프로바이더 초기 state정의
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

        // 사용자 문서가 없다면, 즉 처음 로그인한 사용자라면
        if (!userDoc.exists) {
          final newUser = UserModel(
            uid: firebaseUser.uid,
            displayName: firebaseUser.displayName ?? '',
            email: firebaseUser.email ?? '',
            photoUrl: firebaseUser.photoURL ?? '',
            createdTime: DateTime.now(),
            lastSignedIn: DateTime.now(),
            totalSpend: 0,
            totalPrize: 0,
            userGames: [],
          );

          // newUser 객체를 json형태로 저장하는 부분
          await _firestore.collection('users').doc(firebaseUser.uid).set(newUser.toJson());
        } else {
          // 첫 로그인 사용자가 아니라면 lastSignedIn만 업데이트
          await _firestore.collection('users').doc(firebaseUser.uid).update({
            'lastSignedIn': DateTime.now(),
          });

        }
        //초기에 _auth.currentUser가 null이었을 것이기 떄문에 사인인 후 아래 user로 업데이트 하는 부분
        state = firebaseUser;
        print('Google User: $googleUser'); // 있음
        print('Firebase User: $firebaseUser'); // 있음
      }
    } catch (e) {
      print('Google 로그인 실패: $e');
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    state = null;
  }
}