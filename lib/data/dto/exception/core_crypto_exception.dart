class CoreCryptoException implements Exception {
  String code;
  String message;

  CoreCryptoException({
    required this.code,
    required this.message,
  });
}
