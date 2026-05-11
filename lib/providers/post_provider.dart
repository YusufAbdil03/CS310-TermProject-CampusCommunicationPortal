import 'dart:async';

import 'package:flutter/material.dart';
import '../models/campus_post.dart';
import '../services/post_service.dart';

class PostProvider extends ChangeNotifier {
  final PostService _postService = PostService();
  StreamSubscription<List<CampusPost>>? _postsSubscription;

  List<CampusPost> _posts = [];
  bool _isLoading = false;
  bool _isSaving = false;
  String? _error;
  String? _userId;

  List<CampusPost> get posts => _posts;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get error => _error;
  String? get userId => _userId;

  void updateUser(String? userId) {
    if (_userId == userId) return;

    _userId = userId;
    _postsSubscription?.cancel();
    _postsSubscription = null;

    if (userId == null) {
      _posts = [];
      _isLoading = false;
      _isSaving = false;
      _error = null;
      notifyListeners();
      return;
    }

    listenToPosts();
  }

  void listenToPosts() {
    if (_userId == null || _postsSubscription != null) return;

    _isLoading = true;
    notifyListeners();

    _postsSubscription = _postService.getPosts().listen(
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
    await _runWrite(() => _postService.createPost(post));
  }

  Future<void> deletePost(String id) async {
    await _runWrite(() => _postService.deletePost(id));
  }

  Future<void> updatePost(String id, Map<String, dynamic> data) async {
    await _runWrite(() => _postService.updatePost(id, data));
  }

  Future<void> _runWrite(Future<void> Function() action) async {
    _isSaving = true;
    _error = null;
    notifyListeners();

    try {
      await action();
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _postsSubscription?.cancel();
    super.dispose();
  }
}
