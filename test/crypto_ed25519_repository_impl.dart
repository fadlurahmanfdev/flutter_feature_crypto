import 'package:flutter_feature_crypto/flutter_feature_crypto.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> cryptoED25519RepositoryImpl() async {
  late CryptoED25519Repository cryptoED25519Repository;
  group('ED25519 Test', () {
    setUp(() {
      cryptoED25519Repository = CryptoED25519RepositoryIml();
    });

    test('generate ed25519 key success', () {
      final key = cryptoED25519Repository.generateKey();
      expect(key.privateKey.isNotEmpty, true);
      expect(key.publicKey.isNotEmpty, true);
    });

    test('generate & verify signature using private key success', () {
      const plainText = "Plain Text";
      final key = cryptoED25519Repository.generateKey();
      final signature = cryptoED25519Repository.generateSignature(
        encodedPrivateKey: key.privateKey,
        plainText: plainText,
      );
      expect(signature != null, true);
      expect(signature?.isNotEmpty, true);

      final isVerify = cryptoED25519Repository.verifySignatureUsingPrivateKey(
        encodedPrivateKey: key.privateKey,
        encodedSignature: signature!,
        plainText: plainText,
      );
      expect(isVerify, true);
    });

    test('generate & verify signature using public key success', () {
      const plainText = "Plain Text";
      final key = cryptoED25519Repository.generateKey();
      final signature = cryptoED25519Repository.generateSignature(
        encodedPrivateKey: key.privateKey,
        plainText: plainText,
      );
      expect(signature != null, true);
      expect(signature?.isNotEmpty, true);

      final isVerify = cryptoED25519Repository.verifySignature(
        encodedPublicKey: key.publicKey,
        encodedSignature: signature!,
        plainText: plainText,
      );
      expect(isVerify, true);
    });

    test('failed generate signature using non private key', () {
      const plainText = "Plain Text";
      final key = cryptoED25519Repository.generateKey();
      final signature = cryptoED25519Repository.generateSignature(
        encodedPrivateKey: key.publicKey,
        plainText: plainText,
      );
      expect(signature != null, false);
    });

    test('generate & verify signature using public key failed using different plain text', () {
      const plainText = "Plain Text";
      final key = cryptoED25519Repository.generateKey();
      final signature = cryptoED25519Repository.generateSignature(
        encodedPrivateKey: key.privateKey,
        plainText: plainText,
      );
      expect(signature != null, true);
      expect(signature?.isNotEmpty, true);

      final isVerify = cryptoED25519Repository.verifySignature(
        encodedPublicKey: key.publicKey,
        encodedSignature: signature!,
        plainText: "PLAIN TEXT",
      );
      expect(isVerify, false);
    });

    test('generate & verify signature using public key failed verify using non public key', () {
      const plainText = "Plain Text";
      final key = cryptoED25519Repository.generateKey();
      final signature = cryptoED25519Repository.generateSignature(
        encodedPrivateKey: key.privateKey,
        plainText: plainText,
      );
      expect(signature != null, true);
      expect(signature?.isNotEmpty, true);

      final isVerify = cryptoED25519Repository.verifySignature(
        encodedPublicKey: key.privateKey,
        encodedSignature: signature!,
        plainText: plainText,
      );
      expect(isVerify, false);
    });
  });
}
