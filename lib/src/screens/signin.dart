import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/io_client.dart' as http;
import 'package:nextcloud/nextcloud.dart';
import 'package:nextcloud/provisioning_api.dart';
import 'package:scrawler/src/screens/notes_page.dart';
import 'package:scrawler/src/widgets/rs_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/globals.dart' as globals;

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController serverController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool allowInsecure = false;

  bool _loading = false;

  /// Create HTTP client that ignores bad SSL certificates
  http.IOClient getInsecureClient() {
    final ioClient = HttpClient()
      ..badCertificateCallback = (cert, host, port) => true;
    return http.IOClient(ioClient);
  }

  Future<void> _checkStoredLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final server = prefs.getString('server');
    final username = prefs.getString('username');
    final password = prefs.getString('password');
    final insecure = prefs.getBool('insecure') ?? false;
    final userData = prefs.getString('user_data');

    if (server != null && username != null && password != null) {
      final parsed = jsonDecode(userData!);
      globals.userDetails = UserDetails.fromJson(parsed);
      _navigateToNotes(server, username, password, insecure);
    }
  }

  Future<void> connectNextCloud() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();
    final serverAddress = serverController.text.trim();

    if (serverAddress.isEmpty || username.isEmpty || password.isEmpty) {
      if (mounted) {
        RSToast.show(context, message: 'Please fill all fields');
      }
      return;
    }

    setState(() => _loading = true);

    try {
      final client = NextcloudClient(
        Uri.parse(serverAddress),
        loginName: username,
        password: password,
        httpClient: allowInsecure ? getInsecureClient() : null,
      );

      final response = await client.provisioningApi.users.getCurrentUser();
      if (response.body.ocs.meta.status == 'ok') {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('server', serverAddress);
        await prefs.setString('username', username);
        await prefs.setString('password', password);
        await prefs.setBool('insecure', allowInsecure);
        await prefs.setString(
            'user_data', jsonEncode(response.body.ocs.data.toJson()));
        globals.userDetails = response.body.ocs.data;

        _navigateToNotes(serverAddress, username, password, allowInsecure);
      } else {
        if (mounted) {
          RSToast.show(context, message: 'Invalid credentials!');
        }
      }
    } catch (e) {
      if (mounted) {
        RSToast.show(context, message: 'Login failed: $e');
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  void _navigateToNotes(
      String server, String username, String password, bool insecure) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => NotesPage(
          server: server,
          username: username,
          password: password,
          client: insecure ? getInsecureClient() : null,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _checkStoredLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 350),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              spacing: 16.0,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: serverController,
                  decoration: InputDecoration(
                    hintText: 'Server Address',
                  ),
                ),
                Row(
                  spacing: 8,
                  children: [
                    Checkbox(
                      value: allowInsecure,
                      onChanged: (value) =>
                          setState(() => allowInsecure = value!),
                    ),
                    Expanded(child: Text('Allow Insecure Server')),
                  ],
                ),
                TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    hintText: 'Username',
                  ),
                ),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                  ),
                ),
                const SizedBox(height: 16),
                _loading
                    ? const LinearProgressIndicator()
                    : FilledButton(
                        onPressed: _loading ? null : connectNextCloud,
                        child: const Text('Connect'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
