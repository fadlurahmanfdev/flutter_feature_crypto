import 'package:flutter_feature_crypto/data/dto/model/crypto_key.dart';
import 'package:flutter_feature_crypto/data/enum/rsa_digest.dart';
import 'package:flutter_feature_crypto/data/enum/rsa_encoding.dart';

abstract class CryptoRSARepository {
  CryptoKey generateKey();

  String? encrypt({
    required String encodedPublicKey,
    required String plainText,
    required CoreCrytoRSAEncoding encoding,
    required CoreCryptoRSADigest digest,
  });

  String? decrypt({
    required String encodedPrivateKey,
    required String encryptedText,
    required CoreCrytoRSAEncoding encoding,
    required CoreCryptoRSADigest digest,
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
