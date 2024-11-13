import 'package:flutter/material.dart';
import 'package:flutter_post_list/post_list/model/post.dart';

class PostDetailPage extends StatelessWidget {
  const PostDetailPage({
    super.key,
    required this.post,
    required this.index,
    required this.posts,
    required this.onRemove,
  });

  final Post post;
  final int index;
  final List<Post> posts;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Container untuk Title
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  post.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 93, 71, 106),
                    fontSize: Theme.of(context).textTheme.headlineMedium?.fontSize,
                  ),
                ),
              ),
            ),
            // Container untuk Body
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                post.body,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16.0,
                ),
              ),
            ),
            // Tombol Navigasi
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      final prevIndex = index == 0 ? posts.length - 1 : index - 1;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PostDetailPage(
                            post: posts[prevIndex],
                            index: prevIndex,
                            posts: posts,
                            onRemove: onRemove,
                          ),
                        ),
                      );
                    },
                    child: const Text("Previous"),
                  ),
                  ElevatedButton(
                    onPressed: onRemove,
                    child: const Text("Remove"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final nextIndex = index == posts.length - 1 ? 0 : index + 1;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PostDetailPage(
                            post: posts[nextIndex],
                            index: nextIndex,
                            posts: posts,
                            onRemove: onRemove,
                          ),
                        ),
                      );
                    },
                    child: const Text("Next"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
