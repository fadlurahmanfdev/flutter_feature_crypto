import 'package:example/data/dto/model/feature_model.dart';
import 'package:example/presentation/main_controller.dart';
import 'package:example/presentation/widget/feature_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late MainController controller;
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
    controller = Get.find<MainController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cryptography')),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: features.length,
        itemBuilder: (_, index) {
          final feature = features[index];
          return GestureDetector(
            onTap: () async {
              switch (feature.key) {
                case "AES":
                  controller.encryptAndDecryptAES();
                  break;
                case "RSA":
                  controller.encryptAndDecryptRSA();
                  break;
                case "ED25519":
                  controller.encryptAndDecryptED25519();
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
