class Attendance {
  Attendance({
    required this.id,
    required this.workerId,
    required this.date,
    this.checkInTime,
    this.checkOutTime,
    this.isOnLeave = false,
    this.comment,
  });

  final String id;
  final String workerId;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final bool isOnLeave;
  final String? comment;
  final DateTime date;
}
