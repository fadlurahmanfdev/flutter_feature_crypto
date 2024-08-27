import 'package:flutter_feature_crypto/flutter_feature_crypto.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> cryptoRSARepositoryImpl() async {
  late CryptoRSARepository cryptoRSARepository;
  group('RSA Test', () {
    setUp(() {
      cryptoRSARepository = CryptoRSARepositoryImpl();
    });

    test('generate rsa key success', () {
      final key = cryptoRSARepository.generateKey();
      expect(key.privateKey.isNotEmpty, true);
      expect(key.publicKey.isNotEmpty, true);
    });

    test('generate & verify signature using private key success', () {
      const plainText = "Plain Text";
      final key = cryptoRSARepository.generateKey();
      final signature = cryptoRSARepository.generateSignature(
        encodedPrivateKey: key.privateKey,
        plainText: plainText,
      );
      expect(signature != null, true);
      expect(signature?.isNotEmpty, true);

      final isVerify = cryptoRSARepository.verifySignature(
        encodedPublicKey: key.publicKey,
        encodedSignature: signature!,
        plainText: plainText,
      );
      expect(isVerify, true);
    });

    test('failed generate signature using non private key', () {
      const plainText = "Plain Text";
      final key = cryptoRSARepository.generateKey();
      final signature = cryptoRSARepository.generateSignature(
        encodedPrivateKey: key.publicKey,
        plainText: plainText,
      );
      expect(signature != null, false);
    });

    test('encrypt & decrypt success PKCS1', () {
      const plainText = "Plain Text";
      final key = cryptoRSARepository.generateKey();
      final encrypted = cryptoRSARepository.encrypt(
        encodedPublicKey: key.publicKey,
        plainText: plainText,
        encoding: CoreCrytoRSAEncoding.pkcs1,
        digest: CoreCryptoRSADigest.sha1,
      );
      expect(encrypted != null, true);
      expect(encrypted?.isNotEmpty, true);

      final decrypted = cryptoRSARepository.decrypt(
        encodedPrivateKey: key.privateKey,
        encryptedText: encrypted!,
        encoding: CoreCrytoRSAEncoding.pkcs1,
        digest: CoreCryptoRSADigest.sha1,
      );
      expect(decrypted, plainText);
    });

    test('encrypt & decrypt success OAEP1', () {
      const plainText = "Plain Text";
      final key = cryptoRSARepository.generateKey();
      final encrypted = cryptoRSARepository.encrypt(
        encodedPublicKey: key.publicKey,
        plainText: plainText,
        encoding: CoreCrytoRSAEncoding.oaep,
        digest: CoreCryptoRSADigest.sha1,
      );
      expect(encrypted != null, true);
      expect(encrypted?.isNotEmpty, true);

      final decrypted = cryptoRSARepository.decrypt(
        encodedPrivateKey: key.privateKey,
        encryptedText: encrypted!,
        encoding: CoreCrytoRSAEncoding.oaep,
        digest: CoreCryptoRSADigest.sha1,
      );
      expect(decrypted, plainText);
    });

    test('encrypt & decrypt success Digest SHA 256', () {
      const plainText = "Plain Text";
      final key = cryptoRSARepository.generateKey();
      final encrypted = cryptoRSARepository.encrypt(
        encodedPublicKey: key.publicKey,
        plainText: plainText,
        encoding: CoreCrytoRSAEncoding.oaep,
        digest: CoreCryptoRSADigest.sha256,
      );
      expect(encrypted != null, true);
      expect(encrypted?.isNotEmpty, true);

      final decrypted = cryptoRSARepository.decrypt(
        encodedPrivateKey: key.privateKey,
        encryptedText: encrypted!,
        encoding: CoreCrytoRSAEncoding.oaep,
        digest: CoreCryptoRSADigest.sha256,
      );
      expect(decrypted, plainText);
    });

    test('failed decrypt using different encoding', () {
      const plainText = "Plain Text";
      final key = cryptoRSARepository.generateKey();
      final encrypted = cryptoRSARepository.encrypt(
        encodedPublicKey: key.publicKey,
        plainText: plainText,
        encoding: CoreCrytoRSAEncoding.oaep,
        digest: CoreCryptoRSADigest.sha256,
      );
      expect(encrypted != null, true);
      expect(encrypted?.isNotEmpty, true);

      final decrypted = cryptoRSARepository.decrypt(
        encodedPrivateKey: key.privateKey,
        encryptedText: encrypted!,
        encoding: CoreCrytoRSAEncoding.pkcs1,
        digest: CoreCryptoRSADigest.sha256,
      );
      expect(decrypted, null);
    });
  });
}
