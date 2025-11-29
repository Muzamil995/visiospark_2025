class FileModel {
  final String id;
  final String userId;
  final String fileName;
  final String fileUrl;
  final String? fileType;
  final int? fileSize;
  final DateTime createdAt;

  FileModel({
    required this.id,
    required this.userId,
    required this.fileName,
    required this.fileUrl,
    this.fileType,
    this.fileSize,
    required this.createdAt,
  });

  factory FileModel.fromJson(Map<String, dynamic> json) {
    return FileModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      fileName: json['file_name'] as String,
      fileUrl: json['file_url'] as String,
      fileType: json['file_type'] as String?,
      fileSize: json['file_size'] as int?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'file_name': fileName,
      'file_url': fileUrl,
      'file_type': fileType,
      'file_size': fileSize,
      'created_at': createdAt.toIso8601String(),
    };
  }

  bool get isImage {
    final ext = fileName.split('.').last.toLowerCase();
    return ['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(ext);
  }

  bool get isVideo {
    final ext = fileName.split('.').last.toLowerCase();
    return ['mp4', 'mov', 'avi', 'mkv'].contains(ext);
  }

  bool get isPdf {
    return fileName.toLowerCase().endsWith('.pdf');
  }

  String get extension => fileName.split('.').last.toLowerCase();
}
