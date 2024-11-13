import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_post_list/post_list/model/post.dart'; // Update model

part 'post_list_state.dart';

class PostListCubit extends Cubit<PostListState> {
  PostListCubit() : super(const PostListState.initial());

  fetchPosts() async {
    try {
      emit(const PostListState.loading());
      Dio dio = Dio();

      final res = await dio.get("https://jsonplaceholder.typicode.com/posts");

      if (res.statusCode == 200) {
        final List<Post> posts = res.data.map<Post>((d) {
          return Post.fromJson(d);
        }).toList();

        emit(PostListState.success(posts));
      } else {
        emit(PostListState.error("Error loading data: ${res.data.toString()}"));
      }
    } catch (e) {
      emit(PostListState.error("Error loading data: ${e.toString()}"));
    }
  }

  void removeData(int index) {
    if (state is PostListSuccess) {
      final posts = List<Post>.from((state as PostListSuccess).posts);
      posts.removeAt(index);
      emit(PostListSuccess(posts));
    }
  }


}
