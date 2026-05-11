import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/campus_post.dart';

class PostService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collection = 'posts';

  // CREATE
  Future<void> createPost(CampusPost post) async {
    await _db.collection(_collection).add(post.toMap());
  }

  // READ - real-time stream
  Stream<List<CampusPost>> getPosts() {
    return _db
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CampusPost.fromFirestore(doc))
            .toList());
  }

  // UPDATE
  Future<void> updatePost(String id, Map<String, dynamic> data) async {
    await _db.collection(_collection).doc(id).update(data);
  }

  // DELETE
  Future<void> deletePost(String id) async {
    await _db.collection(_collection).doc(id).delete();
  }
}