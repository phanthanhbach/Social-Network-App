import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_network_app/blocs/sign_in_bloc/sign_in_bloc.dart';

import '../../blocs/my_user_bloc/my_user_bloc.dart';
import '../../blocs/update_user_info_bloc/update_user_info_bloc.dart';

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
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(
            CupertinoIcons.add,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
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
        body: ListView.builder(
            itemCount: 2,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  //color: Theme.of(context).colorScheme.secondary,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
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
                                  color: Theme.of(context).colorScheme.onSurface,
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
                                  'User Name',
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
                                  'Posted 2 hours ago',
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
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc eu tincidunt nisl. Nam posuere odio id lorem condimentum posuere. Nam et nisl ante. Cras molestie interdum magna nec sodales. Phasellus accumsan lectus non sapien laoreet porta. Cras ac magna auctor, tempor lacus et, fringilla erat.",
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
