import '../../features/bookings/data/models/booking_model.dart';
import '../../features/expenses/data/models/expense_model.dart';
import '../models/wallet_summary.dart';

class WalletService {
  const WalletService();

  WalletSummary calculate(
    Iterable<Booking> bookings,
    Iterable<Expense> expenses,
  ) {
    double cashIncome = 0;
    double bankIncome = 0;
    double cashExpenses = 0;
    double bankExpenses = 0;

    for (final booking in bookings) {
      if (booking.status != BookingStatus.completed ||
          booking.totalAmount == null ||
          booking.paymentType == null) {
        continue;
      }
      if (booking.paymentType == PaymentType.cash) {
        cashIncome += booking.totalAmount!;
      } else {
        bankIncome += booking.totalAmount!;
      }
    }

    for (final expense in expenses) {
      if (expense.paymentMethod == ExpensePaymentMethod.cash) {
        cashExpenses += expense.amount;
      } else {
        bankExpenses += expense.amount;
      }
    }

    return WalletSummary(
      cashBalance: cashIncome - cashExpenses,
      bankBalance: bankIncome - bankExpenses,
      totalIncome: cashIncome + bankIncome,
      totalExpenses: cashExpenses + bankExpenses,
    );
  }
}
