import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../features/attendance/data/models/attendance_model.dart';
import '../../features/bookings/data/models/booking_model.dart';
import '../../features/expenses/data/models/expense_model.dart';
import '../../features/vehicles/data/models/saved_vehicle_model.dart';
import '../../features/workers/data/models/worker_model.dart';
import '../repositories/hive_repository.dart';
import '../storage/hive_service.dart';

final bookingRepositoryProvider = Provider<HiveRepository<Booking>>(
  (ref) => HiveRepository(Hive.box(HiveBoxes.bookings)),
);

final vehicleRepositoryProvider = Provider<HiveRepository<SavedVehicle>>(
  (ref) => HiveRepository(Hive.box(HiveBoxes.vehicles)),
);

final workerRepositoryProvider = Provider<HiveRepository<Worker>>(
  (ref) => HiveRepository(Hive.box(HiveBoxes.workers)),
);

final attendanceRepositoryProvider = Provider<HiveRepository<Attendance>>(
  (ref) => HiveRepository(Hive.box(HiveBoxes.attendance)),
);

final expenseRepositoryProvider = Provider<HiveRepository<Expense>>(
  (ref) => HiveRepository(Hive.box(HiveBoxes.expenses)),
);
