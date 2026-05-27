import 'package:crypto_vault/crypto_vault.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> cryptoVaultRsaTest() async {
  late CryptoVaultRsa cryptoVaultRsa;
  group('RSA Test', () {
    setUp(() {
      cryptoVaultRsa = CryptoVaultRsa();
    });

    test('generate rsa key success', () {
      final key = cryptoVaultRsa.generateKey();
      expect(key.privateKey.isNotEmpty, true);
      expect(key.publicKey.isNotEmpty, true);
    });

    test('generate & verify signature using private key success', () {
      const plainText = 'Plain Text';
      final key = cryptoVaultRsa.generateKey();
      final signature = cryptoVaultRsa.generateSignature(
        encodedPrivateKey: key.privateKey,
        plainText: plainText,
      );
      expect(signature != null, true);
      expect(signature?.isNotEmpty, true);

      final isVerify = cryptoVaultRsa.verifySignature(
        encodedPublicKey: key.publicKey,
        encodedSignature: signature!,
        plainText: plainText,
      );
      expect(isVerify, true);
    });

    test('failed generate signature using non private key', () {
      const plainText = 'Plain Text';
      final key = cryptoVaultRsa.generateKey();
      final signature = cryptoVaultRsa.generateSignature(
        encodedPrivateKey: key.publicKey,
        plainText: plainText,
      );
      expect(signature != null, false);
    });

    test('encrypt & decrypt success PKCS1', () {
      const plainText = 'Plain Text';
      final key = cryptoVaultRsa.generateKey();
      final encrypted = cryptoVaultRsa.encrypt(
        encodedPublicKey: key.publicKey,
        plainText: plainText,
        encoding: CryptoVaultRsaEncoding.pkcs1,
        digest: CryptoVaultRsaDigest.sha1,
      );
      expect(encrypted != null, true);
      expect(encrypted?.isNotEmpty, true);

      final decrypted = cryptoVaultRsa.decrypt(
        encodedPrivateKey: key.privateKey,
        encryptedText: encrypted!,
        encoding: CryptoVaultRsaEncoding.pkcs1,
        digest: CryptoVaultRsaDigest.sha1,
      );
      expect(decrypted, plainText);
    });

    test('encrypt & decrypt success OAEP1', () {
      const plainText = 'Plain Text';
      final key = cryptoVaultRsa.generateKey();
      final encrypted = cryptoVaultRsa.encrypt(
        encodedPublicKey: key.publicKey,
        plainText: plainText,
        encoding: CryptoVaultRsaEncoding.oaep,
        digest: CryptoVaultRsaDigest.sha1,
      );
      expect(encrypted != null, true);
      expect(encrypted?.isNotEmpty, true);

      final decrypted = cryptoVaultRsa.decrypt(
        encodedPrivateKey: key.privateKey,
        encryptedText: encrypted!,
        encoding: CryptoVaultRsaEncoding.oaep,
        digest: CryptoVaultRsaDigest.sha1,
      );
      expect(decrypted, plainText);
    });

    test('encrypt & decrypt success Digest SHA 256', () {
      const plainText = 'Plain Text';
      final key = cryptoVaultRsa.generateKey();
      final encrypted = cryptoVaultRsa.encrypt(
        encodedPublicKey: key.publicKey,
        plainText: plainText,
        encoding: CryptoVaultRsaEncoding.oaep,
        digest: CryptoVaultRsaDigest.sha256,
      );
      expect(encrypted != null, true);
      expect(encrypted?.isNotEmpty, true);

      final decrypted = cryptoVaultRsa.decrypt(
        encodedPrivateKey: key.privateKey,
        encryptedText: encrypted!,
        encoding: CryptoVaultRsaEncoding.oaep,
        digest: CryptoVaultRsaDigest.sha256,
      );
      expect(decrypted, plainText);
    });

    test('failed decrypt using different encoding', () {
      const plainText = 'Plain Text';
      final key = cryptoVaultRsa.generateKey();
      final encrypted = cryptoVaultRsa.encrypt(
        encodedPublicKey: key.publicKey,
        plainText: plainText,
        encoding: CryptoVaultRsaEncoding.oaep,
        digest: CryptoVaultRsaDigest.sha256,
      );
      expect(encrypted != null, true);
      expect(encrypted?.isNotEmpty, true);

      final decrypted = cryptoVaultRsa.decrypt(
        encodedPrivateKey: key.privateKey,
        encryptedText: encrypted!,
        encoding: CryptoVaultRsaEncoding.pkcs1,
        digest: CryptoVaultRsaDigest.sha256,
      );
      expect(decrypted, null);
    });
  });
}
