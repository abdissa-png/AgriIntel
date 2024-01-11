import 'package:crop_recommendation/dataprovider/authprovider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'model/login_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool showPass = false;
  bool _isLoading = false;
  String _errorMessage = '';
  void _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      Login newLog = Login(
        email: emailController.text,
        password: passwordController.text,
      );

      // registration logic
      Object response = await login(newLog);

      // If the registration is successful, navigate to the landing page
      context.go('/home');
    } catch (e) {
      // If the registration fails, update the error message
      setState(() {
        _errorMessage = 'Failed to register. Please try again.';
        _isLoading = false;
      });
    }
  }

  // void _navigateToRegistration() {
  //   Navigator.pushNamed(context, '/registration');
  //   cotext.go
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_isLoading)
              Center(child: CircularProgressIndicator())
            else ...[
              _buildTextField(
                  'Email', emailController, TextInputType.emailAddress),
              _buildPasswordField('Password', passwordController, showPass),
              const SizedBox(height: 20),
              _buildElevatedButton('Login', _login),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  context.go('/');
                },
                child: Text('Go to Registration'),
              ),
              if (_errorMessage.isNotEmpty) Text(_errorMessage)
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String labelText, TextEditingController controller,
      [TextInputType inputType = TextInputType.text]) {
    return Column(
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            border: OutlineInputBorder(),
          ),
          keyboardType: inputType,
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildPasswordField(
      String labelText, TextEditingController controller, bool obscureText) {
    return Column(
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            border: OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(showPass ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  showPass = !showPass;
                });
              },
            ),
          ),
          obscureText: obscureText,
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildElevatedButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }

  Widget _buildTextButton(String label, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
