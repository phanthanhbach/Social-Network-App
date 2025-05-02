import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_repository/user_repository.dart';

class ServicesUserRepository implements UserRepository {
  final FirebaseAuth _firebaseAuth;
  final usersCollection = FirebaseFirestore.instance.collection('users');

  final CloudinaryPublic cloudinary = CloudinaryPublic('dqhyfwygx', 'image-upload', cache: false);

  ServicesUserRepository({FirebaseAuth? firebaseAuth}) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Stream<User?> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser;
      return user;
    });
  }

  @override
  Stream<List<MyUser>> getUsersStream() {
    return usersCollection.snapshots().map(
        (snapshot) => snapshot.docs.map((doc) => MyUser.fromEntity(MyUserEntity.fromDocument(doc.data()))).toList());
  }

  Future<List<MyUser>> getUsersByIds(List<String> userIds) async {
    final usersSnapshot = await usersCollection.where(FieldPath.documentId, whereIn: userIds).get();

    return usersSnapshot.docs.map((doc) => MyUser.fromEntity(MyUserEntity.fromDocument(doc.data()))).toList();
  }

  @override
  Future<MyUser> signUp(MyUser myUser, String password) async {
    try {
      UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: myUser.email,
        password: password,
      );

      myUser = myUser.copyWith(id: user.user!.uid);

      return myUser;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<MyUser> getMyUser(String myUserId) {
    try {
      return usersCollection
          .doc(myUserId)
          .get()
          .then((value) => MyUser.fromEntity(MyUserEntity.fromDocument(value.data()!)));
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> setUserData(MyUser user) async {
    try {
      await usersCollection.doc(user.id).set(user.toEntity().toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<String> uploadPicture(String filePath, String userId) async {
    try {
      File imageFile = File(filePath);
      final response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          imageFile.path,
          folder: 'users/$userId/PP',
          publicId: '${userId}_lead',
        ),
      );

      final imageURL = response.secureUrl;

      await usersCollection.doc(userId).update({'profilePicture': imageURL});

      return imageURL;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<String> updateUserName(String userId, String name) async {
    try {
      await usersCollection.doc(userId).update({'name': name});
      return name;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
