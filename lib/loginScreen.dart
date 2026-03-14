import 'package:Gatherly/roleRouter.dart';
import 'package:Gatherly/textfield.dart';
import 'package:Gatherly/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginLoadingProvider = StateProvider<bool>((ref) => false);
final obscurePasswordProvider = StateProvider<bool>((ref) => true);

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> loginUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    ref.read(loginLoadingProvider.notifier).state = true;

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login Successful!')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const RoleRouter()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMsg = 'Login failed. Please try again.';
      if (e.code == 'user-not-found') {
        errorMsg = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMsg = 'Incorrect password.';
      } else if (e.code == 'invalid-email') {
        errorMsg = 'Invalid email format.';
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred, try again.')),
      );
    } finally {
      ref.read(loginLoadingProvider.notifier).state = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text(
          "Admin Login",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "L O G I N",
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 40),

                // Email field
                MyTextfield(
                  obscuretext: false,
                  controller: emailController,
                  hintText: "Enter your email",
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {},
                ),
                const SizedBox(height: 20),

                // Password field
                MyTextfield(
                  obscuretext: ref.watch(obscurePasswordProvider),
                  controller: passwordController,
                  hintText: "Enter your password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      ref.watch(obscurePasswordProvider)
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      ref.read(obscurePasswordProvider.notifier).state =
                          !ref.read(obscurePasswordProvider);
                    },
                  ),
                  onChanged: (value) {},
                ),
                const SizedBox(height: 20),

                // Login button or loading spinner
                ref.watch(loginLoadingProvider)
                    ? const CircularProgressIndicator()
                    : MyButton(
                        text: "Login",
                        onTap: loginUser,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}