class CryptoVaultException implements Exception {
  String code;
  String message;

  CryptoVaultException({
    required this.code,
    required this.message,
  });
}
