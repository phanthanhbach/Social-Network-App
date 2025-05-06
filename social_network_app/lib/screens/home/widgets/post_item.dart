import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:post_repository/post_repository.dart';
import 'package:social_network_app/blocs/posts_blocs/delete_post_bloc/delete_post_bloc.dart';
import 'package:social_network_app/blocs/posts_blocs/edit_post_bloc/edit_post_bloc.dart';
import 'package:social_network_app/blocs/posts_blocs/get_posts_bloc/get_posts_bloc.dart';
import 'package:social_network_app/screens/home/edit_post_screen.dart';
import 'package:social_network_app/screens/home/post_screen.dart';

class PostItem extends StatefulWidget {
  final PostWithUser postWithUser;
  final bool isCurrentUser;

  const PostItem({
    super.key,
    required this.postWithUser,
    required this.isCurrentUser,
  });

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  List<PopupMenuEntry<int>> postMenuItems(BuildContext context) {
    if (widget.isCurrentUser) {
      return [
        PopupMenuItem<int>(
          value: 1,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Theme.of(context).colorScheme.surfaceContainer,
            ),
            padding: const EdgeInsets.all(5),
            //color: Theme.of(context).colorScheme.surfaceContainer,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.edit,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text('Chỉnh sửa bài viết'),
              ],
            ),
          ),
        ),
        PopupMenuItem<int>(
          value: 2,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Theme.of(context).colorScheme.surfaceContainer,
            ),
            padding: const EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.delete,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text('Xóa'),
              ],
            ),
          ),
        ),
      ];
    }
    return [
      const PopupMenuItem<int>(
        value: 3,
        child: Text('Báo cáo'),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Container(
        width: MediaQuery.of(context).size.width,
        //height: 300,
        color: Theme.of(context).colorScheme.surfaceContainer,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: widget.postWithUser.user.profilePicture == ""
                        ? Container(
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
                          )
                        : Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(widget.postWithUser.user.profilePicture!),
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
                        widget.postWithUser.user.name,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        DateFormat('yyyy-MM-dd').format(widget.postWithUser.post.createdAt),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(
                    flex: 1,
                  ),
                  PopupMenuButton(
                      padding: const EdgeInsets.all(0),
                      color: Theme.of(context).colorScheme.surface,
                      icon: Icon(
                        CupertinoIcons.ellipsis,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      position: PopupMenuPosition.under,
                      onSelected: (value) {
                        if (value == 1) {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) => BlocProvider<EditPostBloc>(
                                create: (context) => EditPostBloc(
                                  postRepository: ServicesPostRepository(),
                                ),
                                child: EditPostScreen(
                                  widget.postWithUser.user,
                                  widget.postWithUser,
                                ),
                              ),
                            ),
                          );
                        } else if (value == 2) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Xác nhận xóa'),
                              content: const Text('Bạn có chắc chắn muốn xóa bài viết này không?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Hủy'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    context
                                        .read<DeletePostBloc>()
                                        .add(DeletePostRequested(post: widget.postWithUser.post));
                                  },
                                  child: const Text('Xóa', style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      itemBuilder: (context) => postMenuItems(context)),
                ],
              ),
              Container(
                child: Text(
                  widget.postWithUser.post.content,
                  textAlign: TextAlign.left,
                ),
              ),
              if (widget.postWithUser.post.imageUrl != null && widget.postWithUser.post.imageUrl != "")
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 400,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.postWithUser.post.imageUrl!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
