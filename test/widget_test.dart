import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cs310_project/models/campus_post.dart';

void main() {
  test('CampusPost serializes Firestore fields used by PostProvider', () {
    final createdAt = DateTime(2026, 5, 11);
    final post = CampusPost(
      id: 'post-1',
      title: 'Book Sale',
      description: 'Selling CS310 books',
      location: 'FENS G062',
      dateLabel: '11/5/2026',
      assetImagePath: 'assets/images/campus_banner.png',
      networkImageUrl: '',
      createdBy: 'user-123',
      createdAt: createdAt,
    );

    final data = post.toMap();

    expect(data['title'], 'Book Sale');
    expect(data['description'], 'Selling CS310 books');
    expect(data['location'], 'FENS G062');
    expect(data['dateLabel'], '11/5/2026');
    expect(data['networkImageUrl'], '');
    expect(data['createdBy'], 'user-123');
    expect(data['createdAt'], isA<Timestamp>());
  });
}
