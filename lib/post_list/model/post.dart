class Post {
  final String title;
  final String body;
  final int id;
  bool isHidden; // Non-final field to mark the post as hidden
  
  // Constructor without 'const'
  Post({
    required this.title,
    required this.body,
    required this.id,
    this.isHidden = false, // Default value for isHidden is false
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }
}
