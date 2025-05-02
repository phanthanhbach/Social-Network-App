import 'package:user_repository/user_repository.dart';

import '../entities/entities.dart';

class Post {
  String postId;
  String userId;
  String content;
  String? imageUrl;
  DateTime createdAt;

  Post({
    required this.postId,
    required this.userId,
    required this.content,
    this.imageUrl,
    required this.createdAt,
  });

  // Empty user which represents an unauthenticated user
  static final empty = Post(postId: '', userId: '', content: '', imageUrl: '', createdAt: DateTime.now());

  // CopyWith method to update the user object
  Post copyWith({
    String? postId,
    String? userId,
    String? content,
    String? imageUrl,
    DateTime? createdAt,
  }) {
    return Post(
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Equatable props
  bool get isEmpty => this == Post.empty;

  bool get isNotEmpty => this != Post.empty;

  PostEntity toEntity() {
    return PostEntity(
      postId: postId,
      userId: userId,
      content: content,
      imageUrl: imageUrl,
      createdAt: createdAt,
    );
  }

  static Post fromEntity(PostEntity entity) {
    return Post(
      postId: entity.postId,
      userId: entity.userId,
      content: entity.content,
      imageUrl: entity.imageUrl,
      createdAt: entity.createdAt,
    );
  }

  @override
  List<Object?> get props => [postId, userId, content, imageUrl, createdAt];

  @override
  String toString() {
    return '''PostEntity { 
      postId: $postId, 
      userId: $userId,
      content: $content,
      imageUrl: $imageUrl,
      createdAt: $createdAt, 
    }''';
  }
}
