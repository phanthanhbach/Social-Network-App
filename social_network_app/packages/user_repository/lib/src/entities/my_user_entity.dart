import 'package:equatable/equatable.dart';

class MyUserEntity extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? profilePicture;

  const MyUserEntity({
    required this.id,
    required this.email,
    required this.name,
    this.profilePicture,
  });

  Map<String, Object?> toDocument() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'profilePicture': profilePicture,
    };
  }

  static MyUserEntity fromDocument(Map<String, Object?> doc) {
    return MyUserEntity(
      id: doc['id'] as String,
      email: doc['email'] as String,
      name: doc['name'] as String,
      profilePicture: doc['profilePicture'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, email, name, profilePicture];

  @override
  String toString() {
    return '''MyUserEntity { 
      id: $id, 
      email: $email, 
      name: $name, 
      profilePicture: $profilePicture 
    }''';
  }
}
