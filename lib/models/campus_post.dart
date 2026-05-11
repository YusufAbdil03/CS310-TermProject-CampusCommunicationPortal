import 'package:cloud_firestore/cloud_firestore.dart';

class CampusPost {
  final String id;
  final String title;
  final String description;
  final String location;
  final String dateLabel;
  final String assetImagePath;
  final String networkImageUrl;
  final String createdBy;
  final DateTime createdAt;

  const CampusPost({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.dateLabel,
    required this.assetImagePath,
    required this.networkImageUrl,
    required this.createdBy,
    required this.createdAt,
  });

  factory CampusPost.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CampusPost(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      location: data['location'] ?? '',
      dateLabel: data['dateLabel'] ?? '',
      assetImagePath: 'assets/images/campus_banner.png',
      networkImageUrl: data['networkImageUrl'] ?? '',
      createdBy: data['createdBy'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'location': location,
      'dateLabel': dateLabel,
      'networkImageUrl': networkImageUrl,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}