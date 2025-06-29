// notification_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_model.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

enum NotificationType {
  enrollment,
  attendance,
  grade,
  system,
  reminder
}
enum NotificationPriority {
  low,
  normal,
  high,
  urgent
}

@freezed
abstract class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required String id,
    required String userId,
    required String title,
    required String message,
    required NotificationType type,
    @Default(NotificationPriority.normal) NotificationPriority priority,
    @Default({}) Map<String, dynamic> data,
    @Default(false) bool isRead,
    DateTime? readAt,
    DateTime? expiresAt,
    required DateTime createdAt,
    UserModel? user,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}