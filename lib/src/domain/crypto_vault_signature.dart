/// Shared contract for algorithms that support signing and verification.
abstract class CryptoVaultSignature {
  String? generateSignature({
    required String encodedPrivateKey,
    required String plainText,
  });

  bool verifySignature({
    required String encodedPublicKey,
    required String encodedSignature,
    required String plainText,
  });
}
