import 'user_model.dart';

class ChatRoomModel {
  final String id;
  final String? name;
  final bool isGroup;
  final String createdBy;
  final DateTime createdAt;
  final List<ChatParticipant>? participants;
  final MessageModel? lastMessage;
  final int unreadCount;

  ChatRoomModel({
    required this.id,
    this.name,
    this.isGroup = false,
    required this.createdBy,
    required this.createdAt,
    this.participants,
    this.lastMessage,
    this.unreadCount = 0,
  });

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomModel(
      id: json['id'] as String,
      name: json['name'] as String?,
      isGroup: json['is_group'] as bool? ?? false,
      createdBy: json['created_by'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      participants: json['participants'] != null
          ? (json['participants'] as List)
              .map((p) => ChatParticipant.fromJson(p))
              .toList()
          : null,
      lastMessage: json['last_message'] != null
          ? MessageModel.fromJson(json['last_message'])
          : null,
      unreadCount: json['unread_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'is_group': isGroup,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
    };
  }

  String getDisplayName(String currentUserId) {
    if (isGroup && name != null) return name!;
    if (participants != null) {
      final otherParticipant = participants!
          .where((p) => p.userId != currentUserId)
          .firstOrNull;
      return otherParticipant?.user?.displayName ?? 'Unknown';
    }
    return name ?? 'Chat';
  }

  String? getOtherUserAvatar(String currentUserId) {
    if (isGroup) return null;
    if (participants != null) {
      final otherParticipant = participants!
          .where((p) => p.userId != currentUserId)
          .firstOrNull;
      return otherParticipant?.user?.avatarUrl;
    }
    return null;
  }
}

class ChatParticipant {
  final String id;
  final String roomId;
  final String userId;
  final DateTime joinedAt;
  final UserModel? user;

  ChatParticipant({
    required this.id,
    required this.roomId,
    required this.userId,
    required this.joinedAt,
    this.user,
  });

  factory ChatParticipant.fromJson(Map<String, dynamic> json) {
    return ChatParticipant(
      id: json['id'] as String,
      roomId: json['room_id'] as String,
      userId: json['user_id'] as String,
      joinedAt: DateTime.parse(json['joined_at'] as String),
      user: json['profiles'] != null
          ? UserModel.fromJson(json['profiles'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'room_id': roomId,
      'user_id': userId,
      'joined_at': joinedAt.toIso8601String(),
    };
  }
}

class MessageModel {
  final String id;
  final String roomId;
  final String senderId;
  final String content;
  final String messageType;
  final String? fileUrl;
  final DateTime createdAt;
  final bool isRead;
  final UserModel? sender;

  MessageModel({
    required this.id,
    required this.roomId,
    required this.senderId,
    required this.content,
    this.messageType = 'text',
    this.fileUrl,
    required this.createdAt,
    this.isRead = false,
    this.sender,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      roomId: json['room_id'] as String,
      senderId: json['sender_id'] as String,
      content: json['content'] as String? ?? '',
      messageType: json['message_type'] as String? ?? 'text',
      fileUrl: json['file_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      isRead: json['is_read'] as bool? ?? false,
      sender: json['profiles'] != null
          ? UserModel.fromJson(json['profiles'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'room_id': roomId,
      'sender_id': senderId,
      'content': content,
      'message_type': messageType,
      'file_url': fileUrl,
      'created_at': createdAt.toIso8601String(),
      'is_read': isRead,
    };
  }

  bool get isImage => messageType == 'image';
  bool get isFile => messageType == 'file';
  bool get isVideo => messageType == 'video';
  bool get isText => messageType == 'text';
}
