import 'package:Gatherly/announcementModel.dart';
import 'package:Gatherly/eventModel.dart';
import 'package:Gatherly/members.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';



/// Firestore instance provider
final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

/// Search query state provider
final searchProvider = StateProvider<String>((ref) => '');

/// User role provider
final userRoleProvider = FutureProvider<String>((ref) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    throw Exception("User not logged in");
  }

  final doc = await ref.watch(firestoreProvider)
      .collection('users')
      .doc(user.uid)
      .get();

  return doc.data()?['role'] ?? 'member';
});

/// Members list stream provider
final membersProvider = StreamProvider<List<Member>>((ref) {
  final firestore = ref.watch(firestoreProvider);

  return firestore.collection('members').snapshots().map((snapshot) {
    return snapshot.docs.map((doc) => Member.fromMap(doc.id, doc.data())).toList();
  });
});
// announcements provider
final eventsProvider = StreamProvider<List<Event>>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return firestore
      .collection('events')
      .orderBy('date')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => Event.fromMap(doc.id, doc.data()))
          .toList());
});
final announcementsProvider = StreamProvider<List<Announcement>>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return firestore
      .collection('announcements')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => Announcement.fromMap(doc.id, doc.data()))
          .toList());
});