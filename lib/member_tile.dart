import 'package:Gatherly/AddMembers.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class MemberTile extends ConsumerWidget {
  final String docId; // Firestore document ID
  final String name;
  final String phone;
  final String department;
  final String? role;

  const MemberTile({
    super.key,
    required this.docId,
    required this.name,
    required this.phone,
    required this.department,
    this.role,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: ValueKey(docId),
      direction: DismissDirection.endToStart,
      background: Container(
        color:Theme.of(context).colorScheme.primary,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) async {
        await FirebaseFirestore.instance
            .collection("members")
            .doc(docId)
            .delete();
      },

      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: ListTile(
            
            leading: const Icon(Icons.person),
            
            trailing: IconButton(
              onPressed: () async {
                final Uri phoneUri = Uri(scheme: 'tel', path: phone);
                if (await canLaunchUrl(phoneUri)) {
                  await launchUrl(phoneUri);
                }
              },
              icon: Icon(Icons.phone),
              
            ),
        
            // Long press to delete
            onLongPress: () async {
              final firestore = FirebaseFirestore.instance;
              await firestore.collection('members').doc(docId).delete();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('$name deleted')));
            },
        
            title: Text(name),
            subtitle: Text('$phone - $department - $role'),
        
            // Tap to edit
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddMemberScreen(
                  name: name,
                  role: role,
                  phone: phone,
                  department: department,
                  docId: docId, 
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
