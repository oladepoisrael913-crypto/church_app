import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Gatherly/loginScreen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(child: ChurchApp()));
  
       
}
class ChurchApp extends ConsumerWidget {
  const ChurchApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) { 
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      title: 'Church App',
      theme: ThemeData(
        
      ),
      home: LoginPage(),
      
    );
  }
}