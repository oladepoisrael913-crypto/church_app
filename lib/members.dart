class Member {
  final String docId;
  final String name;
  final String phone;
  final String department;
  final String role;

  Member({
    required this.docId,
    required this.name,
    required this.phone,
    required this.department,
    required this.role,
  });

  factory Member.fromMap(String id, Map<String, dynamic> data) {
    return Member(
      docId: id,
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      department: data['department'] ?? '',
      role: data['role'] ?? 'member',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'department': department,
      'role': role,
    };
  }
}