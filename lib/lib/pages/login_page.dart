import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dhaba/blocs/login/login_bloc.dart';
import 'package:dhaba/lib/pages/vendor_list_page.dart';
import 'package:dhaba/lib/pages/regsitration_page.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bg-1.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state is LoginFailureState) {
                _showErrorSnackBar(context, state.error);
              } else if (state is LoginSuccessState) {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => VendorListPage(),
                ));
              }
            },
            child: BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                if (state is LoginLoadingState) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return LoginForm(
                    usernameController: _usernameController,
                    passwordController: _passwordController,
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String error) {
    final snackBar = SnackBar(
      content: Text(error),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

class LoginForm extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;

  LoginForm({
    required this.usernameController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    final loginBloc = BlocProvider.of<LoginBloc>(context);

    return Center(
      child: Container(
        width: 300,
        padding: EdgeInsets.all(20.0),
        margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset('assets/FAST.png'),
            SizedBox(height: 20),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.blue), // Set button color to blue
              ),
              onPressed: () {
                loginBloc.add(LoginButtonPressed(
                  username: usernameController.text,
                  password: passwordController.text,
                ));
              },
              child: Text('Login'),
            ),
            SizedBox(height: 12),
            BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                if (state is LoginFailureState) {
                  return Text(
                    state.error,
                    style: TextStyle(color: Colors.red),
                  );
                }
                return Container();
              },
            ),
            SizedBox(height: 12),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(
                        255, 33, 75, 243)), // Set button color to blue
              ),
              onPressed: () {
                // Navigate to the registration page
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => RegistrationPage(),
                ));
              },
              child: Text('Register Instead'),
            ),
          ],
        ),
      ),
    );
  }
}
