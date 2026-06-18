import 'dart:math';

class IdempotencyService {
  static final Random _random = Random();

  static String generateCuid() {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toRadixString(36);
    final counter = _random.nextInt(1679616).toRadixString(36).padLeft(4, '0');
    final fingerprint = _generateFingerprint();
    final random = _generateRandomBlock();
    return '$timestamp$counter$fingerprint$random';
  }

  static String generateIdempotencyKey() {
    final timestamp = DateTime.now().microsecondsSinceEpoch.toRadixString(36);
    final random = List.generate(12, (_) => _random.nextInt(36).toRadixString(36)).join();
    return 'idem_$timestamp$random';
  }

  static String _generateFingerprint() {
    final chars = List.generate(4, (_) => _random.nextInt(36).toRadixString(36));
    return chars.join();
  }

  static String _generateRandomBlock() {
    final chars = List.generate(8, (_) => _random.nextInt(36).toRadixString(36));
    return chars.join();
  }
}
