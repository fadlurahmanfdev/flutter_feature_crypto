class CryptoKey {
  final String publicKey;
  final String privateKey;

  CryptoKey({
    required this.publicKey,
    required this.privateKey,
  });

  Map<String, dynamic> toJson() {
    return {
      "privateKey": privateKey,
      "publicKey": publicKey,
    };
  }
}
