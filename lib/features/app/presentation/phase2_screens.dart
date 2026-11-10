import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../core/providers/repositories.dart';
import '../../../core/services/wallet_service.dart';
import '../../../core/storage/hive_service.dart';
import '../../attendance/data/models/attendance_model.dart';
import '../../bookings/data/models/booking_model.dart';
import '../../expenses/data/models/expense_model.dart';
import '../../vehicles/data/models/saved_vehicle_model.dart';
import '../../workers/data/models/worker_model.dart';

enum AppSection { dashboard, bookings, vehicles, workers, attendance, expenses }

class Phase2Home extends StatefulWidget {
  const Phase2Home({super.key});

  @override
  State<Phase2Home> createState() => _Phase2HomeState();
}

class _Phase2HomeState extends State<Phase2Home> {
  AppSection section = AppSection.dashboard;

  static const destinations = [
    NavigationDestination(
      icon: Icon(Icons.dashboard_outlined),
      selectedIcon: Icon(Icons.dashboard),
      label: 'Dashboard',
    ),
    NavigationDestination(
      icon: Icon(Icons.local_car_wash_outlined),
      selectedIcon: Icon(Icons.local_car_wash),
      label: 'Bookings',
    ),
    NavigationDestination(
      icon: Icon(Icons.directions_car_outlined),
      selectedIcon: Icon(Icons.directions_car),
      label: 'Vehicles',
    ),
    NavigationDestination(
      icon: Icon(Icons.badge_outlined),
      selectedIcon: Icon(Icons.badge),
      label: 'Workers',
    ),
    NavigationDestination(
      icon: Icon(Icons.fact_check_outlined),
      selectedIcon: Icon(Icons.fact_check),
      label: 'Attendance',
    ),
    NavigationDestination(
      icon: Icon(Icons.receipt_long_outlined),
      selectedIcon: Icon(Icons.receipt_long),
      label: 'Expenses',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final pages = [
      const DashboardPage(),
      const BookingsPage(),
      const VehiclesPage(),
      const WorkersPage(),
      const AttendancePage(),
      const ExpensesPage(),
    ];
    final wide = MediaQuery.sizeOf(context).width >= 900;
    return Scaffold(
      appBar: wide
          ? null
          : AppBar(
              title: Text(destinations[section.index].label),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primaryContainer,
                    child: Icon(
                      Icons.person_outline_rounded,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
      body: Row(
        children: [
          if (wide)
            Container(
              width: 232,
              margin: const EdgeInsets.fromLTRB(12, 12, 0, 12),
              decoration: BoxDecoration(
                color: const Color(0xFF172033),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF172033).withValues(alpha: 0.16),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF818CF8), Color(0xFF14B8A6)],
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.local_car_wash_rounded,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Car Wash',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: NavigationRail(
                      selectedIndex: section.index,
                      onDestinationSelected: (index) =>
                          setState(() => section = AppSection.values[index]),
                      labelType: NavigationRailLabelType.all,
                      minWidth: 232,
                      backgroundColor: Colors.transparent,
                      indicatorColor: Colors.white.withValues(alpha: 0.10),
                      selectedIconTheme: const IconThemeData(
                        color: Color(0xFF8B95FF),
                      ),
                      unselectedIconTheme: const IconThemeData(
                        color: Color(0xFFABB3C4),
                      ),
                      selectedLabelTextStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                      unselectedLabelTextStyle: const TextStyle(
                        color: Color(0xFFABB3C4),
                        fontWeight: FontWeight.w500,
                      ),
                      destinations: destinations
                          .map(
                            (item) => NavigationRailDestination(
                              icon: item.icon,
                              selectedIcon: item.selectedIcon,
                              label: Text(item.label),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: IndexedStack(index: section.index, children: pages),
          ),
        ],
      ),
      bottomNavigationBar: wide
          ? null
          : NavigationBar(
              selectedIndex: section.index,
              onDestinationSelected: (index) =>
                  setState(() => section = AppSection.values[index]),
              destinations: destinations,
            ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<Booking>>(
      valueListenable: Hive.box<Booking>(HiveBoxes.bookings).listenable(),
      builder: (_, bookingsBox, _) => ValueListenableBuilder<Box<Expense>>(
        valueListenable: Hive.box<Expense>(HiveBoxes.expenses).listenable(),
        builder: (_, expensesBox, _) {
          final summary = const WalletService().calculate(
            bookingsBox.values,
            expensesBox.values,
          );
          final activeBookings = bookingsBox.values
              .where((booking) => booking.status == BookingStatus.inProgress)
              .length;
          return ListView(
            padding: EdgeInsets.fromLTRB(
              16,
              20,
              16,
              MediaQuery.paddingOf(context).bottom + 24,
            ),
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Good morning',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Your business is looking sharp.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 21,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.4,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '$activeBookings vehicles currently in service',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(
                        Icons.auto_graph_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Financial overview',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _WalletCard(
                    'Cash box',
                    summary.cashBalance,
                    Icons.payments_outlined,
                    Colors.green,
                  ),
                  _WalletCard(
                    'Bank account',
                    summary.bankBalance,
                    Icons.account_balance_outlined,
                    Colors.blue,
                  ),
                  _WalletCard(
                    'Total income',
                    summary.totalIncome,
                    Icons.trending_up,
                    Colors.purple,
                  ),
                  _WalletCard(
                    'Total expenses',
                    summary.totalExpenses,
                    Icons.trending_down,
                    Colors.orange,
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _WalletCard extends StatelessWidget {
  const _WalletCard(this.title, this.amount, this.icon, this.color);
  final String title;
  final double amount;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE9EDF5)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(height: 12),
              Text(title, style: Theme.of(context).textTheme.labelLarge),
              Text(
                NumberFormat.currency(symbol: '').format(amount),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BookingsPage extends ConsumerWidget {
  const BookingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final box = Hive.box<Booking>(HiveBoxes.bookings);
    return ValueListenableBuilder<Box<Booking>>(
      valueListenable: box.listenable(),
      builder: (_, bookings, _) => Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => showDialog(
            context: context,
            builder: (_) => const BookingCheckInDialog(),
          ),
          child: const Icon(Icons.add),
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: bookings.length,
          itemBuilder: (_, index) {
            final booking = bookings.getAt(index)!;
            return Card(
              child: ListTile(
                title: Text(
                  booking.vehicleNumber?.isNotEmpty == true
                      ? booking.vehicleNumber!
                      : booking.vehicleName ?? 'Vehicle',
                ),
                subtitle: Text(
                  '${booking.category.name} - ${booking.status.name}\nChecked in ${DateFormat('dd MMM, hh:mm a').format(booking.checkInTime)}',
                ),
                isThreeLine: true,
                trailing: booking.status == BookingStatus.inProgress
                    ? FilledButton(
                        onPressed: () => showDialog(
                          context: context,
                          builder: (_) =>
                              BookingCheckOutDialog(booking: booking),
                        ),
                        child: const Text('Check out'),
                      )
                    : null,
              ),
            );
          },
        ),
      ),
    );
  }
}

class BookingCheckInDialog extends ConsumerStatefulWidget {
  const BookingCheckInDialog({super.key});
  @override
  ConsumerState<BookingCheckInDialog> createState() =>
      _BookingCheckInDialogState();
}

class _BookingCheckInDialogState extends ConsumerState<BookingCheckInDialog> {
  final formKey = GlobalKey<FormState>();
  VehicleCategory category = VehicleCategory.car;
  VehicleType? type = VehicleType.hatchback;
  final vehicleNumber = TextEditingController();
  final color = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Vehicle check-in'),
      content: SizedBox(
        width: 420,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<VehicleCategory>(
                initialValue: category,
                decoration: const InputDecoration(labelText: 'Category'),
                items: VehicleCategory.values
                    .map((v) => DropdownMenuItem(value: v, child: Text(v.name)))
                    .toList(),
                onChanged: (value) => setState(() {
                  category = value!;
                  if (category != VehicleCategory.car) type = null;
                }),
              ),
              if (category == VehicleCategory.car)
                DropdownButtonFormField<VehicleType>(
                  initialValue: type,
                  decoration: const InputDecoration(labelText: 'Vehicle type'),
                  items: VehicleType.values
                      .map(
                        (v) => DropdownMenuItem(value: v, child: Text(v.name)),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => type = value),
                ),
              TextFormField(
                controller: vehicleNumber,
                decoration: const InputDecoration(labelText: 'Vehicle number'),
              ),
              TextFormField(
                controller: color,
                decoration: const InputDecoration(labelText: 'Color'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () async {
            if (!formKey.currentState!.validate() ||
                (category == VehicleCategory.car && type == null)) {
              return;
            }
            final booking = Booking(
              id: const Uuid().v4(),
              color: color.text.trim(),
              category: category,
              type: category == VehicleCategory.car ? type : null,
              vehicleNumber: vehicleNumber.text.trim(),
            );
            await ref.read(bookingRepositoryProvider).put(booking.id, booking);
            if (context.mounted) Navigator.pop(context);
          },
          child: const Text('Check in'),
        ),
      ],
    );
  }
}

class BookingCheckOutDialog extends ConsumerStatefulWidget {
  const BookingCheckOutDialog({super.key, required this.booking});
  final Booking booking;
  @override
  ConsumerState<BookingCheckOutDialog> createState() =>
      _BookingCheckOutDialogState();
}

class _BookingCheckOutDialogState extends ConsumerState<BookingCheckOutDialog> {
  final formKey = GlobalKey<FormState>();
  final customerName = TextEditingController();
  final customerNumber = TextEditingController();
  final amount = TextEditingController();
  PaymentType payment = PaymentType.cash;
  final selectedAddOns = <BookingAddOn>{};
  bool saveVehicle = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Complete booking'),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 420,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: customerName,
                  decoration: const InputDecoration(labelText: 'Customer name'),
                ),
                TextFormField(
                  controller: customerNumber,
                  decoration: const InputDecoration(
                    labelText: 'Customer number',
                  ),
                  keyboardType: TextInputType.phone,
                ),
                TextFormField(
                  controller: amount,
                  decoration: const InputDecoration(labelText: 'Total amount'),
                  keyboardType: TextInputType.number,
                  validator: (v) => double.tryParse(v ?? '') == null
                      ? 'Enter an amount'
                      : null,
                ),
                DropdownButtonFormField<PaymentType>(
                  initialValue: payment,
                  decoration: const InputDecoration(labelText: 'Payment type'),
                  items: PaymentType.values
                      .map(
                        (v) => DropdownMenuItem(value: v, child: Text(v.name)),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => payment = v!),
                ),
                const SizedBox(height: 8),
                Wrap(
                  children: BookingAddOn.values
                      .map(
                        (addon) => FilterChip(
                          label: Text(addon.name),
                          selected: selectedAddOns.contains(addon),
                          onSelected: (selected) => setState(() {
                            if (selected) {
                              selectedAddOns.add(addon);
                            } else {
                              selectedAddOns.remove(addon);
                            }
                          }),
                        ),
                      )
                      .toList(),
                ),
                CheckboxListTile(
                  value: saveVehicle,
                  title: const Text('Save regular customer'),
                  onChanged: (v) => setState(() => saveVehicle = v!),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () async {
            if (!formKey.currentState!.validate()) return;
            final now = DateTime.now();
            final completed = widget.booking.copyWith(
              checkOutTime: now,
              durationInMins: now
                  .difference(widget.booking.checkInTime)
                  .inMinutes,
              customerName: customerName.text.trim(),
              customerNumber: customerNumber.text.trim(),
              totalAmount: double.parse(amount.text),
              paymentType: payment,
              addOns: selectedAddOns.toList(),
              isRegularCustomer: saveVehicle,
              status: BookingStatus.completed,
            );
            await ref
                .read(bookingRepositoryProvider)
                .put(completed.id, completed);
            if (saveVehicle) {
              final vehicle = SavedVehicle(
                id: const Uuid().v4(),
                vehicleName: widget.booking.vehicleName ?? '',
                vehicleNumber: widget.booking.vehicleNumber ?? '',
                customerName: customerName.text.trim(),
                customerNumber: customerNumber.text.trim(),
                category: widget.booking.category,
                type: widget.booking.type,
                color: widget.booking.color,
              );
              await ref
                  .read(vehicleRepositoryProvider)
                  .put(vehicle.id, vehicle);
            }
            if (context.mounted) Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class VehiclesPage extends ConsumerStatefulWidget {
  const VehiclesPage({super.key});
  @override
  ConsumerState<VehiclesPage> createState() => _VehiclesPageState();
}

class _VehiclesPageState extends ConsumerState<VehiclesPage> {
  String query = '';
  @override
  Widget build(BuildContext context) {
    final box = Hive.box<SavedVehicle>(HiveBoxes.vehicles);
    return ValueListenableBuilder<Box<SavedVehicle>>(
      valueListenable: box.listenable(),
      builder: (_, vehicles, _) {
        final filtered = vehicles.values
            .where(
              (v) => '${v.vehicleNumber} ${v.customerName}'
                  .toLowerCase()
                  .contains(query.toLowerCase()),
            )
            .toList();
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  labelText: 'Search vehicle or customer',
                ),
                onChanged: (v) => setState(() => query = v),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filtered.length,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (_, index) {
                  final vehicle = filtered[index];
                  return Card(
                    child: ListTile(
                      title: Text(
                        vehicle.vehicleNumber.isEmpty
                            ? vehicle.vehicleName
                            : vehicle.vehicleNumber,
                      ),
                      subtitle: Text(
                        '${vehicle.customerName} - ${vehicle.customerNumber}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        tooltip: 'Create booking',
                        onPressed: () => showDialog(
                          context: context,
                          builder: (_) =>
                              BookingFromVehicleDialog(vehicle: vehicle),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class BookingFromVehicleDialog extends ConsumerWidget {
  const BookingFromVehicleDialog({super.key, required this.vehicle});
  final SavedVehicle vehicle;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('Create booking'),
      content: Text(
        'Start a new booking for ${vehicle.vehicleNumber.isEmpty ? vehicle.vehicleName : vehicle.vehicleNumber}?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () async {
            final booking = Booking(
              id: const Uuid().v4(),
              vehicleName: vehicle.vehicleName,
              vehicleNumber: vehicle.vehicleNumber,
              color: vehicle.color,
              category: vehicle.category,
              type: vehicle.type,
            );
            await ref.read(bookingRepositoryProvider).put(booking.id, booking);
            if (context.mounted) Navigator.pop(context);
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}

class WorkersPage extends ConsumerWidget {
  const WorkersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final box = Hive.box<Worker>(HiveBoxes.workers);
    return ValueListenableBuilder<Box<Worker>>(
      valueListenable: box.listenable(),
      builder: (_, workers, _) => Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => showDialog(
            context: context,
            builder: (_) => const WorkerDialog(),
          ),
          child: const Icon(Icons.person_add),
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: workers.length,
          itemBuilder: (_, index) {
            final worker = workers.getAt(index)!;
            return Card(
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person_outline)),
                title: Text(worker.name),
                subtitle: Text(
                  '${worker.address}\nJoined ${DateFormat('dd MMM yyyy').format(worker.dateOfJoining)}',
                ),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () => showDialog(
                        context: context,
                        builder: (_) => WorkerDialog(worker: worker),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () async =>
                          ref.read(workerRepositoryProvider).delete(worker.id),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class WorkerDialog extends ConsumerStatefulWidget {
  const WorkerDialog({super.key, this.worker});
  final Worker? worker;
  @override
  ConsumerState<WorkerDialog> createState() => _WorkerDialogState();
}

class _WorkerDialogState extends ConsumerState<WorkerDialog> {
  final formKey = GlobalKey<FormState>();
  late final name = TextEditingController(text: widget.worker?.name);
  late final address = TextEditingController(text: widget.worker?.address);
  DateTime dob = DateTime.now().subtract(const Duration(days: 365 * 20));
  DateTime joined = DateTime.now();

  @override
  void initState() {
    super.initState();
    dob = widget.worker?.dob ?? dob;
    joined = widget.worker?.dateOfJoining ?? joined;
  }

  Future<void> pickDate(bool birthDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: birthDate ? dob : joined,
      firstDate: DateTime(1950),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => birthDate ? dob = picked : joined = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.worker == null ? 'Register worker' : 'Edit worker'),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 420,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: name,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  controller: address,
                  decoration: const InputDecoration(labelText: 'Address'),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Required' : null,
                ),
                ListTile(
                  title: const Text('Date of birth'),
                  subtitle: Text(DateFormat('dd MMM yyyy').format(dob)),
                  trailing: const Icon(Icons.calendar_month),
                  onTap: () => pickDate(true),
                ),
                ListTile(
                  title: const Text('Date of joining'),
                  subtitle: Text(DateFormat('dd MMM yyyy').format(joined)),
                  trailing: const Icon(Icons.calendar_month),
                  onTap: () => pickDate(false),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () async {
            if (!formKey.currentState!.validate()) return;
            final worker =
                widget.worker?.copyWith(
                  name: name.text.trim(),
                  dob: dob,
                  address: address.text.trim(),
                  dateOfJoining: joined,
                ) ??
                Worker(
                  id: const Uuid().v4(),
                  name: name.text.trim(),
                  dob: dob,
                  address: address.text.trim(),
                  dateOfJoining: joined,
                );
            await ref.read(workerRepositoryProvider).put(worker.id, worker);
            if (context.mounted) Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class AttendancePage extends ConsumerStatefulWidget {
  const AttendancePage({super.key});
  @override
  ConsumerState<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends ConsumerState<AttendancePage> {
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final workersBox = Hive.box<Worker>(HiveBoxes.workers);
    final attendanceBox = Hive.box<Attendance>(HiveBoxes.attendance);
    return ValueListenableBuilder<Box<Worker>>(
      valueListenable: workersBox.listenable(),
      builder: (_, workers, _) => ValueListenableBuilder<Box<Attendance>>(
        valueListenable: attendanceBox.listenable(),
        builder: (_, attendance, _) => Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(DateFormat('dd MMM yyyy').format(date)),
            actions: [
              IconButton(
                icon: const Icon(Icons.calendar_month),
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: date,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) setState(() => date = picked);
                },
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: workers.isEmpty
                ? null
                : () => showDialog(
                    context: context,
                    builder: (_) => AttendanceDialog(date: date),
                  ),
            child: const Icon(Icons.add),
          ),
          body: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: attendance.values
                .where((a) => _sameDay(a.date, date))
                .length,
            itemBuilder: (_, index) {
              final records = attendance.values
                  .where((a) => _sameDay(a.date, date))
                  .toList();
              final record = records[index];
              final worker = workersBox.get(record.workerId);
              return Card(
                child: ListTile(
                  title: Text(worker?.name ?? 'Unknown worker'),
                  subtitle: Text(
                    record.isOnLeave
                        ? 'On leave${record.comment == null ? '' : ' - ${record.comment}'}'
                        : '${_time(record.checkInTime)} - ${_time(record.checkOutTime)}${record.comment == null ? '' : '\n${record.comment}'}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => attendanceBox.delete(record.id),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
  String _time(DateTime? value) =>
      value == null ? '--' : DateFormat('hh:mm a').format(value);
}

class AttendanceDialog extends ConsumerStatefulWidget {
  const AttendanceDialog({super.key, required this.date});
  final DateTime date;
  @override
  ConsumerState<AttendanceDialog> createState() => _AttendanceDialogState();
}

class _AttendanceDialogState extends ConsumerState<AttendanceDialog> {
  Worker? worker;
  TimeOfDay? checkIn;
  TimeOfDay? checkOut;
  bool onLeave = false;
  final comment = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final workers = Hive.box<Worker>(HiveBoxes.workers).values.toList();
    return AlertDialog(
      title: const Text('Attendance'),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<Worker>(
                initialValue: worker,
                decoration: const InputDecoration(labelText: 'Worker'),
                items: workers
                    .map((w) => DropdownMenuItem(value: w, child: Text(w.name)))
                    .toList(),
                onChanged: (v) => setState(() => worker = v),
              ),
              CheckboxListTile(
                value: onLeave,
                title: const Text('On leave'),
                onChanged: (v) => setState(() => onLeave = v!),
              ),
              if (!onLeave) ...[
                ListTile(
                  title: const Text('Check in'),
                  trailing: Text(checkIn?.format(context) ?? 'Set'),
                  onTap: () async {
                    final value = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (value != null) setState(() => checkIn = value);
                  },
                ),
                ListTile(
                  title: const Text('Check out'),
                  trailing: Text(checkOut?.format(context) ?? 'Set'),
                  onTap: () async {
                    final value = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (value != null) setState(() => checkOut = value);
                  },
                ),
              ],
              TextField(
                controller: comment,
                decoration: const InputDecoration(
                  labelText: 'Comment (optional)',
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: worker == null
              ? null
              : () async {
                  DateTime? at(TimeOfDay? time) => time == null
                      ? null
                      : DateTime(
                          widget.date.year,
                          widget.date.month,
                          widget.date.day,
                          time.hour,
                          time.minute,
                        );
                  final record = Attendance(
                    id: const Uuid().v4(),
                    workerId: worker!.id,
                    date: widget.date,
                    checkInTime: onLeave ? null : at(checkIn),
                    checkOutTime: onLeave ? null : at(checkOut),
                    isOnLeave: onLeave,
                    comment: comment.text.trim().isEmpty
                        ? null
                        : comment.text.trim(),
                  );
                  await ref
                      .read(attendanceRepositoryProvider)
                      .put(record.id, record);
                  if (context.mounted) Navigator.pop(context);
                },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class ExpensesPage extends ConsumerWidget {
  const ExpensesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final box = Hive.box<Expense>(HiveBoxes.expenses);
    return ValueListenableBuilder<Box<Expense>>(
      valueListenable: box.listenable(),
      builder: (_, expenses, _) => Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => showDialog(
            context: context,
            builder: (_) => const ExpenseDialog(),
          ),
          child: const Icon(Icons.add_card),
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: expenses.length,
          itemBuilder: (_, index) {
            final expense = expenses.getAt(index)!;
            return Card(
              child: ListTile(
                leading: const Icon(Icons.receipt_long),
                title: Text(expense.category.name),
                subtitle: Text(
                  '${DateFormat('dd MMM yyyy').format(expense.date)} - ${expense.paymentMethod.name}${expense.note == null ? '' : '\n${expense.note}'}',
                ),
                isThreeLine: expense.note != null,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      NumberFormat.currency(symbol: '').format(expense.amount),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => expenses.delete(expense.id),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ExpenseDialog extends ConsumerStatefulWidget {
  const ExpenseDialog({super.key});
  @override
  ConsumerState<ExpenseDialog> createState() => _ExpenseDialogState();
}

class _ExpenseDialogState extends ConsumerState<ExpenseDialog> {
  final formKey = GlobalKey<FormState>();
  final amount = TextEditingController();
  final note = TextEditingController();
  ExpenseCategory category = ExpenseCategory.maintenance;
  ExpensePaymentMethod payment = ExpensePaymentMethod.cash;
  Worker? worker;
  DateTime date = DateTime.now();

  bool get workerRequired =>
      category == ExpenseCategory.advanceSalary ||
      category == ExpenseCategory.salary;

  @override
  Widget build(BuildContext context) {
    final workers = Hive.box<Worker>(HiveBoxes.workers).values.toList();
    return AlertDialog(
      title: const Text('Add expense'),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 420,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('Expense date'),
                  subtitle: Text(DateFormat('dd MMM yyyy').format(date)),
                  trailing: const Icon(Icons.calendar_month),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: date,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) setState(() => date = picked);
                  },
                ),
                DropdownButtonFormField<ExpenseCategory>(
                  initialValue: category,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: ExpenseCategory.values
                      .map(
                        (v) => DropdownMenuItem(value: v, child: Text(v.name)),
                      )
                      .toList(),
                  onChanged: (v) => setState(() {
                    category = v!;
                    if (!workerRequired) worker = null;
                  }),
                ),
                if (workerRequired)
                  DropdownButtonFormField<Worker>(
                    initialValue: worker,
                    decoration: const InputDecoration(labelText: 'Worker'),
                    items: workers
                        .map(
                          (w) =>
                              DropdownMenuItem(value: w, child: Text(w.name)),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => worker = v),
                  ),
                TextFormField(
                  controller: amount,
                  decoration: const InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                  validator: (v) => double.tryParse(v ?? '') == null
                      ? 'Enter an amount'
                      : null,
                ),
                TextField(
                  controller: note,
                  decoration: const InputDecoration(
                    labelText: 'Note (optional)',
                  ),
                ),
                DropdownButtonFormField<ExpensePaymentMethod>(
                  initialValue: payment,
                  decoration: const InputDecoration(labelText: 'Deduct from'),
                  items: ExpensePaymentMethod.values
                      .map(
                        (v) => DropdownMenuItem(value: v, child: Text(v.name)),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => payment = v!),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () async {
            if (!formKey.currentState!.validate() ||
                (workerRequired && worker == null)) {
              return;
            }
            final expense = Expense(
              id: const Uuid().v4(),
              date: date,
              category: category,
              note: note.text.trim().isEmpty ? null : note.text.trim(),
              amount: double.parse(amount.text),
              workerId: worker?.id,
              paymentMethod: payment,
            );
            await ref.read(expenseRepositoryProvider).put(expense.id, expense);
            if (context.mounted) Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
