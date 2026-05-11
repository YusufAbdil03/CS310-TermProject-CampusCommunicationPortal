import 'package:flutter/material.dart';
import '../models/campus_post.dart';
import '../services/post_service.dart';

class PostProvider extends ChangeNotifier {
  final PostService _postService = PostService();
  List<CampusPost> _posts = [];
  bool _isLoading = false;
  String? _error;

  List<CampusPost> get posts => _posts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void listenToPosts() {
    _isLoading = true;
    notifyListeners();

    _postService.getPosts().listen(
      (posts) {
        _posts = posts;
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (e) {
        _error = e.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> addPost(CampusPost post) async {
    await _postService.createPost(post);
  }

  Future<void> deletePost(String id) async {
    await _postService.deletePost(id);
  }

  Future<void> updatePost(String id, Map<String, dynamic> data) async {
    await _postService.updatePost(id, data);
  }
}