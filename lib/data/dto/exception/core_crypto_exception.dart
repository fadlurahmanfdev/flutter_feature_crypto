class FeatureCryptoException implements Exception {
  String code;
  String message;

  FeatureCryptoException({
    required this.code,
    required this.message,
  });
}
