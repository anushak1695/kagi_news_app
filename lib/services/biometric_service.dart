import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class BiometricService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  Future<bool> canAuthenticate() async {
    try {
      return await _localAuth.canCheckBiometrics ||
          await _localAuth.isDeviceSupported();
    } catch (e) {
      debugPrint('Error checking biometric support: $e');
      return false;
    }
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      debugPrint('Error getting available biometrics: $e');
      return [];
    }
  }

  Future<bool> authenticate({
    String localizedReason = 'Please authenticate to access the app',
    bool useErrorDialogs = true,
    bool stickyAuth = false,
  }) async {
    try {
      // Check if biometric authentication is available
      final canAuthenticate = await this.canAuthenticate();
      if (!canAuthenticate) {
        throw BiometricException(
          'Biometric authentication is not available on this device',
          BiometricErrorType.notAvailable,
        );
      }

      // Check available biometric types
      final availableBiometrics = await getAvailableBiometrics();
      if (availableBiometrics.isEmpty) {
        throw BiometricException(
          'No biometric methods are enrolled',
          BiometricErrorType.notEnrolled,
        );
      }

      // Attempt authentication
      final didAuthenticate = await _localAuth.authenticate(
        localizedReason: localizedReason,
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true,
        ),
      );

      if (!didAuthenticate) {
        throw BiometricException(
          'Authentication failed',
          BiometricErrorType.failed,
        );
      }

      return true;
    } on BiometricException catch (e) {
      rethrow;
    } catch (e) {
      debugPrint('Error during authentication: $e');
      throw BiometricException(
        'An unexpected error occurred during authentication',
        BiometricErrorType.unknown,
      );
    }
  }
}

enum BiometricErrorType {
  notAvailable,
  notEnrolled,
  failed,
  unknown,
}

class BiometricException implements Exception {
  final String message;
  final BiometricErrorType type;

  BiometricException(this.message, this.type);

  @override
  String toString() => message;
} 