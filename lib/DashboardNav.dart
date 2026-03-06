import 'package:Gatherly/adminDashboard.dart';
import 'package:Gatherly/adminScreen.dart';
import 'package:Gatherly/announcemet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminDashboard extends ConsumerWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Dashboard")),
      body: ListView(
        children: [
          ListTile(
            title: const Text("Members"),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) =>  MembersScreen()),
            ),
          ),
          ListTile(
            title: const Text("Announcements"),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) =>  AnnouncementsScreen()),
            ),
          ),
          ListTile(
            title: const Text("Events"),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => EventsScreen()),
            ),
          ),
        ],
      ),
    );
  }
}