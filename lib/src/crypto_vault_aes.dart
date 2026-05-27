import 'package:crypto_vault/src/data/repositories/crypto_vault_aes_default.dart';
import 'package:encrypt/encrypt.dart';

/// AES symmetric encryption API.
abstract class CryptoVaultAes {
  factory CryptoVaultAes() = CryptoVaultAesDefault;

  /// Key size must be 16, 24, or 32.
  String getKey(int size);

  String getIVKey();

  String? encrypt({
    required String key,
    required String ivKey,
    required String plainText,
    AESMode mode = AESMode.cbc,
  });

  String? decrypt({
    required String key,
    required String ivKey,
    required String encryptedText,
    AESMode mode = AESMode.cbc,
  });
}
