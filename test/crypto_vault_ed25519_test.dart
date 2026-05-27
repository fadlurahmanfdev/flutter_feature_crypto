import 'package:crypto_vault/crypto_vault.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> main() async {
  late CryptoVaultEd25519 cryptoVaultEd25519;
  group('ED25519 Test', () {
    setUp(() {
      CryptoVaultConfig.throwOnError = false;
      CryptoVaultConfig.onError = null;
      cryptoVaultEd25519 = CryptoVaultEd25519();
    });

    tearDown(() {
      CryptoVaultConfig.throwOnError = false;
      CryptoVaultConfig.onError = null;
    });

    test('generate ed25519 key success', () {
      final key = cryptoVaultEd25519.generateKey();
      expect(key.privateKey.isNotEmpty, true);
      expect(key.publicKey.isNotEmpty, true);
    });

    test('generate & verify signature using private key success', () {
      const plainText = 'Plain Text';
      final key = cryptoVaultEd25519.generateKey();
      final signature = cryptoVaultEd25519.generateSignature(
        encodedPrivateKey: key.privateKey,
        plainText: plainText,
      );
      expect(signature != null, true);
      expect(signature?.isNotEmpty, true);

      final isVerify = cryptoVaultEd25519.verifySignatureUsingPrivateKey(
        encodedPrivateKey: key.privateKey,
        encodedSignature: signature!,
        plainText: plainText,
      );
      expect(isVerify, true);
    });

    test('generate & verify signature using public key success', () {
      const plainText = 'Plain Text';
      final key = cryptoVaultEd25519.generateKey();
      final signature = cryptoVaultEd25519.generateSignature(
        encodedPrivateKey: key.privateKey,
        plainText: plainText,
      );
      expect(signature != null, true);
      expect(signature?.isNotEmpty, true);

      final isVerify = cryptoVaultEd25519.verifySignature(
        encodedPublicKey: key.publicKey,
        encodedSignature: signature!,
        plainText: plainText,
      );
      expect(isVerify, true);
    });

    test('failed generate signature using non private key', () {
      const plainText = 'Plain Text';
      final key = cryptoVaultEd25519.generateKey();
      final signature = cryptoVaultEd25519.generateSignature(
        encodedPrivateKey: key.publicKey,
        plainText: plainText,
      );
      expect(signature != null, false);
    });

    test(
        'generate & verify signature using public key failed using different plain text',
        () {
      const plainText = 'Plain Text';
      final key = cryptoVaultEd25519.generateKey();
      final signature = cryptoVaultEd25519.generateSignature(
        encodedPrivateKey: key.privateKey,
        plainText: plainText,
      );
      expect(signature != null, true);
      expect(signature?.isNotEmpty, true);

      final isVerify = cryptoVaultEd25519.verifySignature(
        encodedPublicKey: key.publicKey,
        encodedSignature: signature!,
        plainText: 'PLAIN TEXT',
      );
      expect(isVerify, false);
    });

    test(
        'generate & verify signature using public key failed verify using non public key',
        () {
      const plainText = 'Plain Text';
      final key = cryptoVaultEd25519.generateKey();
      final signature = cryptoVaultEd25519.generateSignature(
        encodedPrivateKey: key.privateKey,
        plainText: plainText,
      );
      expect(signature != null, true);
      expect(signature?.isNotEmpty, true);

      final isVerify = cryptoVaultEd25519.verifySignature(
        encodedPublicKey: key.privateKey,
        encodedSignature: signature!,
        plainText: plainText,
      );
      expect(isVerify, false);
    });

    test('throwOnError false returns null on ed25519 signature failure', () {
      CryptoVaultConfig.throwOnError = false;
      final key = cryptoVaultEd25519.generateKey();
      final signature = cryptoVaultEd25519.generateSignature(
        encodedPrivateKey: key.publicKey,
        plainText: 'plain',
      );
      expect(signature, null);
    });

    test('throwOnError true throws on ed25519 signature failure', () {
      CryptoVaultConfig.throwOnError = true;
      final key = cryptoVaultEd25519.generateKey();
      expect(
        () => cryptoVaultEd25519.generateSignature(
          encodedPrivateKey: key.publicKey,
          plainText: 'plain',
        ),
        throwsA(
          isA<CryptoVaultException>().having(
            (e) => e.code,
            'code',
            'OPERATION_FAILED',
          ),
        ),
      );
    });
  });
}
