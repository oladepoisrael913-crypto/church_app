import 'package:Gatherly/MemberScreen.dart';
import 'package:Gatherly/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignOutScreen extends ConsumerStatefulWidget {
  const SignOutScreen({super.key});

  @override
  ConsumerState<SignOutScreen> createState() => _SignOutScreenState();
}

class _SignOutScreenState extends ConsumerState<SignOutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Out')),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Column(
        children: [
          const Spacer(),
          MyButton(
            text: 'Sign Out',
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              if (!mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Signed out successfully')),
              );

              // Clears all screens and goes back to MemberScreen
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const MemberScreen()),
                (route) => false,
              );
            },
          ),
          const Spacer(),
        ],
      ),
    );
  }
}