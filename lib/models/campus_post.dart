class CampusPost {
  const CampusPost({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.dateLabel,
    required this.assetImagePath,
    required this.networkImageUrl,
  });

  final String id;
  final String title;
  final String description;
  final String location;
  final String dateLabel;
  final String assetImagePath;
  final String networkImageUrl;
}
