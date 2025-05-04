import 'package:dio/dio.dart';
import 'package:falsisters_pos_android/core/handlers/dio_client.dart';
import 'package:falsisters_pos_android/features/attachments/data/models/attachment_model.dart';
import 'package:falsisters_pos_android/features/attachments/data/models/attachment_type_enum.dart';
import 'package:falsisters_pos_android/features/attachments/data/models/create_attachment_request.dart';
import 'package:image_picker/image_picker.dart';

class AttachmentRepository {
  final DioClient _dio = DioClient();

  Future<Map<String, dynamic>> createAttachment(
      XFile file, String name, AttachmentType type) async {
    try {
      // Create proper request with formatted type
      final request = CreateAttachmentRequest(name: name, type: type);

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path),
        'name': request.name,
        'type': request
            .type, // This will be the clean enum value without the prefix
      });

      final response =
          await _dio.instance.post('/attachment/create', data: formData);

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
      final response = await _dio.instance.get('/attachment');

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
      final response = await _dio.instance.get('/attachment/$id');

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
      final data = <String, dynamic>{};
      if (name != null) data['name'] = name;
      if (type != null) {
        // Convert enum to clean string value
        data['type'] = type.toString().split('.').last;
      }

      final response = await _dio.instance.put('/attachment/$id', data: data);

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
      final response = await _dio.instance.delete('/attachment/$id');

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
