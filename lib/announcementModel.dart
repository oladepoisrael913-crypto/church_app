import 'package:cloud_firestore/cloud_firestore.dart';


class Announcement {
  final String id;
  final String title;
  final String message;
  final Timestamp createdAt;
  final String postedBy;

  Announcement({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.postedBy,
  });

  factory Announcement.fromMap(String id, Map<String, dynamic> data) {
    return Announcement(
      id: id,
      title: data['title'] ?? '',
      message: data['message'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      postedBy: data['postedBy'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'message': message,
      'createdAt': createdAt,
      'postedBy': postedBy,
    };
  }
}