# Crypto Vault

Flutter cryptography library with a clean architecture layout. Use one import for AES, RSA, Ed25519, and X25519 key exchange.

## Package

Add to `pubspec.yaml`:

```yaml
dependencies:
  crypto_vault: any
```

Import:

```dart
import 'package:crypto_vault/crypto_vault.dart';
```

## Architecture

```
lib/
  crypto_vault.dart          # public exports only
  src/
    crypto_vault_aes.dart    # public API (domain contract)
    crypto_vault_rsa.dart
    crypto_vault_ed25519.dart
    crypto_vault_ec.dart
    domain/                  # entities, enums, shared contracts
    data/                    # default implementations
```

Public APIs use `CryptoVault{Algorithm}` classes with factory constructors that resolve to default implementations in `src/data/repositories/`. RSA and Ed25519 share signing methods via `CryptoVaultSignature`.

## Quick start

```dart
final aes = CryptoVaultAes();
final rsa = CryptoVaultRsa();
final ed25519 = CryptoVaultEd25519();
final ec = CryptoVaultEc();
```

## AES

### Generate key

```dart
final cryptoVaultAes = CryptoVaultAes();
final key = cryptoVaultAes.getKey(32);
```

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `size` | int | Yes | Must be 16, 24, or 32. Otherwise throws `CryptoVaultException` with code `SIZE_NOT_VALID`. |

**Possible exceptions**
- `CryptoVaultException(code: "SIZE_NOT_VALID")`: invalid key size.

### Get IV key

```dart
final ivKey = cryptoVaultAes.getIVKey();
```

### Encrypt

```dart
final encrypted = cryptoVaultAes.encrypt(
  key: key,
  ivKey: ivKey,
  plainText: plainText,
);
```

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `key` | String | Yes | Key from `getKey` |
| `ivKey` | String | Yes | IV from `getIVKey` |
| `plainText` | String | Yes | Text to encrypt |
| `mode` | AESMode | No | Default `AESMode.cbc` |

**Possible exceptions**
- By default: returns `null` on failure.
- If `CryptoVaultConfig.throwOnError = true`: throws `CryptoVaultException(code: "OPERATION_FAILED")` with `trace`.

### Decrypt

```dart
final decrypted = cryptoVaultAes.decrypt(
  key: key,
  ivKey: ivKey,
  encryptedText: encrypted,
);
```

**Possible exceptions**
- By default: returns `null` on failure.
- If `CryptoVaultConfig.throwOnError = true`: throws `CryptoVaultException(code: "OPERATION_FAILED")` with `trace`.

## RSA

### Generate key

```dart
final cryptoVaultRsa = CryptoVaultRsa();
final key = cryptoVaultRsa.generateKey();
```

### Encrypt

```dart
final encrypted = cryptoVaultRsa.encrypt(
  encodedPublicKey: key.publicKey,
  plainText: plainText,
  encoding: CryptoVaultRsaEncoding.pkcs1,
  digest: CryptoVaultRsaDigest.sha256,
);
```

**Possible exceptions**
- By default: returns `null` on failure.
- If `CryptoVaultConfig.throwOnError = true`: throws `CryptoVaultException(code: "OPERATION_FAILED")` with `trace`.

### Decrypt

```dart
final decrypted = cryptoVaultRsa.decrypt(
  encodedPrivateKey: key.privateKey,
  encryptedText: encrypted,
  encoding: CryptoVaultRsaEncoding.pkcs1,
  digest: CryptoVaultRsaDigest.sha256,
);
```

**Possible exceptions**
- By default: returns `null` on failure.
- If `CryptoVaultConfig.throwOnError = true`: throws `CryptoVaultException(code: "OPERATION_FAILED")` with `trace`.

### Sign and verify

```dart
final signature = cryptoVaultRsa.generateSignature(
  encodedPrivateKey: key.privateKey,
  plainText: plainText,
);

final verified = cryptoVaultRsa.verifySignature(
  encodedPublicKey: key.publicKey,
  encodedSignature: signature!,
  plainText: plainText,
);
```

**Possible exceptions**
- `generateSignature`: by default returns `null` on failure; with `CryptoVaultConfig.throwOnError = true` throws `CryptoVaultException(code: "OPERATION_FAILED")`.
- `verifySignature`: by default returns `false` on failure; with `CryptoVaultConfig.throwOnError = true` throws `CryptoVaultException(code: "OPERATION_FAILED")`.

## Ed25519

### Generate key

```dart
final cryptoVaultEd25519 = CryptoVaultEd25519();
final key = cryptoVaultEd25519.generateKey();
```

### Sign and verify

```dart
final signature = cryptoVaultEd25519.generateSignature(
  encodedPrivateKey: key.privateKey,
  plainText: plainText,
);

final verified = cryptoVaultEd25519.verifySignature(
  encodedPublicKey: key.publicKey,
  encodedSignature: signature!,
  plainText: plainText,
);
```

**Possible exceptions**
- `generateSignature`: by default returns `null` on failure; with `CryptoVaultConfig.throwOnError = true` throws `CryptoVaultException(code: "OPERATION_FAILED")`.
- `verifySignature` / `verifySignatureUsingPrivateKey`: by default returns `false` on failure; with `CryptoVaultConfig.throwOnError = true` throws `CryptoVaultException(code: "OPERATION_FAILED")`.

## EC (X25519 key exchange)

### Generate key pair

```dart
final cryptoVaultEc = CryptoVaultEc();
final key = await cryptoVaultEc.generateKeyPair();
```

**Possible exceptions**
- Always throws `CryptoVaultException(code: "EC_GENERATE_KEYPAIR_FAILED")` on failure (includes `trace`).

### Shared secret

```dart
final secret = await cryptoVaultEc.generateSharedSecret(
  encodedPrivateKey: 'our encoded private key',
  peerEncodedPublicKey: 'peer encoded public key',
);
```

**Possible exceptions**
- Always throws `CryptoVaultException(code: "EC_SHARED_SECRET_FAILED")` on failure (includes `trace`).

## Debugging failures

If you want failures to be **throwable** (instead of getting `null`/`false`), enable:

```dart
CryptoVaultConfig.throwOnError = true;
```

You can also observe failures without throwing:

```dart
CryptoVaultConfig.onError = (e) {
  // Send to crash reporting, logs, etc.
};
```

## Public types

| Type | Purpose |
|------|---------|
| `CryptoVaultAes` | AES encryption |
| `CryptoVaultRsa` | RSA encrypt/decrypt/sign |
| `CryptoVaultEd25519` | Ed25519 signing |
| `CryptoVaultEc` | X25519 key exchange |
| `CryptoVaultSignature` | Shared sign/verify contract |
| `CryptoKey` | Public/private key pair |
| `CryptoVaultException` | Domain errors |
| `CryptoVaultRsaEncoding` | RSA padding mode |
| `CryptoVaultRsaDigest` | RSA digest |
