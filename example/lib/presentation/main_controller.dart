import 'package:example/domain/crypto_usecase.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';

class MainController extends GetxController {
  CryptoUseCase cryptoUseCase;
  MainController({required this.cryptoUseCase});

  Rx<String?> aesKey = null.obs;
  Rx<String?> aesIvKey = null.obs;

  Future<void> encryptAndDecryptAES() async {
    cryptoUseCase.encryptAndDecryptAES();
  }

  Future<void> encryptAndDecryptRSA() async {
    cryptoUseCase.encryptAndDecryptRSA();
  }

  Future<void> encryptAndDecryptED25519() async {
    cryptoUseCase.encryptAndDecryptED25519();
  }
}