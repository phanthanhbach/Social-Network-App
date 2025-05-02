import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:post_repository/post_repository.dart';
import 'package:social_network_app/blocs/posts_blocs/edit_post_bloc/edit_post_bloc.dart';
import 'package:social_network_app/blocs/posts_blocs/get_posts_bloc/get_posts_bloc.dart';
import 'package:user_repository/user_repository.dart';

import '../../widgets/home/post_text_field.dart';

class EditPostScreen extends StatefulWidget {
  final MyUser myUser;
  final PostWithUser postWithUser;

  const EditPostScreen(this.myUser, this.postWithUser, {super.key});

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  late Post post;
  File? _selectedImage = File('');

  late TextEditingController _controller;

  @override
  void initState() {
    post = widget.postWithUser.post;
    //post.userId = widget.myUser.id;

    _controller = TextEditingController(text: post.content);

    super.initState();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    log(post.toString());
    return BlocListener<EditPostBloc, EditPostState>(
      listener: (context, state) {
        if (state is EditPostSuccess) {
          Navigator.of(context).pop();
          context.read<GetPostsBloc>().add(GetPosts());
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              log(post.toString());
              if (_controller.text.isNotEmpty) {
                setState(() {
                  post.content = _controller.text;
                });
                context.read<EditPostBloc>().add(EditPostRequested(
                    // postId: post.postId,
                    // userId: post.userId,
                    // newContent: post.content,
                    post: post,
                    imageUrl: _selectedImage!.path == '' ? (post.imageUrl ?? '') : _selectedImage!.path));
              }
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(45),
            ),
            child: Icon(
              CupertinoIcons.add,
              color: Theme.of(context).colorScheme.surface,
            ),
          ),
          appBar: AppBar(
            title: Text('Edit a Post'),
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PostTextField(
                    controller: _controller,
                  ),
                  const SizedBox(height: 10),
                  if (_selectedImage == null ||
                      _selectedImage?.path == "" ||
                      post.imageUrl == "" ||
                      post.imageUrl == null)
                    ElevatedButton.icon(
                      onPressed: _pickImage,
                      label: const Text('Add image'),
                      icon: const Icon(CupertinoIcons.photo),
                    )
                  else
                    Image.network(post.imageUrl ?? '')
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
