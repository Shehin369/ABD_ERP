import 'package:abd_crm/core/services/wallet_service.dart';
import 'package:abd_crm/features/bookings/data/models/booking_model.dart';
import 'package:abd_crm/features/expenses/data/models/expense_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('calculates cash and bank balances from completed transactions', () {
    final bookings = [
      Booking(
        id: 'cash',
        color: 'White',
        category: VehicleCategory.car,
        totalAmount: 100,
        paymentType: PaymentType.cash,
        status: BookingStatus.completed,
      ),
      Booking(
        id: 'bank',
        color: 'Black',
        category: VehicleCategory.bike,
        totalAmount: 250,
        paymentType: PaymentType.gpay,
        status: BookingStatus.completed,
      ),
    ];
    final expenses = [
      Expense(
        id: 'expense',
        category: ExpenseCategory.refill,
        amount: 40,
        paymentMethod: ExpensePaymentMethod.cash,
      ),
      Expense(
        id: 'bank-expense',
        category: ExpenseCategory.rent,
        amount: 50,
        paymentMethod: ExpensePaymentMethod.bank,
      ),
    ];

    final summary = const WalletService().calculate(bookings, expenses);

    expect(summary.cashBalance, 60);
    expect(summary.bankBalance, 200);
    expect(summary.totalIncome, 350);
    expect(summary.totalExpenses, 90);
  });
}
