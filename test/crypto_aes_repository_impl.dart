import 'package:flutter_core_crypto/flutter_core_crypto.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> cryptoAesRepositoryImpl() async {
  late CryptoAESRepository cryptoAesRepository;
  group('AES Test', () {
    setUp(() {
      cryptoAesRepository = CryptoAESRepositoryImpl();
    });

    test('generate aes key success', () {
      final key = cryptoAesRepository.getKey(16);
      expect(key.isNotEmpty, true);
      expect(key.length, 16);
    });

    test('generate aes key success', () {
      final key = cryptoAesRepository.getKey(24);
      expect(key.length, 24);
    });

    test('generate aes key success', () {
      final key = cryptoAesRepository.getKey(32);
      expect(key.length, 32);
    });

    test('failed generate aes key with non 16/24/32 length key', () {
      try {
        cryptoAesRepository.getKey(25);
      } on CoreCryptoException catch (e) {
        expect(e.code, "SIZE_NOT_VALID");
        expect(e.message, "Size must be 16/24/32");
      }
    });

    test('generate iv key success', () {
      final key = cryptoAesRepository.getIVKey();
      expect(key.isNotEmpty, true);
    });

    test('encrypt text aes success', () {
      const plainText = "Plain Text AES";
      final key = cryptoAesRepository.getKey(32);
      final ivKey = cryptoAesRepository.getIVKey();

      final encrypted = cryptoAesRepository.encrypt(
        key: key,
        ivKey: ivKey,
        plainText: plainText,
      );
      expect(encrypted != null, true);

      final decrypted = cryptoAesRepository.decrypt(
        key: key,
        ivKey: ivKey,
        encryptedText: encrypted!,
      );
      expect(decrypted != null, true);
      expect(decrypted, plainText);
    });

    test('failed encrypt text aes with non aes key', () {
      const plainText = "Plain Text AES";
      final ivKey = cryptoAesRepository.getIVKey();

      final encrypted = cryptoAesRepository.encrypt(
        key: "Some AES Fake Key",
        ivKey: ivKey,
        plainText: plainText,
      );
      expect(encrypted == null, true);
    });

    test('failed encrypt text aes with non aes iv key', () {
      const plainText = "Plain Text AES";
      final key = cryptoAesRepository.getKey(16);

      final encrypted = cryptoAesRepository.encrypt(
        key: key,
        ivKey: "Some Aes IV Key",
        plainText: plainText,
      );
      expect(encrypted == null, true);
    });
  });
}
