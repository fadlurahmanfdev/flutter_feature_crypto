import 'dart:developer';

import 'package:example/data/dto/model/feature_model.dart';
import 'package:example/presentation/widget/feature_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feature_crypto/flutter_feature_crypto.dart';

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
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Feature Crypto'),
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
  late CryptoRSARepository cryptoRSARepository;
  late CryptoAESRepository cryptoAESRepository;
  late CryptoED25519Repository cryptoED25519Repository;
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
    )
  ];

  @override
  void initState() {
    super.initState();
    cryptoRSARepository = CryptoRSARepositoryImpl();
    cryptoAESRepository = CryptoAESRepositoryImpl();
    cryptoED25519Repository = CryptoED25519RepositoryIml();
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
                case "AES":
                  final key = cryptoAESRepository.getKey(32);
                  log("AES KEY: $key");
                  final ivKey = cryptoAESRepository.getIVKey();
                  log("IV KEY: $ivKey");
                  const plainText = 'Passw0rd!';
                  log("PLAIN TEXT: $plainText");
                  final encrypted = cryptoAESRepository.encrypt(key: key, ivKey: ivKey, plainText: plainText);
                  log("ENCRYPTED TEXT: $encrypted");
                  if (encrypted != null) {
                    final decrypted = cryptoAESRepository.decrypt(key: key, ivKey: ivKey, encryptedText: encrypted);
                    log("DECRYPTED TEXT: $decrypted");
                  }
                  break;
                case "RSA":
                  const plainText = "Passw0rd!";
                  log("PLAIN TEXT: $plainText");
                  final key = cryptoRSARepository.generateKey();
                  log("RSA PRIVATE KEY: ${key.privateKey}");
                  log("RSA PUBLIC KEY: ${key.publicKey}");
                  final encrypted = cryptoRSARepository.encrypt(
                    encodedPublicKey: key.publicKey,
                    plainText: plainText,
                    encoding: CoreCrytoRSAEncoding.pkcs1,
                    digest: CoreCryptoRSADigest.sha256,
                  );
                  log("ENCRYPTED TEXT: $encrypted");
                  if (encrypted != null) {
                    final decrypted = cryptoRSARepository.decrypt(
                      encodedPrivateKey: key.privateKey,
                      encryptedText: encrypted,
                      encoding: CoreCrytoRSAEncoding.pkcs1,
                      digest: CoreCryptoRSADigest.sha256,
                    );
                    log("DECRYPTED TEXT: $decrypted");
                  }

                  final signature = cryptoRSARepository.generateSignature(encodedPrivateKey: key.privateKey, plainText: plainText);
                  log("SIGNATURE: $signature");
                  if (signature != null) {
                    final isSignatureVerified = cryptoRSARepository.verifySignature(
                      encodedPublicKey: key.publicKey,
                      encodedSignature: signature,
                      plainText: plainText,
                    );
                    log("IS SIGNATURE VERIFIED: $isSignatureVerified");
                  }
                  break;
                case "ED25519":
                  const plainText = "Passw0rd!";
                  log("PLAIN TEXT: $plainText");
                  final key = cryptoED25519Repository.generateKey();
                  log("PRIVATE KEY: ${key.privateKey}");
                  log("PUBLIC KEY: ${key.publicKey}");
                  final signature =
                  cryptoED25519Repository.generateSignature(encodedPrivateKey: key.privateKey, plainText: plainText);
                  log("SIGNATURE: $signature");
                  if (signature != null) {
                    final isSignatureVerified = cryptoED25519Repository.verifySignature(
                      encodedPublicKey: key.publicKey,
                      encodedSignature: signature,
                      plainText: plainText,
                    );
                    log("IS SIGNATURE VERIFIED: $isSignatureVerified");
                  }
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
