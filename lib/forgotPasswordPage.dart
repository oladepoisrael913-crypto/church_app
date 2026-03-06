import 'package:Gatherly/button.dart';
import 'package:Gatherly/textfield.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> resetPassword() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter your email')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset email sent!')),
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String msg = 'Error sending reset email';
      if (e.code == 'user-not-found') msg = 'No user found with that email';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            MyTextfield(
              controller: emailController,
              hintText: 'Enter your email',
              obscuretext: false,
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {},
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : MyButton(
                    text: 'Send Reset Email',
                    onTap: resetPassword,
                    style: const TextStyle(color: Colors.white),
                  ),
          ],
        ),
      ),
    );
  }
}
