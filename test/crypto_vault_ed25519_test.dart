import 'package:crypto_vault/crypto_vault.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> cryptoVaultEd25519Test() async {
  late CryptoVaultEd25519 cryptoVaultEd25519;
  group('ED25519 Test', () {
    setUp(() {
      cryptoVaultEd25519 = CryptoVaultEd25519();
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
  });
}
