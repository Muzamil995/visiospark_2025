import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../core/config/supabase_config.dart';
import '../core/utils/logger.dart';
import '../models/file_model.dart';

class StorageService {
  final _client = SupabaseConfig.client;
  final _uuid = const Uuid();

  Future<String?> uploadFile({
    required PlatformFile file,
    required String bucket,
    String? folder,
  }) async {
    try {
      if (file.bytes == null && file.path == null) {
        throw Exception('No file data available');
      }

      final fileName = '${_uuid.v4()}_${file.name}';
      final path = folder != null ? '$folder/$fileName' : fileName;

      AppLogger.info('Uploading file: $fileName to $bucket');
      if (file.bytes != null) {
        await _client.storage.from(bucket).uploadBinary(
          path,
          file.bytes!,
          fileOptions: FileOptions(
            contentType: lookupMimeType(file.name),
          ),
        );
      } else if (file.path != null) {
        final fileData = File(file.path!);
        await _client.storage.from(bucket).upload(
          path,
          fileData,
          fileOptions: FileOptions(
            contentType: lookupMimeType(file.name),
          ),
        );
      }

      final url = _client.storage.from(bucket).getPublicUrl(path);
      AppLogger.success('File uploaded: $url');
      return url;
    } catch (e) {
      AppLogger.error('Upload file error', e);
      rethrow;
    }
  }

  Future<String?> uploadImage({
    required XFile image,
    required String bucket,
    String? folder,
  }) async {
    try {
      final bytes = await image.readAsBytes();
      final fileName = '${_uuid.v4()}_${image.name}';
      final path = folder != null ? '$folder/$fileName' : fileName;

      AppLogger.info('Uploading image: $fileName to $bucket');
      await _client.storage.from(bucket).uploadBinary(
        path,
        bytes,
        fileOptions: FileOptions(
          contentType: lookupMimeType(image.name) ?? 'image/jpeg',
        ),
      );

      final url = _client.storage.from(bucket).getPublicUrl(path);
      AppLogger.success('Image uploaded: $url');
      return url;
    } catch (e) {
      AppLogger.error('Upload image error', e);
      rethrow;
    }
  }

  Future<String?> uploadAvatar(XFile image) async {
    final userId = SupabaseConfig.currentUserId;
    if (userId == null) throw Exception('User not authenticated');

    AppLogger.info('Uploading avatar for user: $userId');
    return uploadImage(
      image: image,
      bucket: SupabaseConfig.avatarsBucket,
      folder: userId,
    );
  }

  Future<String?> pickAndUploadFile({
    required String bucket,
    String? folder,
    List<String>? allowedExtensions,
  }) async {
    try {
      AppLogger.debug('Picking file for upload');
      final result = await FilePicker.platform.pickFiles(
        type: allowedExtensions != null ? FileType.custom : FileType.any,
        allowedExtensions: allowedExtensions,
        withData: true,
      );

      if (result == null || result.files.isEmpty) {
        AppLogger.warning('File pick cancelled');
        return null;
      }

      return uploadFile(
        file: result.files.first,
        bucket: bucket,
        folder: folder,
      );
    } catch (e) {
      AppLogger.error('Pick and upload file error', e);
      rethrow;
    }
  }

  Future<String?> pickAndUploadImage({
    required String bucket,
    String? folder,
    ImageSource source = ImageSource.gallery,
  }) async {
    try {
      AppLogger.debug('Picking image for upload');
      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image == null) {
        AppLogger.warning('Image pick cancelled');
        return null;
      }

      return uploadImage(
        image: image,
        bucket: bucket,
        folder: folder,
      );
    } catch (e) {
      AppLogger.error('Pick and upload image error', e);
      rethrow;
    }
  }

  Future<void> deleteFile({
    required String bucket,
    required String path,
  }) async {
    try {
      AppLogger.info('Deleting file: $path from $bucket');
      await _client.storage.from(bucket).remove([path]);
      AppLogger.success('File deleted: $path');
    } catch (e) {
      AppLogger.error('Delete file error', e);
      rethrow;
    }
  }

  Future<FileModel?> saveFileRecord({
    required String fileName,
    required String fileUrl,
    String? fileType,
    int? fileSize,
  }) async {
    try {
      final userId = SupabaseConfig.currentUserId;
      if (userId == null) throw Exception('User not authenticated');

      AppLogger.info('Saving file record: $fileName');
      final response = await _client
          .from(SupabaseConfig.filesTable)
          .insert({
            'user_id': userId,
            'file_name': fileName,
            'file_url': fileUrl,
            'file_type': fileType,
            'file_size': fileSize,
            'created_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      AppLogger.success('File record saved');
      return FileModel.fromJson(response);
    } catch (e) {
      AppLogger.error('Save file record error', e);
      rethrow;
    }
  }

  Future<List<FileModel>> getUserFiles({int limit = 50, int offset = 0}) async {
    try {
      final userId = SupabaseConfig.currentUserId;
      if (userId == null) return [];

      AppLogger.debug('Fetching user files');
      final response = await _client
          .from(SupabaseConfig.filesTable)
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      AppLogger.success('Fetched ${(response as List).length} files');
      return (response).map((json) => FileModel.fromJson(json)).toList();
    } catch (e) {
      AppLogger.error('Get user files error', e);
      return [];
    }
  }
}
