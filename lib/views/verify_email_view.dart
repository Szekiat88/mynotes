import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/service/auth/auth/auth_service.dart';
import 'package:mynotes/service/auth/auth/bloc/auth_event.dart';

import '../service/auth/auth/bloc/auth_bloc.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  _VerifyEmailViewState createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify email')),
      body: Column(
        children: [
          const Text(
              "We've sent you an email verification. Please open it to verify it gain"),
          const Text(
              "if you haven't received the verification email, please press the button below"),
          TextButton(
              onPressed: () async {
                context.read<AuthBloc>().add(const AuthEventSendEmailVerification(),);
              },
              child: const Text('Send email verification')),
          TextButton(
              onPressed: () async {
                context.read<AuthBloc>().add(const AuthEventLogOut(),);
              },
              child: const Text('Restart'))
        ],
      ),
    );
  }
}
