class WalletSummary {
  const WalletSummary({
    required this.cashBalance,
    required this.bankBalance,
    required this.totalIncome,
    required this.totalExpenses,
  });

  final double cashBalance;
  final double bankBalance;
  final double totalIncome;
  final double totalExpenses;
}
