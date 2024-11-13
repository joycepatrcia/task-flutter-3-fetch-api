import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_post_list/post_list/post_list.dart';
import 'package:flutter_post_list/post_list/model/post.dart';
import 'package:flutter_post_list/post_list/view/post_detail_page.dart';

part "post_list_view.dart";

class PostListPage extends StatelessWidget {
  const PostListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostListCubit()..fetchPosts(),
      child: const PostListView(),
    );
  }
}
