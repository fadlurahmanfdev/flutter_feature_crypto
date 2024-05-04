import 'dart:async';

import 'crypto_aes_repository_impl.dart';
import 'crypto_ed25519_repository_impl.dart';
import 'crypto_rsa_repository_impl.dart';

Future<void> main() async {
  unawaited(cryptoAesRepositoryImpl());
  unawaited(cryptoED25519RepositoryImpl());
  unawaited(cryptoRSARepositoryImpl());
}
