import 'package:hive/hive.dart';

import 'attendance_model.dart';

class AttendanceAdapter extends TypeAdapter<Attendance> {
  static const adapterTypeId = 3;

  @override
  int get typeId => adapterTypeId;

  @override
  Attendance read(BinaryReader reader) {
    final values = reader.read() as Map;
    return Attendance(
      id: values['id'] as String,
      workerId: values['workerId'] as String,
      date: values['date'] as DateTime,
      checkInTime: values['checkInTime'] as DateTime?,
      checkOutTime: values['checkOutTime'] as DateTime?,
      isOnLeave: values['isOnLeave'] as bool,
      comment: values['comment'] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Attendance obj) {
    writer.write({
      'id': obj.id,
      'workerId': obj.workerId,
      'date': obj.date,
      'checkInTime': obj.checkInTime,
      'checkOutTime': obj.checkOutTime,
      'isOnLeave': obj.isOnLeave,
      'comment': obj.comment,
    });
  }
}
