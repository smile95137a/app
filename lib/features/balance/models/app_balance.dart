class AppBalance {
  final double balance;
  final DateTime updatedAt;

  const AppBalance({
    required this.balance,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() => {
        'balance': balance,
        'updatedAt': updatedAt.millisecondsSinceEpoch,
      };

  factory AppBalance.fromMap(Map<String, dynamic> map) => AppBalance(
        balance: (map['balance'] as num).toDouble(),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
      );
}
