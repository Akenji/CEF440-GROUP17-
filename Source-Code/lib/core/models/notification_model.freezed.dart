// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationModel {
  String get id;
  String get userId;
  String get title;
  String get message;
  NotificationType get type;
  NotificationPriority get priority;
  Map<String, dynamic> get data;
  bool get isRead;
  DateTime? get readAt;
  DateTime? get expiresAt;
  DateTime get createdAt;
  UserModel? get user;

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NotificationModelCopyWith<NotificationModel> get copyWith =>
      _$NotificationModelCopyWithImpl<NotificationModel>(
          this as NotificationModel, _$identity);

  /// Serializes this NotificationModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NotificationModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            const DeepCollectionEquality().equals(other.data, data) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.readAt, readAt) || other.readAt == readAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.user, user) || other.user == user));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      title,
      message,
      type,
      priority,
      const DeepCollectionEquality().hash(data),
      isRead,
      readAt,
      expiresAt,
      createdAt,
      user);

  @override
  String toString() {
    return 'NotificationModel(id: $id, userId: $userId, title: $title, message: $message, type: $type, priority: $priority, data: $data, isRead: $isRead, readAt: $readAt, expiresAt: $expiresAt, createdAt: $createdAt, user: $user)';
  }
}

/// @nodoc
abstract mixin class $NotificationModelCopyWith<$Res> {
  factory $NotificationModelCopyWith(
          NotificationModel value, $Res Function(NotificationModel) _then) =
      _$NotificationModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String userId,
      String title,
      String message,
      NotificationType type,
      NotificationPriority priority,
      Map<String, dynamic> data,
      bool isRead,
      DateTime? readAt,
      DateTime? expiresAt,
      DateTime createdAt,
      UserModel? user});

  $UserModelCopyWith<$Res>? get user;
}

/// @nodoc
class _$NotificationModelCopyWithImpl<$Res>
    implements $NotificationModelCopyWith<$Res> {
  _$NotificationModelCopyWithImpl(this._self, this._then);

  final NotificationModel _self;
  final $Res Function(NotificationModel) _then;

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? message = null,
    Object? type = null,
    Object? priority = null,
    Object? data = null,
    Object? isRead = null,
    Object? readAt = freezed,
    Object? expiresAt = freezed,
    Object? createdAt = null,
    Object? user = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as NotificationType,
      priority: null == priority
          ? _self.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as NotificationPriority,
      data: null == data
          ? _self.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      isRead: null == isRead
          ? _self.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      readAt: freezed == readAt
          ? _self.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiresAt: freezed == expiresAt
          ? _self.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      user: freezed == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserModel?,
    ));
  }

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res>? get user {
    if (_self.user == null) {
      return null;
    }

    return $UserModelCopyWith<$Res>(_self.user!, (value) {
      return _then(_self.copyWith(user: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _NotificationModel implements NotificationModel {
  const _NotificationModel(
      {required this.id,
      required this.userId,
      required this.title,
      required this.message,
      required this.type,
      this.priority = NotificationPriority.normal,
      final Map<String, dynamic> data = const {},
      this.isRead = false,
      this.readAt,
      this.expiresAt,
      required this.createdAt,
      this.user})
      : _data = data;
  factory _NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String title;
  @override
  final String message;
  @override
  final NotificationType type;
  @override
  @JsonKey()
  final NotificationPriority priority;
  final Map<String, dynamic> _data;
  @override
  @JsonKey()
  Map<String, dynamic> get data {
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_data);
  }

  @override
  @JsonKey()
  final bool isRead;
  @override
  final DateTime? readAt;
  @override
  final DateTime? expiresAt;
  @override
  final DateTime createdAt;
  @override
  final UserModel? user;

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$NotificationModelCopyWith<_NotificationModel> get copyWith =>
      __$NotificationModelCopyWithImpl<_NotificationModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$NotificationModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _NotificationModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.readAt, readAt) || other.readAt == readAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.user, user) || other.user == user));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      title,
      message,
      type,
      priority,
      const DeepCollectionEquality().hash(_data),
      isRead,
      readAt,
      expiresAt,
      createdAt,
      user);

  @override
  String toString() {
    return 'NotificationModel(id: $id, userId: $userId, title: $title, message: $message, type: $type, priority: $priority, data: $data, isRead: $isRead, readAt: $readAt, expiresAt: $expiresAt, createdAt: $createdAt, user: $user)';
  }
}

/// @nodoc
abstract mixin class _$NotificationModelCopyWith<$Res>
    implements $NotificationModelCopyWith<$Res> {
  factory _$NotificationModelCopyWith(
          _NotificationModel value, $Res Function(_NotificationModel) _then) =
      __$NotificationModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String title,
      String message,
      NotificationType type,
      NotificationPriority priority,
      Map<String, dynamic> data,
      bool isRead,
      DateTime? readAt,
      DateTime? expiresAt,
      DateTime createdAt,
      UserModel? user});

  @override
  $UserModelCopyWith<$Res>? get user;
}

/// @nodoc
class __$NotificationModelCopyWithImpl<$Res>
    implements _$NotificationModelCopyWith<$Res> {
  __$NotificationModelCopyWithImpl(this._self, this._then);

  final _NotificationModel _self;
  final $Res Function(_NotificationModel) _then;

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? message = null,
    Object? type = null,
    Object? priority = null,
    Object? data = null,
    Object? isRead = null,
    Object? readAt = freezed,
    Object? expiresAt = freezed,
    Object? createdAt = null,
    Object? user = freezed,
  }) {
    return _then(_NotificationModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as NotificationType,
      priority: null == priority
          ? _self.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as NotificationPriority,
      data: null == data
          ? _self._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      isRead: null == isRead
          ? _self.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      readAt: freezed == readAt
          ? _self.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiresAt: freezed == expiresAt
          ? _self.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      user: freezed == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserModel?,
    ));
  }

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res>? get user {
    if (_self.user == null) {
      return null;
    }

    return $UserModelCopyWith<$Res>(_self.user!, (value) {
      return _then(_self.copyWith(user: value));
    });
  }
}

// dart format on
