import '../../../domain/entities/reposts/repost_entity.dart';

class RepostModel {
  final String repostId;
  final String userId;
  final String targetId;
  final String type;
  final DateTime createdAt;

  RepostModel({
    required this.repostId,
    required this.userId,
    required this.targetId,
    required this.type,
    required this.createdAt,
  });

  factory RepostModel.fromEntity(RepostEntity entity) {
    return RepostModel(
      repostId: entity.repostId,
      userId: entity.userId,
      targetId: entity.targetId,
      type: entity.type,
      createdAt: entity.createdAt,
    );
  }

  RepostEntity toEntity() {
    return RepostEntity(
      repostId: repostId,
      userId: userId,
      targetId: targetId,
      type: type,
      createdAt: createdAt,
    );
  }
}
