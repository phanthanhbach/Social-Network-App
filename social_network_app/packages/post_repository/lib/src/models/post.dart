import 'package:user_repository/user_repository.dart';

import '../entities/entities.dart';

class Post {
  String postId;
  String post;
  String? imageUrl;
  DateTime createdAt;
  MyUser myUser;

  Post({
    required this.postId,
    required this.post,
    this.imageUrl,
    required this.createdAt,
    required this.myUser,
  });

  // Empty user which represents an unauthenticated user
  static final empty = Post(postId: '', post: '', imageUrl: '', createdAt: DateTime.now(), myUser: MyUser.empty);

  // CopyWith method to update the user object
  Post copyWith({
    String? postId,
    String? post,
    String? imageUrl,
    DateTime? createdAt,
    MyUser? myUser,
  }) {
    return Post(
      postId: postId ?? this.postId,
      post: post ?? this.post,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      myUser: myUser ?? this.myUser,
    );
  }

  // Equatable props
  bool get isEmpty => this == Post.empty;

  bool get isNotEmpty => this != Post.empty;

  PostEntity toEntity() {
    return PostEntity(postId: postId, post: post, imageUrl: imageUrl, createdAt: createdAt, myUser: myUser);
  }

  static Post fromEntity(PostEntity entity) {
    return Post(
        postId: entity.postId,
        post: entity.post,
        imageUrl: entity.imageUrl,
        createdAt: entity.createdAt,
        myUser: entity.myUser);
  }

  @override
  List<Object?> get props => [postId, post, imageUrl, createdAt, myUser];

  @override
  String toString() {
    return '''PostEntity { 
      postId: $postId, 
      post: $post,
      imageUrl: $imageUrl,
      createdAt: $createdAt, 
      myUser: $myUser 
    }''';
  }
}
