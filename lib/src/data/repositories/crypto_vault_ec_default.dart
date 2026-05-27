import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:crypto_vault/src/crypto_vault_ec.dart';
import 'package:crypto_vault/src/domain/entities/crypto_key.dart';
import 'package:crypto_vault/src/domain/exceptions/crypto_vault_exception.dart';

class CryptoVaultEcDefault implements CryptoVaultEc {
  @override
  Future<CryptoKey> generateKeyPair({String? curve}) async {
    try {
      final algorithm = X25519();
      final keyPair = await algorithm.newKeyPair();
      return CryptoKey(
        privateKey: base64.encode(await keyPair.extractPrivateKeyBytes()),
        publicKey: base64.encode((await keyPair.extractPublicKey()).bytes),
      );
    } catch (error, stackTrace) {
      throw CryptoVaultException(
        code: 'EC_GENERATE_KEYPAIR_FAILED',
        message: 'Failed to generate EC key pair. Cause: $error',
        trace: stackTrace.toString(),
      );
    }
  }

  @override
  Future<String> generateSharedSecret({
    required String encodedPrivateKey,
    required String peerEncodedPublicKey,
  }) async {
    try {
      final algorithm = X25519();
      final keyPair = await algorithm.newKeyPairFromSeed(
        base64.decode(encodedPrivateKey),
      );
      final secretKey = await algorithm.sharedSecretKey(
        keyPair: keyPair,
        remotePublicKey: SimplePublicKey(
          base64.decode(peerEncodedPublicKey),
          type: KeyPairType.x25519,
        ),
      );
      return base64.encode(await secretKey.extractBytes());
    } catch (error, stackTrace) {
      throw CryptoVaultException(
        code: 'EC_SHARED_SECRET_FAILED',
        message: 'Failed to generate shared secret. Cause: $error',
        trace: stackTrace.toString(),
      );
    }
  }
}
