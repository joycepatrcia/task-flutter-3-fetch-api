part of "post_list_page.dart";

class PostListView extends StatelessWidget {
  const PostListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 93, 71, 106), // Moderate purple color
        title: const Center(
          child: Text(
            'POST LIST',
            style: TextStyle(
              fontWeight: FontWeight.bold, // Bold title text
              color: Colors.white, // White color for the text
            ),
          ),
        ),
      ),
      body: BlocBuilder<PostListCubit, PostListState>(
        builder: (context, state) {
          if (state is PostListSuccess) {
            return ListView.builder(
              itemCount: state.posts.length,
              itemBuilder: (context, index) {
                final post = state.posts[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 4.0,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(
                      post.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    subtitle: Text(
                      post.body.length > 50
                          ? "${post.body.substring(0, 50)}..."
                          : post.body,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PostDetailPage(
                            post: post,
                            posts: state.posts,
                            currentIndex: index,
                          ),
                        ),
                      ).then((removedIndex) {
                        if (removedIndex != null) {
                          context.read<PostListCubit>().removeData(removedIndex);
                        }
                      });
                    },
                    onLongPress: () {
                      _showConfirmationDialog(context, index);
                    },
                  ),
                );
              },
            );
          } else if (state is PostListError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.errorMessage),
                  ElevatedButton(
                    child: const Text("Refresh"),
                    onPressed: () => context.read<PostListCubit>().fetchPosts(),
                  ),
                ],
              ),
            );
          } else if (state is PostListLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Center(
              child: ElevatedButton(
                child: const Text("Refresh"),
                onPressed: () => context.read<PostListCubit>().fetchPosts(),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Triggering the refresh of posts when the button is pressed
          context.read<PostListCubit>().fetchPosts();
        },
        child: const Icon(Icons.refresh),
        tooltip: 'Refresh List',
      ),
    );
  }

  // Show confirmation dialog to hide the post
  void _showConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Hide Post'),
          content: const Text('Are you sure you want to hide this post?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<PostListCubit>().removeData(index);
                Navigator.of(context).pop();
              },
              child: const Text('Hide'),
            ),
          ],
        );
      },
    );
  }
}
