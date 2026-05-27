import 'dart:developer';

import 'package:crypto_vault/src/crypto_vault_config.dart';
import 'package:crypto_vault/src/domain/exceptions/crypto_vault_exception.dart';

/// Shared error handling for crypto operations that return nullable results.
mixin CryptoVaultSafeOperations {
  CryptoVaultException _buildException({
    required String operationName,
    required Object error,
    required StackTrace stackTrace,
  }) {
    return CryptoVaultException(
      code: 'OPERATION_FAILED',
      message: 'CryptoVault operation failed: $operationName. Cause: $error',
      trace: stackTrace.toString(),
    );
  }

  String? safeStringOperation(String operationName, String? Function() operation) {
    try {
      return operation();
    } on Error catch (error, stackTrace) {
      final exception = _buildException(
        operationName: operationName,
        error: error,
        stackTrace: stackTrace,
      );
      if (CryptoVaultConfig.throwOnError) throw exception;
      CryptoVaultConfig.onError?.call(exception);
      log(exception.toString());
      return null;
    } on Exception catch (error, stackTrace) {
      final exception = _buildException(
        operationName: operationName,
        error: error,
        stackTrace: stackTrace,
      );
      if (CryptoVaultConfig.throwOnError) throw exception;
      CryptoVaultConfig.onError?.call(exception);
      log(exception.toString());
      return null;
    }
  }

  bool safeBoolOperation(String operationName, bool Function() operation) {
    try {
      return operation();
    } on Error catch (error, stackTrace) {
      final exception = _buildException(
        operationName: operationName,
        error: error,
        stackTrace: stackTrace,
      );
      if (CryptoVaultConfig.throwOnError) throw exception;
      CryptoVaultConfig.onError?.call(exception);
      log(exception.toString());
      return false;
    } on Exception catch (error, stackTrace) {
      final exception = _buildException(
        operationName: operationName,
        error: error,
        stackTrace: stackTrace,
      );
      if (CryptoVaultConfig.throwOnError) throw exception;
      CryptoVaultConfig.onError?.call(exception);
      log(exception.toString());
      return false;
    }
  }
}
