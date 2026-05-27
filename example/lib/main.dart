import 'dart:developer';

import 'package:crypto_vault/crypto_vault.dart';
import 'package:example/data/dto/model/feature_model.dart';
import 'package:example/presentation/widget/feature_widget.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto Vault Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Crypto Vault'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late CryptoVaultAes cryptoVaultAes;
  late CryptoVaultRsa cryptoVaultRsa;
  late CryptoVaultEd25519 cryptoVaultEd25519;
  late CryptoVaultEc cryptoVaultEc;
  List<FeatureModel> features = [
    FeatureModel(
      title: 'AES Encryption',
      desc: 'AES Encryption And Decryption',
      key: 'AES',
    ),
    FeatureModel(
      title: 'RSA Encryption',
      desc: 'RSA Encryption And Decryption',
      key: 'RSA',
    ),
    FeatureModel(
      title: 'ED25519 Encryption',
      desc: 'ED25519 Encryption And Decryption',
      key: 'ED25519',
    ),
    FeatureModel(
      title: 'Key Exchange ECDH',
      desc: 'Key Exchange ECDH',
      key: 'KEY_EXCHANGE_ECDH',
    ),
  ];

  @override
  void initState() {
    super.initState();
    cryptoVaultAes = CryptoVaultAes();
    cryptoVaultRsa = CryptoVaultRsa();
    cryptoVaultEd25519 = CryptoVaultEd25519();
    cryptoVaultEc = CryptoVaultEc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cryptography')),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: features.length,
        itemBuilder: (_, index) {
          final feature = features[index];
          return GestureDetector(
            onTap: () async {
              switch (feature.key) {
                case 'AES':
                  final key = cryptoVaultAes.getKey(32);
                  log('AES KEY: $key');
                  final ivKey = cryptoVaultAes.getIVKey();
                  log('IV KEY: $ivKey');
                  const plainText = 'Passw0rd!';
                  log('PLAIN TEXT: $plainText');
                  final encrypted = cryptoVaultAes.encrypt(
                    key: key,
                    ivKey: ivKey,
                    plainText: plainText,
                  );
                  log('ENCRYPTED TEXT: $encrypted');
                  if (encrypted != null) {
                    final decrypted = cryptoVaultAes.decrypt(
                      key: key,
                      ivKey: ivKey,
                      encryptedText: encrypted,
                    );
                    log('DECRYPTED TEXT: $decrypted');
                  }
                  break;
                case 'RSA':
                  const plainText = 'Passw0rd!';
                  log('PLAIN TEXT: $plainText');
                  final key = cryptoVaultRsa.generateKey();
                  log('RSA PRIVATE KEY: ${key.privateKey}');
                  log('RSA PUBLIC KEY: ${key.publicKey}');
                  final encrypted = cryptoVaultRsa.encrypt(
                    encodedPublicKey: key.publicKey,
                    plainText: plainText,
                    encoding: CryptoVaultRsaEncoding.pkcs1,
                    digest: CryptoVaultRsaDigest.sha256,
                  );
                  log('ENCRYPTED TEXT: $encrypted');
                  if (encrypted != null) {
                    final decrypted = cryptoVaultRsa.decrypt(
                      encodedPrivateKey: key.privateKey,
                      encryptedText: encrypted,
                      encoding: CryptoVaultRsaEncoding.pkcs1,
                      digest: CryptoVaultRsaDigest.sha256,
                    );
                    log('DECRYPTED TEXT: $decrypted');
                  }

                  final signature = cryptoVaultRsa.generateSignature(
                    encodedPrivateKey: key.privateKey,
                    plainText: plainText,
                  );
                  log('SIGNATURE: $signature');
                  if (signature != null) {
                    final isSignatureVerified = cryptoVaultRsa.verifySignature(
                      encodedPublicKey: key.publicKey,
                      encodedSignature: signature,
                      plainText: plainText,
                    );
                    log('IS SIGNATURE VERIFIED: $isSignatureVerified');
                  }
                  break;
                case 'ED25519':
                  const plainText = 'Passw0rd!';
                  log('PLAIN TEXT: $plainText');
                  final key = cryptoVaultEd25519.generateKey();
                  log('PRIVATE KEY: ${key.privateKey}');
                  log('PUBLIC KEY: ${key.publicKey}');
                  final signature = cryptoVaultEd25519.generateSignature(
                    encodedPrivateKey: key.privateKey,
                    plainText: plainText,
                  );
                  log('SIGNATURE: $signature');
                  if (signature != null) {
                    final isSignatureVerified =
                        cryptoVaultEd25519.verifySignature(
                      encodedPublicKey: key.publicKey,
                      encodedSignature: signature,
                      plainText: plainText,
                    );
                    log('IS SIGNATURE VERIFIED: $isSignatureVerified');
                  }
                  break;
                case 'KEY_EXCHANGE_ECDH':
                  final bobKeyPair = await cryptoVaultEc.generateKeyPair();
                  log('BOB PRIVATE KEY: ${bobKeyPair.privateKey}');
                  log('BOB PUBLIC KEY: ${bobKeyPair.publicKey}');
                  final aliceKeyPair = await cryptoVaultEc.generateKeyPair();
                  log('ALICE PRIVATE KEY: ${aliceKeyPair.privateKey}');
                  log('ALICE PUBLIC KEY: ${aliceKeyPair.publicKey}');
                  final agreement = await cryptoVaultEc.generateSharedSecret(
                    encodedPrivateKey: bobKeyPair.privateKey,
                    peerEncodedPublicKey: aliceKeyPair.publicKey,
                  );
                  log('AGREEMENT: $agreement');
                  break;
              }
            },
            child: ItemFeatureWidget(feature: feature),
          );
        },
      ),
    );
  }
}
