abstract class CryptoAESRepository {
  /// size must be 16, 24, 32
  String getKey(int size);

  String getIVKey();

  String? encrypt({
    required String key,
    required String ivKey,
    required String plainText,
  });

  String? decrypt({
    required String key,
    required String ivKey,
    required String encryptedText,
  });
}
