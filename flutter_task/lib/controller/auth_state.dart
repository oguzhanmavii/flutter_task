import 'dart:convert';

import 'package:flutter_task/controller/storage_state.dart';
import 'package:http/http.dart' as http;
import 'package:hooks_riverpod/hooks_riverpod.dart';


class AuthArgs {
  final String email;
  final String password;
  AuthArgs({required this.email, required this.password});
}

class AuthValues {
  AuthValues({
    required this.token,
    required this.refreshToken,
    required this.email,
    required this.clientId,
  });
  final String token;
  final String refreshToken;
  final String clientId;
  final String email;

  AuthValues.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        token = json['token'],
        refreshToken = json['refreshToken'],
        clientId = json['clientId'];
}

class AuthResponse {
  AuthResponse({required this.authValues, required this.statusCode});
  final AuthValues authValues;
  final int statusCode;
}

class AuthenticationHandler {
  late AuthValues authValues = AuthValues(
    email: 'eve.holt@reqres.in',
    clientId: '',
    refreshToken: '',
    token: 'QpwL5tke4Pnpja7X4',
  );

  Future<AuthResponse> login(AuthArgs args) async {
    final response = await http.post(
      Uri.http('https://reqres.in/', '/api/login'),
      body: {
        'email': 'eve.holt@reqres.in',
        'password': 'cityslicka',
        'token': 'QpwL5tke4Pnpja7X4',
      },
    );
    authValues = AuthValues.fromJson(jsonDecode(response.body));
    // return response.statusCode;
    return AuthResponse(
      authValues: authValues,
      statusCode: response.statusCode,
    );
  }
}

final authenticationHandlerProvider = StateProvider<AuthenticationHandler>(
  (_) => AuthenticationHandler(),
);

final authLoginProvider = FutureProvider.family<bool, AuthArgs>(
  (ref, authArgs) async {
    return Future.delayed(const Duration(seconds: 2), () async {
      final authResponse = await ref.watch(authenticationHandlerProvider).login(
            authArgs,
          );
      final isAuthenticated = authResponse.statusCode == 200;
      if (isAuthenticated) {
        ref.read(setAuthStateProvider.notifier).state = authResponse;
        ref.read(setIsAuthenticatedProvider(isAuthenticated));
        ref.read(setAuthenticatedUserProvider(authResponse.authValues.email));
      } else {
        ref.read(authErrorMessageProvider.notifier).state =
            'Error occurred while login with code: ${authResponse.statusCode}';
      }

      return isAuthenticated;
    });
  },
);

final authErrorMessageProvider = StateProvider<String>(
  (ref) => '',
);