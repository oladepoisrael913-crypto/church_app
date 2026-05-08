import 'package:Gatherly/member_provider.dart';
import 'package:Gatherly/sessionModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AttendanceRecord {
  final String memberId;
  final String memberName;
  final bool present;

  AttendanceRecord({
    required this.memberId,
    required this.memberName,
    required this.present,
  });

  factory AttendanceRecord.fromMap(String id, Map<String, dynamic> data) {
    return AttendanceRecord(
      memberId: id,
      memberName: data['memberName'] ?? '',
      present: data['present'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'memberName': memberName,
      'present': present,
    };
  }
}
final sessionsProvider = StreamProvider<List<Session>>((ref) {
  final firestore = ref.watch(firestoreProvider);

  return firestore
      .collection('sessions')
      .orderBy('date', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => Session.fromMap(doc.id, doc.data()))
          .toList());
});

/// Attendance stream provider for a specific session
final attendanceProvider =
    StreamProvider.family<List<AttendanceRecord>, String>((ref, sessionId) {
  final firestore = ref.watch(firestoreProvider);

  return firestore
      .collection('sessions')
      .doc(sessionId)
      .collection('attendance')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => AttendanceRecord.fromMap(doc.id, doc.data()))
          .toList());
});