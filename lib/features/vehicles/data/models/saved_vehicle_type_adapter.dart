import 'package:hive/hive.dart';

import '../../../bookings/data/models/booking_model.dart';
import 'saved_vehicle_model.dart';

class SavedVehicleAdapter extends TypeAdapter<SavedVehicle> {
  static const adapterTypeId = 1;

  @override
  int get typeId => adapterTypeId;

  @override
  SavedVehicle read(BinaryReader reader) {
    final values = reader.read() as Map;
    return SavedVehicle(
      id: values['id'] as String,
      vehicleName: values['vehicleName'] as String,
      vehicleNumber: values['vehicleNumber'] as String,
      customerName: values['customerName'] as String,
      customerNumber: values['customerNumber'] as String,
      category: VehicleCategory.values[values['category'] as int],
      type: values['type'] == null
          ? null
          : VehicleType.values[values['type'] as int],
      color: values['color'] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SavedVehicle obj) {
    writer.write({
      'id': obj.id,
      'vehicleName': obj.vehicleName,
      'vehicleNumber': obj.vehicleNumber,
      'customerName': obj.customerName,
      'customerNumber': obj.customerNumber,
      'category': obj.category.index,
      'type': obj.type?.index,
      'color': obj.color,
    });
  }
}
