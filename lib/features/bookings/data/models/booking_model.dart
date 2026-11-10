enum VehicleCategory { car, bike }

enum VehicleType { hatchback, compactSUV, sedan, suv, sevenSeater }

enum PaymentType { gpay, cash, card }

enum BookingStatus { inProgress, completed, cancelled }

enum BookingAddOn { stainRemove, undercoating, polishing }

class Booking {
  Booking({
    required this.id,
    required this.color,
    required this.category,
    this.vehicleName,
    this.vehicleNumber,
    this.type,
    DateTime? checkInTime,
    this.checkOutTime,
    this.durationInMins,
    this.customerName,
    this.customerNumber,
    this.totalAmount,
    this.paymentType,
    this.addOns = const [],
    this.isRegularCustomer = false,
    this.status = BookingStatus.inProgress,
  }) : checkInTime = checkInTime ?? DateTime.now();

  final String id;
  final String? vehicleName;
  final String? vehicleNumber;
  final String color;
  final VehicleCategory category;
  final VehicleType? type;
  final DateTime checkInTime;
  final DateTime? checkOutTime;
  final int? durationInMins;
  final String? customerName;
  final String? customerNumber;
  final double? totalAmount;
  final PaymentType? paymentType;
  final List<BookingAddOn> addOns;
  final bool isRegularCustomer;
  final BookingStatus status;

  Booking copyWith({
    String? vehicleName,
    String? vehicleNumber,
    String? color,
    VehicleCategory? category,
    VehicleType? type,
    DateTime? checkOutTime,
    int? durationInMins,
    String? customerName,
    String? customerNumber,
    double? totalAmount,
    PaymentType? paymentType,
    List<BookingAddOn>? addOns,
    bool? isRegularCustomer,
    BookingStatus? status,
  }) {
    return Booking(
      id: id,
      vehicleName: vehicleName ?? this.vehicleName,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      color: color ?? this.color,
      category: category ?? this.category,
      type: type ?? this.type,
      checkInTime: checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      durationInMins: durationInMins ?? this.durationInMins,
      customerName: customerName ?? this.customerName,
      customerNumber: customerNumber ?? this.customerNumber,
      totalAmount: totalAmount ?? this.totalAmount,
      paymentType: paymentType ?? this.paymentType,
      addOns: addOns ?? this.addOns,
      isRegularCustomer: isRegularCustomer ?? this.isRegularCustomer,
      status: status ?? this.status,
    );
  }
}
