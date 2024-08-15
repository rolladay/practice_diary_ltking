import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model/user_model.dart';

part 'user_provider.g.dart';


// user 객체를 업데이트 할 때 사용하는데, auth랑 구분해서 사용하면 될듯

@riverpod
class UserModelNotifier extends _$UserModelNotifier {
  @override
  UserModel? build() => null;

  // 주어진 user 객체를 가지고 firebase에 update 및 상태관리
  Future<void> updateUser(UserModel updatedUser) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(updatedUser.uid)
        .update(updatedUser.toJson());
    state = updatedUser;
  }

  // user Collection에서 데이터를 가져와 User 객체 생성 및 상태 업데이트
  Future<void> fetchUser(String uid) async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (doc.exists) {
      final user = UserModel.fromJson(doc.data()!);
      print('Fetched User: ${user.toString()}');
      state = user; // 상태 업데이트
    }
  }
}
