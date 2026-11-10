class Worker {
  Worker({
    required this.id,
    required this.name,
    required this.dob,
    required this.address,
    required this.dateOfJoining,
  });

  final String id;
  final String name;
  final DateTime dob;
  final String address;
  final DateTime dateOfJoining;

  Worker copyWith({
    String? name,
    DateTime? dob,
    String? address,
    DateTime? dateOfJoining,
  }) {
    return Worker(
      id: id,
      name: name ?? this.name,
      dob: dob ?? this.dob,
      address: address ?? this.address,
      dateOfJoining: dateOfJoining ?? this.dateOfJoining,
    );
  }
}
