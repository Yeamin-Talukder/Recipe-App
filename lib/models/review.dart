import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String id;         // same as userId — one review per user per recipe
  final String userId;
  final String userName;
  final String? userPhoto;
  final double rating;
  final String comment;
  final DateTime createdAt;

  const Review({
    required this.id,
    required this.userId,
    required this.userName,
    this.userPhoto,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory Review.fromFirestore(String docId, Map<String, dynamic> data) {
    return Review(
      id: docId,
      userId: data['userId'] as String? ?? docId,
      userName: data['userName'] as String? ?? 'Anonymous',
      userPhoto: data['userPhoto'] as String?,
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      comment: data['comment'] as String? ?? '',
      createdAt: data['createdAt'] is Timestamp
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.tryParse(data['createdAt'] as String? ?? '') ??
              DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'userName': userName,
      'userPhoto': userPhoto,
      'rating': rating,
      'comment': comment,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  Review copyWith({
    double? rating,
    String? comment,
  }) {
    return Review(
      id: id,
      userId: userId,
      userName: userName,
      userPhoto: userPhoto,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      createdAt: createdAt,
    );
  }
}
