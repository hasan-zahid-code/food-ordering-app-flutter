import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dhaba/pages/vendor/classes_data.dart';

// Events
abstract class VendorLoginEvent extends Equatable {
  const VendorLoginEvent();
}

class VendorLoginButtonPressed extends VendorLoginEvent {
  final String phone;
  final String password;

  const VendorLoginButtonPressed({required this.phone, required this.password});

  @override
  List<Object> get props => [phone, password];
}

// States
abstract class VendorLoginState extends Equatable {
  const VendorLoginState();

  @override
  List<Object> get props => [];
}

class VendorLoginInitialState extends VendorLoginState {}

class VendorLoginLoadingState extends VendorLoginState {}

class VendorLoginSuccessState extends VendorLoginState {
  final bool success;

  const VendorLoginSuccessState({required this.success});

  @override
  List<Object> get props => [success];
}

class VendorLoginFailureState extends VendorLoginState {
  final String error;

  const VendorLoginFailureState({required this.error});

  @override
  List<Object> get props => [error];
}

class VendorLoginBloc extends Bloc<VendorLoginEvent, VendorLoginState> {
  VendorLoginBloc() : super(VendorLoginInitialState());

  @override
  Stream<VendorLoginState> mapEventToState(VendorLoginEvent event) async* {
    if (event is VendorLoginButtonPressed) {
      yield VendorLoginLoadingState();

      try {
        final response = await http.post(
          Uri.parse('http://localhost:3000/api/vendorLogin'),
          body: jsonEncode({
            'contactNo': event.phone,
            'Password': event.password,
          }),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          final success = json.decode(response.body)['Success'];
          currentVendor = Vendor.fromJson(json.decode(response.body)['Vendor']);

          yield VendorLoginSuccessState(success: success);
        } else {
          final error = json.decode(response.body)['error'];
          yield VendorLoginFailureState(error: error);
        }
      } catch (error) {
        print('Error: $error');
        yield const VendorLoginFailureState(
            error: 'Server error. Please try again later.');
      }
    }
  }
}
