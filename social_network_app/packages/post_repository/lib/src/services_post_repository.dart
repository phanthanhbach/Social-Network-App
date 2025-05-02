import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:post_repository/src/models/post.dart';
import 'package:uuid/uuid.dart';
import 'entities/entities.dart';
import 'post_repo.dart';

class ServicesPostRepository implements PostRepository {
  final postsCollection = FirebaseFirestore.instance.collection('posts');
  final CloudinaryPublic cloudinary = CloudinaryPublic('dqhyfwygx', 'image-upload', cache: false);

  @override
  Future<Post> createPost(Post post, String? imagePath) async {
    try {
      post.postId = const Uuid().v1();
      post.createdAt = DateTime.now();

      if (imagePath != '') {
        post.imageUrl = await uploadPicture(imagePath!, post.userId, post.postId, post.createdAt.toString());
      }

      await postsCollection.doc(post.postId).set(post.toEntity().toDocument());

      return post;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<String> uploadPicture(String filePath, String userId, String postId, String createdAt) async {
    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          filePath,
          folder: 'users/$userId/posts',
          publicId: '${postId}_$createdAt',
        ),
      );

      final imageURL = response.secureUrl;

      return imageURL;
    } on CloudinaryException catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<Post>> getPost() {
    try {
      return postsCollection
          .get()
          .then((value) => value.docs.map((e) => Post.fromEntity(PostEntity.fromDocument(e.data()))).toList());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<Post> editPost(Post post, String imageUrl) async {
    try {
      await postsCollection.doc(post.postId).update({'content': post.content, 'imageUrl': imageUrl});
      return post;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
