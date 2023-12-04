import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  Post({
    required this.posterName,
    required this.createdAt,
    required this.text,
    required this.posterId,
    required this.posterImageUrl,
    this.like,
    this.postedImagePath,
    required this.reference,
  });

  factory Post.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    // ! 記号は nullable な型を non-nullable として扱う
    final map = snapshot.data()!;
    return Post(
        posterName: map['posterName'],
        createdAt: map['createdAt'],
        text: map['text'],
        like: map['like'],
        posterId: map['posterId'],
        posterImageUrl: map['posterImageUrl'],
        postedImagePath: map['postedImagePath'],
        reference: snapshot.reference);
  }

  Map<String, dynamic> toMap() {
    return {
      'posterName': posterName,
      'createdAt': createdAt,
      'like': like,
      'text': text,
      'posterId': posterId,
      'posterImageUrl': posterImageUrl,
      'postedImagePath': postedImagePath,
      // 'reference': reference, reference は field に含めなくてよい
      // field に含めなくても DocumentSnapshot に reference が存在するため
    };
  }

  // 投稿者
  final String posterName;

  // 投稿時間
  final Timestamp createdAt;

  // いいね
  final int? like;

  // 投稿文
  final String text;

  // 投稿者ID
  final String posterId;
  // 投稿者画像
  final String posterImageUrl;

  // 投稿画像
  final String? postedImagePath;

  // Firebaseのパス
  final DocumentReference reference;
}
