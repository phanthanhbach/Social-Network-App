import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_repository/user_repository.dart';

abstract class UserRepository {
  Stream<User?> get user;

  Stream<List<MyUser>> getUsersStream();

  Future<List<MyUser>> getUsersByIds(List<String> userIds);

  Future<void> signIn(String email, String password);

  Future<MyUser> signUp(MyUser myUser, String password);

  Future<void> signOut();

  Future<void> resetPassword(String email);

  Future<void> setUserData(MyUser user);

  Future<MyUser> getMyUser(String myUserId);

  Future<String> uploadPicture(String filePath, String userId);

  Future<String> updateUserName(String userId, String name);
}
