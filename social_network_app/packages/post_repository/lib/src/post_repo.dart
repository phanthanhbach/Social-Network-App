import 'models/models.dart';

abstract class PostRepository {
  Future<Post> createPost(Post post, String? imagePath);

  Future<List<Post>> getPost();
}
