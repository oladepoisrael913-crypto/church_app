
class Member {
  final String docId;
  final String name;
  final String phone;
  final String department;
  final String role;
  // final DateTime? birthday;

  Member({
    required this.docId,
    required this.name,
    required this.phone,
    required this.department,
    required this.role,
    // this.birthday,
  });

  factory Member.fromMap(String id, Map<String, dynamic> data) {
    return Member(
      docId: id,
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      department: data['department'] ?? '',
      role: data['role'] ?? 'member',
      // birthday: data['birthday'] != null
      //     ? (data['birthday'] as Timestamp).toDate()
      //     : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'department': department,
      'role': role,
      // 'birthday': birthday != null ? Timestamp.fromDate(birthday!) : null,
    };
  }
}