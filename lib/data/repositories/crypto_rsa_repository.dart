

import 'package:flutter_core_crypto/data/dto/model/crypto_key.dart';

abstract class CryptoRSARepository {
  CryptoKey generateKey();

  String? encrypt({
    required String encodedPublicKey,
    required String plainText,
  });

  String? decrypt({
    required String encodedPrivateKey,
    required String encryptedText,
  });

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
