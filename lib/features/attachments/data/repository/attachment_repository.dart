import 'package:dio/dio.dart';
import 'package:falsisters_pos_android/core/handlers/dio_client.dart';
import 'package:falsisters_pos_android/features/attachments/data/models/attachment_model.dart';
import 'package:falsisters_pos_android/features/attachments/data/models/attachment_type_enum.dart';
import 'package:image_picker/image_picker.dart';

class AttachmentRepository {
  final DioClient _dio = DioClient();

  Future<Map<String, dynamic>> createAttachment(
      XFile file, String name, AttachmentType type) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path),
        'name': name,
        'type': type
      });

      final response =
          await _dio.instance.post('/attachments/create', data: formData);

      return response.data;
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.error);
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }

  Future<List<AttachmentModel>> getAttachments() async {
    try {
      final response = await _dio.instance.get('/attachments');

      return (response.data as List)
          .map((attachment) => AttachmentModel.fromJson(attachment))
          .toList();
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.error);
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }

  Future<Map<String, dynamic>> getAttachment(String id) async {
    try {
      final response = await _dio.instance.get('/attachments/$id');

      return response.data;
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.error);
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }

  Future<Map<String, dynamic>> editAttachment(
    String id,
    String? name,
    AttachmentType? type,
  ) async {
    try {
      final response = await _dio.instance.put('/attachments/$id', data: {
        'name': name,
        'type': type,
      });

      return response.data;
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.error);
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }

  Future<Map<String, dynamic>> deleteAttachment(String id) async {
    try {
      final response = await _dio.instance.delete('/attachments/$id');

      return response.data;
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.error);
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }
}
