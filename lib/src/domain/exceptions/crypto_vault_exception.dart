class CryptoVaultException implements Exception {
  final String code;
  final String message;

  const CryptoVaultException({
    required this.code,
    required this.message,
  });

  @override
  String toString() => 'CryptoVaultException($code): $message';
}
