// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:user_repository/src/entities/entities.dart';

class MyUser extends Equatable {
  final String id;
  final String email;
  final String name;
  String? profilePicture;

  MyUser({
    required this.id,
    required this.email,
    required this.name,
    this.profilePicture,
  });

  // Empty user which represents an unauthenticated user
  static final empty = MyUser(id: '', email: '', name: '', profilePicture: '');

  // CopyWith method to update the user object
  MyUser copyWith({
    String? id,
    String? email,
    String? name,
    String? profilePicture,
  }) {
    return MyUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }

  // Equatable props
  bool get isEmpty => this == MyUser.empty;

  bool get isNotEmpty => this != MyUser.empty;

  MyUserEntity toEntity() {
    return MyUserEntity(id: id, email: email, name: name, profilePicture: profilePicture);
  }

  static MyUser fromEntity(MyUserEntity entity) {
    return MyUser(id: entity.id, email: entity.email, name: entity.name, profilePicture: entity.profilePicture);
  }

  @override
  List<Object?> get props => [id, email, name, profilePicture];
}
