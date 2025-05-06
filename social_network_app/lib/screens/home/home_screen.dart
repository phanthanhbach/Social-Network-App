import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_repository/post_repository.dart';
import 'package:social_network_app/blocs/posts_blocs/delete_post_bloc/delete_post_bloc.dart';
import 'package:social_network_app/screens/home/widgets/post_item.dart';
import '../../blocs/posts_blocs/create_post_bloc/create_post_bloc.dart';
import '../../blocs/posts_blocs/get_posts_bloc/get_posts_bloc.dart';
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
    return MultiBlocListener(
      listeners: [
        BlocListener<UpdateUserInfoBloc, UpdateUserInfoState>(
          listener: (context, state) {
            if (state is UploadPictureSuccess) {
              setState(() {
                context.read<MyUserBloc>().state.user!.profilePicture = state.userImage;
              });
            }
          },
        ),
        BlocListener<DeletePostBloc, DeletePostState>(
          listener: (context, state) {
            if (state is DeletePostSuccess) {
              context.read<GetPostsBloc>().add(GetPosts());
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã xóa bài viết thành công')),
              );
            } else if (state is DeletePostFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Xóa bài viết thất bại')),
              );
            }
          },
        ),
      ],
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
                          postRepository: ServicesPostRepository(),
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
                  color: Theme.of(context).colorScheme.onPrimary,
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
          centerTitle: true,
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
          title: BlocBuilder<MyUserBloc, MyUserState>(
            builder: (context, state) {
              if (state.status == MyUserStatus.success) {
                return const Text('Home Screen');
              } else {
                return const Text('Home Screen');
              }
            },
          ),
        ),
        body: BlocBuilder<GetPostsBloc, GetPostsState>(
          builder: (context, state) {
            if (state is GetPostsSuccess) {
              final myUserState = context.read<MyUserBloc>().state;
              final currentUserId = myUserState.user?.id ?? '';

              return ListView.builder(
                  itemCount: state.posts.length,
                  itemBuilder: (context, index) {
                    return PostItem(
                      postWithUser: state.posts[index],
                      isCurrentUser: state.posts[index].user.id == currentUserId,
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
