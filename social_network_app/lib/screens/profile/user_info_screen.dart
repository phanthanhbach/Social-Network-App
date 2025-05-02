import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_network_app/blocs/posts_blocs/get_posts_bloc/get_posts_bloc.dart';
import 'package:social_network_app/blocs/update_user_info_bloc/update_user_info_bloc.dart';

import '../../blocs/my_user_bloc/my_user_bloc.dart';
import '../../widgets/text_field.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  void _showEditNameDialog(BuildContext context, String currentName) {
    final TextEditingController nameController = TextEditingController(text: currentName);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Cho phép mở rộng theo nội dung
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6, // Chiều cao ban đầu (50% màn hình)
          minChildSize: 0.3, // Chiều cao tối thiểu (30% màn hình)
          maxChildSize: 0.9, // Chiều cao tối đa (90% màn hình)
          expand: false, // Không bắt buộc phải mở rộng toàn màn hình
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController, // Kết nối với DraggableScrollableSheet
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                ),
                child: Column(
                  //mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Edit Name',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: nameController,
                      hintText: '',
                      obscureText: false,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Đóng bottom sheet
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            final newName = nameController.text.trim();
                            if (newName.isNotEmpty) {
                              // Dispatch an event to update the name
                              context.read<UpdateUserInfoBloc>().add(
                                    UpdateUserName(
                                      context.read<MyUserBloc>().state.user!.id,
                                      newName,
                                    ),
                                  );
                              setState(() {
                                // Update the UI immediately
                                context
                                    .read<MyUserBloc>()
                                    .add(GetMyUser(myUserId: context.read<MyUserBloc>().state.user!.id));
                                context.read<GetPostsBloc>().add(GetPosts());
                              });
                            }
                            Navigator.pop(context); // Đóng bottom sheet
                          },
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('User Infomation'),
      ),
      body: BlocBuilder<MyUserBloc, MyUserState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Profile Picture",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Theme.of(context).colorScheme.onPrimary,
                            ),
                            onPressed: () async {
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
                            child: const Text("Edit"),
                          ),
                        ],
                      ),
                      state.user?.profilePicture == ""
                          ? Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.shade300,
                              ),
                              child: Icon(
                                CupertinoIcons.person,
                                color: Colors.grey.shade400,
                              ),
                            )
                          : Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(state.user!.profilePicture!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Name",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Theme.of(context).colorScheme.onPrimary,
                            ),
                            onPressed: () {
                              _showEditNameDialog(context, state.user?.name ?? 'No name');
                            },
                            child: const Text('Edit'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.user?.name ?? 'No name',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
