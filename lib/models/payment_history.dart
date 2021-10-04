class PaymentHistory {
  PaymentHistory({required this.amount, required this.status, required this.id});

  final String status;
  final int amount;
  final int id;

  factory PaymentHistory.fromJson(Map<String, dynamic> json) => PaymentHistory(
      amount: json['amount'] as int,
      id: json['id'] as int,
       status: json['status'] as String);
}
