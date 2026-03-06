import 'package:Gatherly/AddMembers.dart';
import 'package:Gatherly/member_provider.dart';
import 'package:Gatherly/member_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class MemberScreen extends ConsumerStatefulWidget {
  const MemberScreen({super.key});

  @override
  ConsumerState<MemberScreen> createState() => _MemberScreenState();
}

class _MemberScreenState extends ConsumerState<MemberScreen> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final membersAsync = ref.watch(membersProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        elevation: 0,
        title: membersAsync.when(
          data: (members) {
            final count = members.length;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Church Members",
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  '$count member${count != 1 ? 's' : ''}',
                  style: const TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ],
            );
          },
          loading: () => const Text(
            "Church Members",
            style: TextStyle(color: Colors.white),
          ),
          error: (_, __) => const Text(
            "Church Members",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: InkWell(
                hoverColor: const Color.fromARGB(255, 84, 39, 221),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.person_add),
                  label: const Text('Add Member'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>  AddMemberScreen(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // 🔎 Search Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                hintText: "Search members",
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: membersAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (members) {
                if (members.isEmpty) {
                  return Center(
                    child: InkWell(
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AddMemberScreen(),
                          ),
                        ),
                        child: Text(
                          'No members yet.\nTap "Add Member" to begin.',

                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                }

                final filteredMembers = members.where((member) {
                  return member.name.toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  );
                }).toList();

                if (filteredMembers.isEmpty) {
                  return const Center(
                    child: Text("No matching members found."),
                  );
                }

                return ListView.builder(
                  itemCount: filteredMembers.length,
                  itemBuilder: (context, index) {
                    final member = filteredMembers[index];
                    return MemberTile(
                      name: member.name,
                      phone: member.phone,
                      department: member.department,
                      docId: member.docId,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}