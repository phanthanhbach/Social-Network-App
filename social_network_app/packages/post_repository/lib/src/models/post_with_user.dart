import 'package:post_repository/post_repository.dart';
import 'package:user_repository/user_repository.dart';

class PostWithUser {
  final Post post;
  final MyUser user;

  PostWithUser({required this.post, required this.user});
}
