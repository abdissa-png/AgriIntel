import 'package:crop_recommendation/dataprovider/authprovider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'model/user_model.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool showPass = false;
  bool _isLoading = false;
  String _errorMessage = '';
  void _register() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      User newUser = User(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        email: emailController.text,
        username: usernameController.text,
        password: passwordController.text,
      );

      // registration logic
      Object response = await register(newUser);

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

  // void? _navigateToLogin(context) {
  //   // Navigator.pushNamed(context, '/login');
  //   context.go('/login');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_isLoading)
                Center(child: CircularProgressIndicator())
              else ...[
                _buildTextField('First Name', firstNameController),
                _buildTextField('Last Name', lastNameController),
                _buildTextField(
                    'Email', emailController, TextInputType.emailAddress),
                _buildTextField('Username', usernameController),
                _buildPasswordField('Password', passwordController, !showPass),
                const SizedBox(height: 20),
                _buildElevatedButton('Register', _register),
                const SizedBox(height: 10),
                // _buildElevatedButton('Go to Login', Colors.green, _navigateToLogin, context),
                ElevatedButton(
                  onPressed: () {
                    context.go("/login");
                  },
                  child: Text('Go to Login'),
                ),
                if (_errorMessage.isNotEmpty) Text(_errorMessage)
              ]
            ],
          ),
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
}
