import 'package:crypto_vault/src/domain/exceptions/crypto_vault_exception.dart';

/// Package-level configuration for error reporting.
///
/// By default, most operations that return nullable results will swallow errors
/// and return `null`/`false` (backward compatible). Enable [throwOnError] to
/// always throw a [CryptoVaultException] instead.
class CryptoVaultConfig {
  /// If true, operations that would return `null`/`false` will throw
  /// [CryptoVaultException] with trace context.
  static bool throwOnError = false;

  /// Optional hook to observe failures even when [throwOnError] is false.
  static void Function(CryptoVaultException exception)? onError;
}

