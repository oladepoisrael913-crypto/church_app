import 'package:Gatherly/member_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddMemberScreen extends ConsumerStatefulWidget {
  final String? name;
  final String? phone;
  final String? department;
  final String? docId;
  final String? role;

  const AddMemberScreen({
    super.key,
    this.name,
    this.phone,
    this.department,
    this.docId,
    this.role,
  });

  @override
  ConsumerState<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends ConsumerState<AddMemberScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _departmentController;
  late TextEditingController _roleController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name ?? '');
    _phoneController = TextEditingController(text: widget.phone ?? '');
    _departmentController = TextEditingController(
      text: widget.department ?? '',
    );
    _roleController = TextEditingController(text: widget.role ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _departmentController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  Future<void> _saveMember() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final role = _roleController.text.trim();
    final department = _departmentController.text.trim();

    if (name.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    try {
      final firestore = ref.read(firestoreProvider);
      final collection = firestore.collection('members');

      if (widget.docId != null) {
        // update it
        await collection.doc(widget.docId).update({
          'name': name,
          'phone': phone,
          'role': role,
          'department': department,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else {
        //  New member — create a new document
        await collection.add({
          'name': name,
          'phone': phone,
          'role': role,
          'department': department,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      // After successful save
Navigator.pop(context); 
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saving member: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    // final isEditing = widget.docId != null;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          // Navigation.push(context, MaterialPageRoute(builder: (_) => const MemberScreen())),
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.docId != null ? 'Edit Member' : 'Add Member',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _departmentController,
                decoration: const InputDecoration(labelText: 'Department'),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _roleController,
                decoration: const InputDecoration(labelText: 'Role'),
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveMember,

                  child: Text(
                    widget.docId != null ? 'Update Member' : 'Add Member',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
