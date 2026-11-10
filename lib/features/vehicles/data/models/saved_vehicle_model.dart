import '../../../bookings/data/models/booking_model.dart';

class SavedVehicle {
  SavedVehicle({
    required this.id,
    required this.vehicleName,
    required this.vehicleNumber,
    required this.customerName,
    required this.customerNumber,
    required this.category,
    required this.color,
    this.type,
  });

  final String id;
  final String vehicleName;
  final String vehicleNumber;
  final String customerName;
  final String customerNumber;
  final VehicleCategory category;
  final VehicleType? type;
  final String color;
}
