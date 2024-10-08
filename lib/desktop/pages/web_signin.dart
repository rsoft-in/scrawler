import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:scrawler/helpers/constants.dart';

class WebSignIn extends StatefulWidget {
  const WebSignIn({super.key});

  @override
  State<WebSignIn> createState() => _WebSignInState();
}

class _WebSignInState extends State<WebSignIn> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                kAppName,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w200,
                ),
              ),
              kVSpace,
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(
                  hintText: 'Username',
                  prefixIcon: Icon(Symbols.person),
                ),
              ),
              kVSpace,
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Password',
                  prefixIcon: Icon(Symbols.password),
                ),
              ),
              kVSpace,
              FilledButton(
                onPressed: () {},
                child: const Text('Sign-In'),
              ),
              kVSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Do not have account?'),
                  kHSpace,
                  TextButton(
                    onPressed: () {},
                    child: const Text('Sign-Up'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
