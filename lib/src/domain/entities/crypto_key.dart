class CryptoKey {
  final String publicKey;
  final String privateKey;

  const CryptoKey({
    required this.publicKey,
    required this.privateKey,
  });

  Map<String, dynamic> toJson() {
    return {
      'privateKey': privateKey,
      'publicKey': publicKey,
    };
  }
}
