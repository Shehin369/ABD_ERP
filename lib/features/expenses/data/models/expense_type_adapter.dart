import 'package:hive/hive.dart';

import 'expense_model.dart';

class ExpenseAdapter extends TypeAdapter<Expense> {
  static const adapterTypeId = 4;

  @override
  int get typeId => adapterTypeId;

  @override
  Expense read(BinaryReader reader) {
    final values = reader.read() as Map;
    return Expense(
      id: values['id'] as String,
      date: values['date'] as DateTime?,
      category: ExpenseCategory.values[values['category'] as int],
      note: values['note'] as String?,
      amount: values['amount'] as double,
      workerId: values['workerId'] as String?,
      paymentMethod:
          ExpensePaymentMethod.values[values['paymentMethod'] as int],
    );
  }

  @override
  void write(BinaryWriter writer, Expense obj) {
    writer.write({
      'id': obj.id,
      'date': obj.date,
      'category': obj.category.index,
      'note': obj.note,
      'amount': obj.amount,
      'workerId': obj.workerId,
      'paymentMethod': obj.paymentMethod.index,
    });
  }
}
