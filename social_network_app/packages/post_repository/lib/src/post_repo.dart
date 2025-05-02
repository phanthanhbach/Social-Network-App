import 'models/models.dart';

abstract class PostRepository {
  Future<Post> createPost(Post post, String? imagePath);

  Future<Post> editPost(Post post, String imageUrl);

  Future<List<Post>> getPost();
}
