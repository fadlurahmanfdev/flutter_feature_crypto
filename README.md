# Overview

This document provides an overview of the method(s) available in this library/package, including details on how to use them, the parameters they accept, and examples of usage.

## Methods
### AES

#### Generate Key

Generate AES Key


```dart
final key = cryptoAESRepository.getKey(32);
```

| Parameter Name | Type       | Required | Description |
|----------------|------------|----------|-------------|
| `size`         | int        | Yes      | possibility value is 16/24/32 |

#### Get IV Key

Generate Initialization Vector Key


```dart
final ivKey = cryptoAESRepository.getIVKey();
```

#### Encrypt

Encrypt plain text & return base64


```dart
final encrypted = cryptoAESRepository.encrypt(key: key, ivKey: ivKey, plainText: plainText);
```

| Parameter Name | Type       | Required | Description                                   |
|----------------|------------|----------|-----------------------------------------------|
| `key`          | string     | Yes      | key generated from Generate Key               |
| `ivKey`        | string     | Yes      | vector key generated from Get IV Key          |
| `plainText`    | string     | Yes      | text want to be encrypted                     |
| `mode`         | AESMode    | no      | AES Encryption mode, default is `AESMode.cbc` |

#### Decrypt

Decrypt encrypted text


```dart
final decrypted = cryptoAESRepository.decrypt(key: key, ivKey: ivKey, encryptedText: encrypted);
```

| Parameter Name | Type       | Required | Description                                   |
|----------------|------------|----------|-----------------------------------------------|
| `key`          | string     | Yes      | key generated from Generate Key               |
| `ivKey`        | string     | Yes      | vector key generated from Get IV Key          |
| `plainText`    | string     | Yes      | text want to be encrypted                     |
| `mode`         | AESMode    | no       | AES Encryption mode, default is `AESMode.cbc` |

### RSA

#### Generate Key

Generate RSA Key


```dart
final key = cryptoRSARepository.generateKey();
```

#### Encrypt

Encrypt plain text and return CryptoKey


```dart
final encrypted = cryptoRSARepository.encrypt(
  encodedPublicKey: key.publicKey,
  plainText: plainText,
  encoding: CoreCrytoRSAEncoding.pkcs1,
  digest: CoreCryptoRSADigest.sha256,
);
```

| Parameter Name     | Type       | Required | Description                            |
|--------------------|------------|----------|----------------------------------------|
| `encodedPublicKey` | string     | Yes      | public key generated from Generate Key |
| `encoding`         | CoreCrytoRSAEncoding     | Yes      | -                                      |
| `plainText`        | string     | Yes      | text want to be encrypted              |
| `digest`           | CoreCryptoRSADigest    | yes      | -                                      |

#### Decrypt

Decrypt encrypted text


```dart
final decrypted = cryptoRSARepository.decrypt(
  encodedPrivateKey: key.privateKey,
  encryptedText: encrypted,
  encoding: CoreCrytoRSAEncoding.pkcs1,
  digest: CoreCryptoRSADigest.sha256,
);
```

| Parameter Name     | Type       | Required | Description                            |
|--------------------|------------|----------|----------------------------------------|
| `encodedPublicKey` | string     | Yes      | public key generated from Generate Key |
| `encoding`         | CoreCrytoRSAEncoding     | Yes      | -                                      |
| `plainText`        | string     | Yes      | text want to be encrypted              |
| `digest`           | CoreCryptoRSADigest    | yes      | -                                      |


### ED25519

#### Generate Key

Generate ED25519 Key


```dart
final key = cryptoED25519Repository.generateKey();
```

#### Generate Signature

Generate ED25519 Signature


```dart
final signature =
cryptoED25519Repository.generateSignature(encodedPrivateKey: key.privateKey, plainText: plainText);
```

| Parameter Name     | Type       | Required | Description                             |
|--------------------|------------|----------|-----------------------------------------|
| `encodedPrivateKey` | string     | Yes      | private key generated from Generate Key |
| `plainText`        | string     | Yes      | text want to be encrypted               |

#### Verify Signature

Verify ED25519 Signature


```dart
final isSignatureVerified = cryptoED25519Repository.verifySignature(
  encodedPublicKey: key.publicKey,
  encodedSignature: signature,
  plainText: plainText,
);
```

| Parameter Name     | Type       | Required | Description                            |
|--------------------|------------|----------|----------------------------------------|
| `encodedPublicKey` | string     | Yes      | public key generated from Generate Key |
| `plainText`        | string     | Yes      | text want to be encrypted              |
| `encodedSignature`        | string     | Yes      | signature from Generate Signature      |
