import 'package:Gatherly/attendanceModel.dart';
import 'package:Gatherly/member_provider.dart';
import 'package:Gatherly/sessionModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MarkAttendanceScreen extends ConsumerWidget {
  final Session session;

  const MarkAttendanceScreen({super.key, required this.session});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membersAsync = ref.watch(membersProvider);
    final attendanceAsync = ref.watch(attendanceProvider(session.docId));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        elevation: 0,
        title: Column(
          children: [
            Text(
              session.name,
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              '${session.date.day}/${session.date.month}/${session.date.year}',
              style: const TextStyle(fontSize: 13, color: Colors.white70),
            ),
          ],
        ),
      ),
      body: membersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (members) {
          if (members.isEmpty) {
            return const Center(
              child: Text('No members found. Add members first.'),
            );
          }

          return attendanceAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (attendanceRecords) {
              final attendanceMap = {
                for (var record in attendanceRecords)
                  record.memberId: record.present
              };

              final presentCount =
                  attendanceMap.values.where((v) => v).length;

              return Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withOpacity(0.08),
                    child: Text(
                      '$presentCount / ${members.length} present',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      itemCount: members.length,
                      itemBuilder: (context, index) {
                        final member = members[index];
                        final isPresent =
                            attendanceMap[member.docId] ?? false;

                        return _AttendanceTile(
                          memberName: member.name,
                          memberId: member.docId,
                          department: member.department,
                          isPresent: isPresent,
                          sessionId: session.docId,
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _AttendanceTile extends StatelessWidget {
  final String memberName;
  final String memberId;
  final String department;
  final bool isPresent;
  final String sessionId;

  const _AttendanceTile({
    required this.memberName,
    required this.memberId,
    required this.department,
    required this.isPresent,
    required this.sessionId,
  });

  Future<void> _toggleAttendance() async {
    await FirebaseFirestore.instance
        .collection('sessions')
        .doc(sessionId)
        .collection('attendance')
        .doc(memberId)
        .set({
      'memberName': memberName,
      'present': !isPresent,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: CircleAvatar(
          backgroundColor: isPresent ? Colors.green : Colors.grey.shade300,
          child: Text(
            memberName[0].toUpperCase(),
            style: TextStyle(
              color: isPresent ? Colors.white : Colors.grey.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          memberName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          department,
          style: const TextStyle(fontSize: 13),
        ),
        trailing: GestureDetector(
          onTap: _toggleAttendance,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: isPresent ? Colors.green : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isPresent ? 'Present' : 'Absent',
              style: TextStyle(
                color: isPresent ? Colors.white : Colors.grey.shade700,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }
}