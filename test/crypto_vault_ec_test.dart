import 'package:crypto_vault/crypto_vault.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> cryptoVaultEcTest() async {
  late CryptoVaultEc cryptoVaultEc;

  group('EC Test', () {
    setUp(() {
      CryptoVaultConfig.throwOnError = false;
      CryptoVaultConfig.onError = null;
      cryptoVaultEc = CryptoVaultEc();
    });

    tearDown(() {
      CryptoVaultConfig.throwOnError = false;
      CryptoVaultConfig.onError = null;
    });

    test('generate key pair success', () async {
      final keyPair = await cryptoVaultEc.generateKeyPair();
      expect(keyPair.privateKey.isNotEmpty, true);
      expect(keyPair.publicKey.isNotEmpty, true);
    });

    test('generate shared secret success', () async {
      final bobKeyPair = await cryptoVaultEc.generateKeyPair();
      final aliceKeyPair = await cryptoVaultEc.generateKeyPair();

      final bobAgreement = await cryptoVaultEc.generateSharedSecret(
        encodedPrivateKey: bobKeyPair.privateKey,
        peerEncodedPublicKey: aliceKeyPair.publicKey,
      );
      final aliceAgreement = await cryptoVaultEc.generateSharedSecret(
        encodedPrivateKey: aliceKeyPair.privateKey,
        peerEncodedPublicKey: bobKeyPair.publicKey,
      );

      expect(bobAgreement.isNotEmpty, true);
      expect(aliceAgreement.isNotEmpty, true);
      expect(bobAgreement, aliceAgreement);
    });

    test('generate shared secret failed with invalid private key', () async {
      try {
        await cryptoVaultEc.generateSharedSecret(
          encodedPrivateKey: 'invalid-base64',
          peerEncodedPublicKey: 'invalid-base64',
        );
        fail('Expected CryptoVaultException');
      } on CryptoVaultException catch (e) {
        expect(e.code, 'EC_SHARED_SECRET_FAILED');
        expect(e.trace != null && e.trace!.isNotEmpty, true);
      }
    });
  });
}

