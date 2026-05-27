import 'package:crypto_vault/crypto_vault.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> main() async {
  late CryptoVaultAes cryptoVaultAes;
  group('AES Test', () {
    setUp(() {
      CryptoVaultConfig.throwOnError = false;
      CryptoVaultConfig.onError = null;
      cryptoVaultAes = CryptoVaultAes();
    });

    tearDown(() {
      CryptoVaultConfig.throwOnError = false;
      CryptoVaultConfig.onError = null;
    });

    test('generate aes key success', () {
      final key = cryptoVaultAes.getKey(16);
      expect(key.isNotEmpty, true);
      expect(key.length, 16);
    });

    test('generate aes key success', () {
      final key = cryptoVaultAes.getKey(24);
      expect(key.length, 24);
    });

    test('generate aes key success', () {
      final key = cryptoVaultAes.getKey(32);
      expect(key.length, 32);
    });

    test('failed generate aes key with non 16/24/32 length key', () {
      try {
        cryptoVaultAes.getKey(25);
      } on CryptoVaultException catch (e) {
        expect(e.code, 'SIZE_NOT_VALID');
        expect(e.message, 'Size must be 16/24/32');
      }
    });

    test('generate iv key success', () {
      final key = cryptoVaultAes.getIVKey();
      expect(key.isNotEmpty, true);
    });

    test('encrypt text aes success', () {
      const plainText = 'Plain Text AES';
      final key = cryptoVaultAes.getKey(32);
      final ivKey = cryptoVaultAes.getIVKey();

      final encrypted = cryptoVaultAes.encrypt(
        key: key,
        ivKey: ivKey,
        plainText: plainText,
      );
      expect(encrypted != null, true);

      final decrypted = cryptoVaultAes.decrypt(
        key: key,
        ivKey: ivKey,
        encryptedText: encrypted!,
      );
      expect(decrypted != null, true);
      expect(decrypted, plainText);
    });

    test('failed encrypt text aes with non aes key', () {
      const plainText = 'Plain Text AES';
      final ivKey = cryptoVaultAes.getIVKey();

      final encrypted = cryptoVaultAes.encrypt(
        key: 'Some AES Fake Key',
        ivKey: ivKey,
        plainText: plainText,
      );
      expect(encrypted == null, true);
    });

    test('failed encrypt text aes with non aes iv key', () {
      const plainText = 'Plain Text AES';
      final key = cryptoVaultAes.getKey(16);

      final encrypted = cryptoVaultAes.encrypt(
        key: key,
        ivKey: 'Some Aes IV Key',
        plainText: plainText,
      );
      expect(encrypted == null, true);
    });

    test('throwOnError false returns null on aes encrypt failure', () {
      CryptoVaultConfig.throwOnError = false;
      final encrypted = cryptoVaultAes.encrypt(
        key: 'bad-key',
        ivKey: 'bad-iv',
        plainText: 'plain',
      );
      expect(encrypted, null);
    });

    test('throwOnError true throws on aes encrypt failure', () {
      CryptoVaultConfig.throwOnError = true;
      expect(
        () => cryptoVaultAes.encrypt(
          key: 'bad-key',
          ivKey: 'bad-iv',
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
