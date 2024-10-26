// secure_storage_service.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage storage = FlutterSecureStorage();

  Future<String?> obtenerUserId() async {
    return await storage.read(key: 'userId');
  }

  Future<String?> obtenerToken() async {
    return await storage.read(key: 'token');
  }

  Future<void> guardarUserId(String userId) async {
    await storage.write(key: 'userId', value: userId);
  }

  Future<void> guardarToken(String token) async {
    await storage.write(key: 'token', value: token);
  }

  Future<void> eliminarDatos() async {
    await storage.delete(key: 'userId');
    await storage.delete(key: 'token');
  }
}
