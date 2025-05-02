import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_repository/user_repository.dart';

class PostEntity {
  String postId;
  String userId;
  String content;
  String? imageUrl;
  DateTime createdAt;

  PostEntity({
    required this.postId,
    required this.userId,
    required this.content,
    this.imageUrl,
    required this.createdAt,
  });

  Map<String, Object?> toDocument() {
    return {
      'postId': postId,
      'userId': userId,
      'content': content,
      'imageUrl': imageUrl,
      'createdAt': createdAt,
    };
  }

  static PostEntity fromDocument(Map<String, dynamic> doc) {
    return PostEntity(
      postId: doc['postId'] as String,
      userId: doc['userId'] as String,
      content: doc['content'] as String,
      imageUrl: doc['imageUrl'] as String?,
      createdAt: (doc['createdAt'] as Timestamp).toDate(),
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
