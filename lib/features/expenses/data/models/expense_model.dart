enum ExpenseCategory { maintenance, refill, eBill, rent, advanceSalary, salary }

enum ExpensePaymentMethod { cash, bank }

class Expense {
  Expense({
    required this.id,
    required this.category,
    required this.amount,
    required this.paymentMethod,
    DateTime? date,
    this.note,
    this.workerId,
  }) : date = date ?? DateTime.now();

  final String id;
  final DateTime date;
  final ExpenseCategory category;
  final String? note;
  final double amount;
  final String? workerId;
  final ExpensePaymentMethod paymentMethod;
}
