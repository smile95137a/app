import 'bet_status.dart';
import '../../../features/games/models/sport_type.dart';

class BetSlip {
  final String id;
  final String betCode;
  final String gameId;
  final SportType sportType;
  final String selectionName;
  final String betType;
  final String? lineValue;
  final int odds;
  final double wagerAmount;
  final double paidAmount;
  final BetStatus resultStatus;
  final DateTime placedAt;
  final DateTime? settledAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BetSlip({
    required this.id,
    required this.betCode,
    required this.gameId,
    required this.sportType,
    required this.selectionName,
    required this.betType,
    this.lineValue,
    required this.odds,
    required this.wagerAmount,
    required this.paidAmount,
    required this.resultStatus,
    required this.placedAt,
    this.settledAt,
    required this.createdAt,
    required this.updatedAt,
  });

  String get oddsDisplay => odds > 0 ? '+$odds' : '$odds';

  String get selectionDisplay =>
      lineValue != null && lineValue!.isNotEmpty ? '$selectionName $lineValue' : selectionName;

  BetSlip copyWith({
    String? selectionName,
    String? betType,
    String? lineValue,
    int? odds,
    double? wagerAmount,
    double? paidAmount,
    BetStatus? resultStatus,
    DateTime? placedAt,
    DateTime? settledAt,
  }) =>
      BetSlip(
        id: id,
        betCode: betCode,
        gameId: gameId,
        sportType: sportType,
        selectionName: selectionName ?? this.selectionName,
        betType: betType ?? this.betType,
        lineValue: lineValue ?? this.lineValue,
        odds: odds ?? this.odds,
        wagerAmount: wagerAmount ?? this.wagerAmount,
        paidAmount: paidAmount ?? this.paidAmount,
        resultStatus: resultStatus ?? this.resultStatus,
        placedAt: placedAt ?? this.placedAt,
        settledAt: settledAt ?? this.settledAt,
        createdAt: createdAt,
        updatedAt: DateTime.now(),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'betCode': betCode,
        'gameId': gameId,
        'sportType': sportType.name,
        'selectionName': selectionName,
        'betType': betType,
        'lineValue': lineValue,
        'odds': odds,
        'wagerAmount': wagerAmount,
        'paidAmount': paidAmount,
        'resultStatus': resultStatus.name,
        'placedAt': placedAt.millisecondsSinceEpoch,
        'settledAt': settledAt?.millisecondsSinceEpoch,
        'createdAt': createdAt.millisecondsSinceEpoch,
        'updatedAt': updatedAt.millisecondsSinceEpoch,
      };

  factory BetSlip.fromMap(Map<String, dynamic> map) => BetSlip(
        id: map['id'] as String,
        betCode: map['betCode'] as String,
        gameId: map['gameId'] as String,
        sportType: SportType.fromString(map['sportType'] as String),
        selectionName: map['selectionName'] as String,
        betType: map['betType'] as String,
        lineValue: map['lineValue'] as String?,
        odds: map['odds'] as int,
        wagerAmount: (map['wagerAmount'] as num).toDouble(),
        paidAmount: (map['paidAmount'] as num).toDouble(),
        resultStatus: BetStatus.fromString(map['resultStatus'] as String),
        placedAt: DateTime.fromMillisecondsSinceEpoch(map['placedAt'] as int),
        settledAt: map['settledAt'] != null
            ? DateTime.fromMillisecondsSinceEpoch(map['settledAt'] as int)
            : null,
        createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
      );
}
