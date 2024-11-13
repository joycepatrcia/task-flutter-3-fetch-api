import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_post_list/post_list/cubit/post_list_cubit.dart';
import 'package:flutter_post_list/post_list/model/post.dart';
import 'post_detail_page.dart';

class PostListView extends StatelessWidget {
  const PostListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'POST LIST',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 93, 71, 106), // Custom app bar background
        centerTitle: true,
      ),
      body: BlocBuilder<PostListCubit, PostListState>(
        builder: (context, state) {
          if (state is PostListSuccess) {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              itemCount: state.posts.length,
              itemBuilder: (context, index) {
                final post = state.posts[index];
                return Dismissible(
                  key: Key(post.id.toString()),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    // Immediately remove the post upon swipe
                    context.read<PostListCubit>().removeData(index);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Post "${post.title}" removed'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.redAccent,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: GestureDetector(
                    onLongPress: () {
                      _showRemoveConfirmation(context, index, post);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white, // White background for each post container
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4.0,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(
                            post.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 93, 71, 106),
                            ),
                          ),
                          subtitle: Text(
                            post.body.length > 55
                                ? "${post.body.substring(0, 55)}..."
                                : post.body,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PostDetailPage(
                                  post: post,
                                  index: index,
                                  posts: state.posts,
                                  onRemove: () {
                                    _showRemoveConfirmation(context, index, post);
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (state is PostListError) {
            return Center(
              child: Text(
                state.errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (state is PostListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Center(
              child: ElevatedButton(
                onPressed: () => context.read<PostListCubit>().fetchPosts(),
                child: const Text("Refresh"),
              ),
            );
          }
        },
      ),
    );
  }

  void _showRemoveConfirmation(BuildContext context, int index, Post post) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content: const Text(
            "Are you sure you want to remove this post?",
            style: TextStyle(fontSize: 18),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                context.read<PostListCubit>().removeData(index);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Post "${post.title}" removed'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: const Text("Remove"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
              ),
            ),
          ],
        );
      },
    );
  }
}
