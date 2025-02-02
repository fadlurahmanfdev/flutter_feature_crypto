import 'dart:convert';

import 'package:flutter_feature_crypto/data/dto/model/crypto_key.dart';
import 'package:cryptography/cryptography.dart';

class FeatureCryptoEC {
  Future<CryptoKey> generateKeyPair({String? curve}) async {
    final algorithm = X25519();
    final keyPair = await algorithm.newKeyPair();
    return CryptoKey(
      privateKey: base64.encode(await keyPair.extractPrivateKeyBytes()),
      publicKey: base64.encode((await keyPair.extractPublicKey()).bytes),
    );
  }

  Future<String> generateSharedSecret({
    required String encodedPrivateKey,
    required String peerEncodedPublicKey,
  }) async {
    final algorithm = X25519();
    final keyPair = await algorithm.newKeyPairFromSeed(base64.decode(encodedPrivateKey));
    final secretKey =  await algorithm.sharedSecretKey(keyPair: keyPair, remotePublicKey: SimplePublicKey(base64.decode(peerEncodedPublicKey), type: KeyPairType.x25519));
    return base64.encode(await secretKey.extractBytes());
  }
}
