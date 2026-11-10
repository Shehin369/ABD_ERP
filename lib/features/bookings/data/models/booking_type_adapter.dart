import 'package:hive/hive.dart';

import 'booking_model.dart';

class BookingAdapter extends TypeAdapter<Booking> {
  static const adapterTypeId = 0;

  @override
  int get typeId => adapterTypeId;

  @override
  Booking read(BinaryReader reader) {
    final values = reader.read() as Map;
    return Booking(
      id: values['id'] as String,
      vehicleName: values['vehicleName'] as String?,
      vehicleNumber: values['vehicleNumber'] as String?,
      color: values['color'] as String,
      category: VehicleCategory.values[values['category'] as int],
      type: values['type'] == null
          ? null
          : VehicleType.values[values['type'] as int],
      checkInTime: values['checkInTime'] as DateTime?,
      checkOutTime: values['checkOutTime'] as DateTime?,
      durationInMins: values['durationInMins'] as int?,
      customerName: values['customerName'] as String?,
      customerNumber: values['customerNumber'] as String?,
      totalAmount: values['totalAmount'] as double?,
      paymentType: values['paymentType'] == null
          ? null
          : PaymentType.values[values['paymentType'] as int],
      addOns: (values['addOns'] as List)
          .cast<int>()
          .map(BookingAddOn.values.elementAt)
          .toList(),
      isRegularCustomer: values['isRegularCustomer'] as bool,
      status: BookingStatus.values[values['status'] as int],
    );
  }

  @override
  void write(BinaryWriter writer, Booking obj) {
    writer.write({
      'id': obj.id,
      'vehicleName': obj.vehicleName,
      'vehicleNumber': obj.vehicleNumber,
      'color': obj.color,
      'category': obj.category.index,
      'type': obj.type?.index,
      'checkInTime': obj.checkInTime,
      'checkOutTime': obj.checkOutTime,
      'durationInMins': obj.durationInMins,
      'customerName': obj.customerName,
      'customerNumber': obj.customerNumber,
      'totalAmount': obj.totalAmount,
      'paymentType': obj.paymentType?.index,
      'addOns': obj.addOns.map((item) => item.index).toList(),
      'isRegularCustomer': obj.isRegularCustomer,
      'status': obj.status.index,
    });
  }
}
