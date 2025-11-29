class ItemModel {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final String status;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  ItemModel({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    this.status = 'active',
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      status: json['status'] as String? ?? 'active',
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'status': status,
      'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  ItemModel copyWith({
    String? title,
    String? description,
    String? status,
    Map<String, dynamic>? metadata,
  }) {
    return ItemModel(
      id: id,
      userId: userId,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
