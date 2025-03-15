import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:post_repository/post_repository.dart';
import 'package:social_network_app/blocs/create_post_bloc/create_post_bloc.dart';
import 'package:user_repository/user_repository.dart';

import '../../components/home/post_text_field.dart';

class PostScreen extends StatefulWidget {
  final MyUser myUser;
  const PostScreen(this.myUser, {super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  late Post post;
  late File? _selectedImage;

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    post = Post.empty;
    post.myUser = widget.myUser;
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
    return BlocListener<CreatePostBloc, CreatePostState>(
      listener: (context, state) {
        if (state is CreatePostSuccess) {
          Navigator.of(context).pop();
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              log(post.toString());
              if (_controller.text.length != 0) {
                setState(() {
                  post.post = _controller.text;
                });
                context.read<CreatePostBloc>().add(CreatePost(post, _selectedImage?.path));
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
            title: Text('Create a Post'),
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
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    label: Text('Add Image'),
                    icon: Icon(CupertinoIcons.photo),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
