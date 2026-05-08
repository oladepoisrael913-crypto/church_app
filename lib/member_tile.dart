import 'package:Gatherly/AddMembers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class MemberTile extends ConsumerWidget {
  final String docId;
  final String name;
  final String phone;
  final String department;
  final String? role;
  final DateTime? birthday; 

  const MemberTile({
    super.key,
    required this.docId,
    required this.name,
    required this.phone,
    required this.department,
    this.role,
    this.birthday,
  });

  bool isBirthdayToday(DateTime birthday) {
    final today = DateTime.now();
    return birthday.day == today.day && birthday.month == today.month;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: ValueKey(docId),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).colorScheme.primary,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
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
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (birthday != null && isBirthdayToday(birthday!))
                  const Icon(Icons.cake, color: Colors.pink),
                IconButton(
                  onPressed: () async {
                    final Uri phoneUri = Uri(scheme: 'tel', path: phone);
                    if (await canLaunchUrl(phoneUri)) {
                      await launchUrl(phoneUri);
                    }
                  },
                  icon: const Icon(Icons.phone),
                ),
              ],
            ),
            onLongPress: () async {
              await FirebaseFirestore.instance
                  .collection('members')
                  .doc(docId)
                  .delete();
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$name deleted')));
            },
            title: Text(name),
            subtitle: Text('$phone - $department - $role'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddMemberScreen(
                  name: name,
                  role: role,
                  phone: phone,
                  department: department,
                  // birthday: birthday,
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