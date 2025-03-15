import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:post_repository/post_repository.dart';
import 'package:social_network_app/blocs/sign_in_bloc/sign_in_bloc.dart';

import '../../blocs/create_post_bloc/create_post_bloc.dart';
import '../../blocs/get_posts_bloc/get_posts_bloc.dart';
import '../../blocs/my_user_bloc/my_user_bloc.dart';
import '../../blocs/update_user_info_bloc/update_user_info_bloc.dart';
import 'post_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateUserInfoBloc, UpdateUserInfoState>(
      listener: (context, state) {
        if (state is UploadPictureSuccess) {
          setState(() {
            context.read<MyUserBloc>().state.user!.profilePicture = state.userImage;
          });
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        floatingActionButton: BlocBuilder<MyUserBloc, MyUserState>(
          // Todo Gom BlocBuilder lại
          builder: (context, state) {
            if (state.status == MyUserStatus.success) {
              return FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => BlocProvider<CreatePostBloc>(
                        create: (context) => CreatePostBloc(
                          postRepository: FirebasePostRepository(),
                        ),
                        child: PostScreen(
                          state.user!,
                        ),
                      ),
                    ),
                  );
                },
                child: Icon(
                  CupertinoIcons.add,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              );
            } else {
              return FloatingActionButton(
                onPressed: () {},
                child: Icon(
                  CupertinoIcons.add,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              );
            }
          },
        ),
        appBar: AppBar(
          centerTitle: false,
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          title: BlocBuilder<MyUserBloc, MyUserState>(
            builder: (context, state) {
              if (state.status == MyUserStatus.success) {
                return Row(
                  children: [
                    state.user!.profilePicture == ""
                        ? GestureDetector(
                            onTap: () async {
                              // Navigate to the user profile screen
                              final ImagePicker picker = ImagePicker();
                              final XFile? image = await picker.pickImage(
                                source: ImageSource.gallery,
                                maxHeight: 500,
                                maxWidth: 500,
                                imageQuality: 50,
                              );
                              if (image != null) {
                                CroppedFile? croppedFile = await ImageCropper().cropImage(
                                  sourcePath: image.path,
                                  aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
                                  uiSettings: [
                                    AndroidUiSettings(
                                      toolbarTitle: 'Cropper',
                                      toolbarColor: Theme.of(context).colorScheme.primary,
                                      toolbarWidgetColor: Colors.white,
                                      initAspectRatio: CropAspectRatioPreset.original,
                                      lockAspectRatio: false,
                                    ),
                                    IOSUiSettings(
                                      title: 'Cropper',
                                    )
                                  ],
                                );
                                if (croppedFile != null) {
                                  setState(() {
                                    context.read<UpdateUserInfoBloc>().add(
                                          UploadPicture(
                                            croppedFile.path,
                                            context.read<MyUserBloc>().state.user!.id,
                                          ),
                                        );
                                  });
                                }
                              }
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.shade300,
                              ),
                              child: Icon(
                                CupertinoIcons.person,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          )
                        : Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(state.user!.profilePicture!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                    const SizedBox(width: 10),
                    const Text('Home Screen'),
                  ],
                );
              } else {
                return const Text('Home Screen');
              }
            },
          ),
          actions: [
            IconButton(
              icon: Icon(
                CupertinoIcons.square_arrow_right,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
              onPressed: () {
                // Logout functionality
                context.read<SignInBloc>().add(const SignOutRequired());
              },
            ),
          ],
        ),
        body: BlocBuilder<GetPostsBloc, GetPostsState>(
          builder: (context, state) {
            if (state is GetPostsSuccess) {
              return ListView.builder(
                  itemCount: state.posts.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        //height: 300,
                        //color: Theme.of(context).colorScheme.secondary,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: NetworkImage(state.posts[index].myUser.profilePicture!),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        state.posts[index].myUser.name,
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.onPrimary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        DateFormat('yyyy-MM-dd').format(state.posts[index].createdAt),
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.onPrimary,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Container(
                                child: Text(
                                  state.posts[index].post,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              state.posts[index].imageUrl != null
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        height: 400,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(state.posts[index].imageUrl!),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            } else if (state is GetPostsLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return const Center(
                child: Text('Error loading posts'),
              );
            }
          },
        ),
      ),
    );
  }
}
