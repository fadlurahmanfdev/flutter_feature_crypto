import 'dart:async';

import 'crypto_vault_aes_test.dart';
import 'crypto_vault_ed25519_test.dart';
import 'crypto_vault_rsa_test.dart';

Future<void> main() async {
  unawaited(cryptoVaultAesTest());
  unawaited(cryptoVaultEd25519Test());
  unawaited(cryptoVaultRsaTest());
}
