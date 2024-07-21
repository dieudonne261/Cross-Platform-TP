import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResetPasswordPage extends StatefulWidget {
  ResetPasswordPage();

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController = TextEditingController();
  final TextEditingController _tokenController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> resetPassword() async {
    final String token = _tokenController.text;
    final String email = _emailController.text;
    final String password = _passwordController.text;
    final String passwordConfirmation = _passwordConfirmationController.text;

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/password/reset'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'token': token,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        }),
      );

      if (response.statusCode == 200) {
        // Mot de passe réinitialisé avec succès
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Succès'),
            content: Text('Mot de passe réinitialisé avec succès.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed('/login');
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        // Erreur lors de la réinitialisation du mot de passe
        final Map<String, dynamic> data = json.decode(response.body);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Erreur'),
            content: Text(data['message'] ?? 'Erreur lors de la réinitialisation du mot de passe.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (error) {
      // Erreur réseau
      print('Error: $error');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erreur'),
          content: Text('Erreur lors de la réinitialisation du mot de passe.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Réinitialiser le mot de passe')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Réinitialiser le mot de passe',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _tokenController,
              decoration: InputDecoration(labelText: 'Token'),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Nouveau mot de passe'),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _passwordConfirmationController,
              decoration: InputDecoration(labelText: 'Confirmer le mot de passe'),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: resetPassword,
              child: Text('Réinitialiser le mot de passe'),
            ),
          ],
        ),
      ),
    );
  }
}
