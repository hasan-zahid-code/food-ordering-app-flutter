import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// Events
abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginButtonPressed extends LoginEvent {
  final String username;
  final String password;

  const LoginButtonPressed({required this.username, required this.password});

  @override
  List<Object> get props => [username, password];
}

// States
abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitialState extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginSuccessState extends LoginState {
  final String token;

  const LoginSuccessState({required this.token});

  @override
  List<Object> get props => [token];
}

class LoginFailureState extends LoginState {
  final String error;

  const LoginFailureState({required this.error});

  @override
  List<Object> get props => [error];
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitialState());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoadingState();

      try {
        final response = await http.post(
          Uri.parse(
              'http://localhost:3000/api/login'), // Replace with your API endpoint
          body: jsonEncode({
            'Username': event.username,
            'Password': event.password,
          }),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          final token = json.decode(response.body)['token'];

          // Store the token in SharedPreferences
          await _storeToken(token);

          yield LoginSuccessState(token: token);
        } else {
          final error = json.decode(response.body)['error'];
          yield LoginFailureState(error: error);
        }
      } catch (error) {
        print('Error: $error');
        yield LoginFailureState(error: 'Server error. Please try again later.');
      }
    }
  }
}

Future<void> _storeToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('authToken', token);
}
