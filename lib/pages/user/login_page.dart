import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dhaba/blocs/login_bloc.dart';
import 'package:dhaba/pages/user/vendor_list_page.dart';
import 'package:dhaba/pages/user/regsitration_page.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('User Login'),
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bg-1.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: BlocConsumer<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state is LoginSuccessState) {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => VendorListPage(),
                ));
              }
            },
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
    );
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
    const SPACING20px = SizedBox(height: 20);
    return Center(
      child: Container(
        width: 300,
        padding: EdgeInsets.fromLTRB(20, 80, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Image.asset(
                    'assets/FAST.png',
                    width: 200,
                  ),
                  SPACING20px,
                  const Text(
                    'DHAABA 2.0',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SPACING20px,
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Student ID (Kxxxxxx)',
                fillColor: Colors.white,
                filled: true,
                prefixText: 'K-',
                prefixStyle: TextStyle(
                    color: Colors
                        .black), // Optional: Customize the style of the prefix
              ),
            ),
            SPACING20px,
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            SPACING20px,
            ElevatedButton(
              onPressed: () {
                loginBloc.add(LoginButtonPressed(
                  username: usernameController.text,
                  password: passwordController.text,
                ));
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Login'),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.login,
                    size: 24.0,
                  ),
                ],
              ),
            ),
            SPACING20px,
            BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                if (state is LoginFailureState) {
                  Future.microtask(() {
                    final snackBar = SnackBar(
                      content: Text(state.error),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  });
                }
                return Container();
              },
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to the registration page
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => RegistrationPage(),
                ));
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Register'),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.app_registration,
                    size: 24.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
