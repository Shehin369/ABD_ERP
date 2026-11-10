import 'package:hive_flutter/hive_flutter.dart';

import '../../features/attendance/data/models/attendance_model.dart';
import '../../features/attendance/data/models/attendance_type_adapter.dart';
import '../../features/bookings/data/models/booking_model.dart';
import '../../features/bookings/data/models/booking_type_adapter.dart';
import '../../features/expenses/data/models/expense_model.dart';
import '../../features/expenses/data/models/expense_type_adapter.dart';
import '../../features/vehicles/data/models/saved_vehicle_model.dart';
import '../../features/vehicles/data/models/saved_vehicle_type_adapter.dart';
import '../../features/workers/data/models/worker_model.dart';
import '../../features/workers/data/models/worker_type_adapter.dart';

class HiveBoxes {
  static const bookings = 'bookings';
  static const vehicles = 'vehicles';
  static const workers = 'workers';
  static const attendance = 'attendance';
  static const expenses = 'expenses';
}

class HiveService {
  static Future<void> initialize() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(BookingAdapter.adapterTypeId)) {
      Hive.registerAdapter(BookingAdapter());
    }
    if (!Hive.isAdapterRegistered(SavedVehicleAdapter.adapterTypeId)) {
      Hive.registerAdapter(SavedVehicleAdapter());
    }
    if (!Hive.isAdapterRegistered(WorkerAdapter.adapterTypeId)) {
      Hive.registerAdapter(WorkerAdapter());
    }
    if (!Hive.isAdapterRegistered(AttendanceAdapter.adapterTypeId)) {
      Hive.registerAdapter(AttendanceAdapter());
    }
    if (!Hive.isAdapterRegistered(ExpenseAdapter.adapterTypeId)) {
      Hive.registerAdapter(ExpenseAdapter());
    }

    await Future.wait([
      Hive.openBox<Booking>(HiveBoxes.bookings),
      Hive.openBox<SavedVehicle>(HiveBoxes.vehicles),
      Hive.openBox<Worker>(HiveBoxes.workers),
      Hive.openBox<Attendance>(HiveBoxes.attendance),
      Hive.openBox<Expense>(HiveBoxes.expenses),
    ]);
  }
}
