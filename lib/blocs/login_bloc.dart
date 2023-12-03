import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dhaba/pages/user/classes_data.dart';

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
  final bool success;

  const LoginSuccessState({required this.success});

  @override
  List<Object> get props => [success];
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
            'ID': event.username,
            'Password': event.password,
          }),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          final success = json.decode(response.body)['Success'];
          currentUser = User.fromJson(json.decode(response.body)['User']);
          // print(currentUser.userName);
          // print(currentUser.studentId);
          // print(currentUser.favorites);
          yield LoginSuccessState(success: success);
        } else {
          final error = json.decode(response.body)['error'];
          yield LoginFailureState(error: error);
        }
      } catch (error) {
        print('Error: $error');
        yield const LoginFailureState(
            error: 'Server error. Please try again later.');
      }
    }
  }
}
