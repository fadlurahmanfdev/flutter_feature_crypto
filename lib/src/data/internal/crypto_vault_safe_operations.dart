import 'dart:developer';

/// Shared error handling for crypto operations that return nullable results.
mixin CryptoVaultSafeOperations {
  String? safeStringOperation(String operationName, String? Function() operation) {
    try {
      return operation();
    } on Error catch (error, stackTrace) {
      log('failed $operationName on error: $error, $stackTrace');
      return null;
    } on Exception catch (error, stackTrace) {
      log('failed $operationName on exception: $error, $stackTrace');
      return null;
    }
  }

  bool safeBoolOperation(String operationName, bool Function() operation) {
    try {
      return operation();
    } on Error catch (error, stackTrace) {
      log('failed $operationName on error: $error, $stackTrace');
      return false;
    } on Exception catch (error, stackTrace) {
      log('failed $operationName on exception: $error, $stackTrace');
      return false;
    }
  }
}
