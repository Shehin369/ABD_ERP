import 'package:hive/hive.dart';

import 'worker_model.dart';

class WorkerAdapter extends TypeAdapter<Worker> {
  static const adapterTypeId = 2;

  @override
  int get typeId => adapterTypeId;

  @override
  Worker read(BinaryReader reader) {
    final values = reader.read() as Map;
    return Worker(
      id: values['id'] as String,
      name: values['name'] as String,
      dob: values['dob'] as DateTime,
      address: values['address'] as String,
      dateOfJoining: values['dateOfJoining'] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Worker obj) {
    writer.write({
      'id': obj.id,
      'name': obj.name,
      'dob': obj.dob,
      'address': obj.address,
      'dateOfJoining': obj.dateOfJoining,
    });
  }
}
