import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

  @override
  Future<void> deletePost(Post post) async {
    try {
      if (post.imageUrl != null && post.imageUrl != '') {
        await deletePostImage(post.imageUrl!);
      }
      await postsCollection.doc(post.postId).delete();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> deletePostImage(String imageUrl) async {
    try {
      final uri = Uri.parse(imageUrl);
      final segments = uri.pathSegments;
      final uploadIndex = segments.indexOf('upload');

      if (uploadIndex == -1 || uploadIndex + 1 >= segments.length) {
        log('Invalid image URL: $imageUrl');
        return;
      }

      // Lấy public_id bỏ qua phần 'upload' và 'v...'
      final publicIdWithExtension = segments.sublist(uploadIndex + 2).join('/');

      final publicIdWithoutExt = publicIdWithExtension.lastIndexOf('.');

      final publicId = Uri.decodeComponent(publicIdWithExtension.substring(0, publicIdWithoutExt));

      log('Public ID: $publicId');

      final apiKey = dotenv.env['CLOUDINARY_API_KEY'];
      final apiSecret = dotenv.env['CLOUDINARY_API_SECRET'];
      final cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'];

      final basicAuth = 'Basic ' + base64Encode(utf8.encode('$apiKey:$apiSecret'));
      final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/$cloudName/image/destroy',
      );

      final response = await http.post(
        url,
        headers: {
          'Authorization': basicAuth,
        },
        body: {
          'public_id': publicId,
        },
      );

      if (response.statusCode == 200) {
        log('Deleted image $publicId from Cloudinary');
      } else {
        log('Failed to delete image: ${response.body}');
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
