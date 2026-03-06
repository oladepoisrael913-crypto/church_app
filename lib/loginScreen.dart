import 'package:Gatherly/roleRouter.dart';

import 'package:Gatherly/SignUpScreen.dart';
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

    this.ref.read(loginLoadingProvider.notifier).state = true;

    try {
      print('Attempting login with email: $email');

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      print('Firebase login returned user: ${userCredential.user}');

      if (userCredential.user != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Login Successful!')));

        // Navigate to Member screen only if user is not null
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => RoleRouter()),
        );
      } else {
        print('Login failed: userCredential.user is null');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed. Try again.')),
        );
      }
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: ${e.code}');
      String errorMsg = 'Login failed. Please try again.';
      if (e.code == 'user-not-found') {
        errorMsg = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMsg = 'Incorrect password.';
      } else if (e.code == 'invalid-email') {
        errorMsg = 'Invalid email format.';
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMsg)));
    } catch (e) {
      print('Other exception: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred, try again.')),
      );
    } finally {
      this.ref.read(loginLoadingProvider.notifier).state = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // FlutterLogo( size: 20,),
                // Icon(
                //   Icons.person,
                //   size: 150,
                //   color: Theme.of(context).colorScheme.inversePrimary,
                // ),
                // const SizedBox(height: 20),
                Text(
                  "L O G I N",
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 40),
                MyTextfield(
                  obscuretext: false,
                  controller: emailController,
                  hintText: "Enter your email",
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {},
                ),
                const SizedBox(height: 20),
                MyTextfield(
                  obscuretext: this.ref.watch(obscurePasswordProvider),
                  controller: passwordController,
                  hintText: "Enter your password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      this.ref.watch(obscurePasswordProvider)
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      this.ref.read(obscurePasswordProvider.notifier).state =
                          !this.ref.read(obscurePasswordProvider);
                    },
                  ),
                  onChanged: (value) {},
                ),
                const SizedBox(height: 20),
                this.ref.watch(loginLoadingProvider)
                    ? const CircularProgressIndicator()
                    : MyButton(
                        text: "Login",
                        onTap: loginUser,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpPage(),
                          ),
                        );
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
