import 'package:flutter/material.dart';
import 'package:flutter_post_list/post_list/model/post.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PostDetailPage extends StatefulWidget {
  const PostDetailPage({
    super.key,
    required this.post,
    required this.posts,
    required this.currentIndex,
  });

  final Post post;
  final List<Post> posts;
  final int currentIndex;

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  late int currentIndex;
  late Post currentPost;
  String? authorName;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.currentIndex;
    currentPost = widget.post;
    _fetchAdditionalData();
  }

  Future<void> _fetchAdditionalData() async {
    final url = 'https://jsonplaceholder.typicode.com/posts/${currentPost.id}';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        authorName = data['userId']?.toString(); // Using userId as a placeholder for "author"
      });
    }
  }

  void _loadNextPost() {
    setState(() {
      currentIndex = (currentIndex + 1) % widget.posts.length;
      currentPost = widget.posts[currentIndex];
      _fetchAdditionalData();
    });
  }

  void _loadPreviousPost() {
    setState(() {
      currentIndex = (currentIndex - 1 + widget.posts.length) % widget.posts.length;
      currentPost = widget.posts[currentIndex];
      _fetchAdditionalData();
    });
  }

  void _removeCurrentPost() {
    Navigator.pop(context, currentIndex); // Pass the index back for removal
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Display additional data, e.g., author name
            if (authorName != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Author: $authorName',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            // Title Container
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
                  currentPost.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 93, 71, 106),
                    fontSize: Theme.of(context).textTheme.headlineMedium?.fontSize,
                  ),
                ),
              ),
            ),
            // Body Container
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
                currentPost.body,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16.0,
                ),
              ),
            ),
            // Navigation Buttons
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _loadPreviousPost,
                    child: const Text("Previous"),
                  ),
                  ElevatedButton(
                    onPressed: _removeCurrentPost,
                    child: const Text("Remove"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _loadNextPost,
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
