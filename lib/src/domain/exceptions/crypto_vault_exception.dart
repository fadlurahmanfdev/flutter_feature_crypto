class CryptoVaultException implements Exception {
  final String code;
  final String message;
  final String? trace;

  const CryptoVaultException({
    required this.code,
    required this.message,
    this.trace,
  });

  @override
  String toString() {
    final t = trace;
    if (t == null || t.isEmpty) {
      return 'CryptoVaultException($code): $message';
    }
    return 'CryptoVaultException($code): $message\nTrace:\n$t';
  }
}
