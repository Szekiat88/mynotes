import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/service/auth/auth/auth_service.dart';
import 'package:mynotes/service/auth/auth/bloc/auth_state.dart';
import 'package:mynotes/views/register_view.dart';
import '../constants/routes.dart';
import '../firebase_options.dart';
import 'dart:developer' as devtools show log;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../service/auth/auth/auth_exceptions.dart';
import '../service/auth/auth/bloc/auth_bloc.dart';
import '../service/auth/auth/bloc/auth_event.dart';
import '../utilities/dialogs/error_dialog.dart';

//Type stl to get this
//key in alt + enter for changing to either StatefulWidget/StatelessWidget
class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  //initstate
  @override
  void initState() {
    // TODO: implement initState
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Change to Container
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration:
                const InputDecoration(hintText: 'Enter your email here'),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            autocorrect: false,
            enableSuggestions: false,
            decoration:
                const InputDecoration(hintText: 'Enter your password here'),
          ),
          BlocListener<AuthBloc, AuthState>(
            listener: (context,state) async {
              if (state is AuthStateLoggedOut){
                if (state.exception is UserNotFoundAuthException) {
                  await showErrorDialog(context,'User not found');
                } else if (state.exception is WrongPasswordAuthException) {
                  await showErrorDialog(context,'Wrong credentials');
                } else if (state.exception is WrongPasswordAuthException) {
                  await showErrorDialog(context,'Authentication error');
                }
              }
            },
            child: TextButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  context.read<AuthBloc>().add(
                    AuthEventLogIn(
                      email,
                      password,
                    ),
                  );
                },
                child: const Text('Login'),
              )

          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/register/', (route) => false);
              },
              child: const Text('Not register yt? Register Here!'))
        ],
      ),
    );
  }
}
