import '../features/bets/models/bet_slip.dart';
import '../features/bets/models/bet_status.dart';
import '../features/bets/models/parlay_leg.dart';
import '../features/games/models/game.dart';
import '../features/games/models/game_status.dart';
import '../features/games/models/score_period.dart';
import '../features/games/models/sport_type.dart';

class SeedData {
  static const _rockiesDodgersScores = [
    ScorePeriod(teamType: 'AWAY', periodLabel: '3', score: 0, sortOrder: 0),
    ScorePeriod(teamType: 'AWAY', periodLabel: '4', score: 1, sortOrder: 1),
    ScorePeriod(teamType: 'AWAY', periodLabel: '5', score: 0, sortOrder: 2),
    ScorePeriod(teamType: 'AWAY', periodLabel: '6', score: 0, sortOrder: 3),
    ScorePeriod(teamType: 'AWAY', periodLabel: '7', score: 0, sortOrder: 4),
    ScorePeriod(teamType: 'AWAY', periodLabel: '8', score: 0, sortOrder: 5),
    ScorePeriod(teamType: 'AWAY', periodLabel: '9', score: 0, sortOrder: 6),
    ScorePeriod(teamType: 'AWAY', periodLabel: 'T', score: 1, sortOrder: 7),
    ScorePeriod(teamType: 'HOME', periodLabel: '3', score: 0, sortOrder: 0),
    ScorePeriod(teamType: 'HOME', periodLabel: '4', score: 1, sortOrder: 1),
    ScorePeriod(teamType: 'HOME', periodLabel: '5', score: 0, sortOrder: 2),
    ScorePeriod(teamType: 'HOME', periodLabel: '6', score: 0, sortOrder: 3),
    ScorePeriod(teamType: 'HOME', periodLabel: '7', score: 0, sortOrder: 4),
    ScorePeriod(teamType: 'HOME', periodLabel: '8', score: 1, sortOrder: 5),
    ScorePeriod(teamType: 'HOME', periodLabel: '9', score: 0, sortOrder: 6),
    ScorePeriod(teamType: 'HOME', periodLabel: 'T', score: 4, sortOrder: 7),
  ];

  static List<Game> get games => [
        Game(
          id: 'game-col-lad-final',
          sportType: SportType.mlb,
          league: 'MLB',
          awayTeam: 'COL Rockies',
          homeTeam: 'LA Dodgers',
          startTime: DateTime(2026, 5, 28, 2, 35),
          status: GameStatus.finalGame,
          scorePeriods: _rockiesDodgersScores,
          createdAt: DateTime(2026, 5, 28),
          updatedAt: DateTime(2026, 5, 28),
        ),
        Game(
          id: 'game-okc-sas-final',
          sportType: SportType.nba,
          league: 'NBA',
          awayTeam: 'OKC Thunder',
          homeTeam: 'SA Spurs',
          startTime: DateTime(2026, 6, 9, 20, 30),
          status: GameStatus.finalGame,
          scorePeriods: const [
            ScorePeriod(
                teamType: 'AWAY', periodLabel: 'Q1', score: 22, sortOrder: 0),
            ScorePeriod(
                teamType: 'AWAY', periodLabel: 'Q2', score: 31, sortOrder: 1),
            ScorePeriod(
                teamType: 'AWAY', periodLabel: 'Q3', score: 13, sortOrder: 2),
            ScorePeriod(
                teamType: 'AWAY', periodLabel: 'Q4', score: 25, sortOrder: 3),
            ScorePeriod(
                teamType: 'AWAY', periodLabel: 'T', score: 91, sortOrder: 4),
            ScorePeriod(
                teamType: 'HOME', periodLabel: 'Q1', score: 35, sortOrder: 0),
            ScorePeriod(
                teamType: 'HOME', periodLabel: 'Q2', score: 25, sortOrder: 1),
            ScorePeriod(
                teamType: 'HOME', periodLabel: 'Q3', score: 32, sortOrder: 2),
            ScorePeriod(
                teamType: 'HOME', periodLabel: 'Q4', score: 26, sortOrder: 3),
            ScorePeriod(
                teamType: 'HOME', periodLabel: 'T', score: 118, sortOrder: 4),
          ],
          createdAt: DateTime(2026, 6, 9),
          updatedAt: DateTime(2026, 6, 9),
        ),
        Game(
          id: 'game-sas-ny-open',
          sportType: SportType.nba,
          league: 'NBA',
          awayTeam: 'San Antonio Spurs',
          homeTeam: 'New York Knicks',
          startTime: DateTime(2026, 6, 9, 20, 30),
          status: GameStatus.scheduled,
          scorePeriods: const [],
          createdAt: DateTime(2026, 6, 9),
          updatedAt: DateTime(2026, 6, 9),
        ),
        Game(
          id: 'game-car-open',
          sportType: SportType.other,
          league: 'NHL',
          awayTeam: 'Carolina Hurricanes',
          homeTeam: 'Vegas Golden Knights',
          startTime: DateTime(2026, 6, 10, 20),
          status: GameStatus.scheduled,
          scorePeriods: const [],
          createdAt: DateTime(2026, 6, 9),
          updatedAt: DateTime(2026, 6, 9),
        ),
        Game(
          id: 'game-cry-ars-final',
          sportType: SportType.soccer,
          league: 'Premier League',
          awayTeam: 'Crystal Palace',
          homeTeam: 'Arsenal',
          startTime: DateTime(2026, 6, 9, 15, 0),
          status: GameStatus.finalGame,
          scorePeriods: const [
            ScorePeriod(
                teamType: 'AWAY', periodLabel: 'H1', score: 1, sortOrder: 0),
            ScorePeriod(
                teamType: 'AWAY', periodLabel: 'H2', score: 0, sortOrder: 1),
            ScorePeriod(
                teamType: 'AWAY', periodLabel: 'T', score: 1, sortOrder: 2),
            ScorePeriod(
                teamType: 'HOME', periodLabel: 'H1', score: 0, sortOrder: 0),
            ScorePeriod(
                teamType: 'HOME', periodLabel: 'H2', score: 0, sortOrder: 1),
            ScorePeriod(
                teamType: 'HOME', periodLabel: 'T', score: 0, sortOrder: 2),
          ],
          createdAt: DateTime(2026, 6, 9),
          updatedAt: DateTime(2026, 6, 9),
        ),
      ];

  static List<BetSlip> get bets => [
        BetSlip(
          id: 'bet-col-ml-lost',
          betCode: 'DK639155037126465239',
          gameId: 'game-col-lad-final',
          sportType: SportType.mlb,
          selectionName: 'COL Rockies',
          betType: 'Moneyline',
          odds: 324,
          wagerAmount: 2,
          paidAmount: 0,
          resultStatus: BetStatus.lost,
          placedAt: DateTime(2026, 5, 28, 2, 35, 13),
          settledAt: DateTime(2026, 5, 28, 2, 35, 13),
          createdAt: DateTime(2026, 5, 28),
          updatedAt: DateTime(2026, 5, 28),
        ),
        BetSlip(
          id: 'bet-under-eight-won',
          betCode: 'DK639155037092910763',
          gameId: 'game-col-lad-final',
          sportType: SportType.mlb,
          selectionName: 'Under 8',
          betType: 'Total',
          odds: -114,
          wagerAmount: 2,
          paidAmount: 3.75,
          resultStatus: BetStatus.won,
          placedAt: DateTime(2026, 5, 28, 2, 35, 10),
          settledAt: DateTime(2026, 5, 28, 2, 35, 10),
          createdAt: DateTime(2026, 5, 28),
          updatedAt: DateTime(2026, 5, 28),
        ),
        BetSlip(
          id: 'bet-three-pick-parlay-won',
          betCode: 'DK639203540129481920',
          gameId: 'game-col-lad-final',
          sportType: SportType.mlb,
          selectionName: '3 Pick Parlay',
          betType: 'LA Dodgers -1.5, SA Spurs -3.5, Crystal Palace',
          odds: 532,
          wagerAmount: 5,
          paidAmount: 31.63,
          resultStatus: BetStatus.won,
          placedAt: DateTime(2026, 6, 9, 12, 45),
          settledAt: DateTime(2026, 6, 9, 23, 20),
          createdAt: DateTime(2026, 6, 9),
          updatedAt: DateTime(2026, 6, 9),
          legs: const [
            ParlayLeg(
              selectionName: 'LA Dodgers',
              lineValue: '-1.5',
              odds: -110,
              betType: 'Run Line',
              gameId: 'game-col-lad-final',
              won: true,
            ),
            ParlayLeg(
              selectionName: 'SA Spurs',
              lineValue: '-3.5',
              odds: -110,
              betType: 'Spread',
              gameId: 'game-okc-sas-final',
              won: true,
            ),
            ParlayLeg(
              selectionName: 'Crystal Palace',
              lineValue: null,
              odds: 220,
              betType: 'Moneyline',
              gameId: 'game-cry-ars-final',
              won: true,
            ),
          ],
        ),
        BetSlip(
          id: 'bet-sas-spread-open',
          betCode: 'DK639203201847239810',
          gameId: 'game-sas-ny-open',
          sportType: SportType.nba,
          selectionName: 'San Antonio Spurs',
          betType: 'Spread',
          lineValue: '+3',
          odds: -110,
          wagerAmount: 25,
          paidAmount: 47.73,
          resultStatus: BetStatus.open,
          placedAt: DateTime(2026, 6, 9, 16),
          createdAt: DateTime(2026, 6, 9),
          updatedAt: DateTime(2026, 6, 9),
        ),
        BetSlip(
          id: 'bet-car-ml-open',
          betCode: 'DK639203781290374821',
          gameId: 'game-car-open',
          sportType: SportType.other,
          selectionName: 'Carolina Hurricanes',
          betType: 'Moneyline',
          odds: 125,
          wagerAmount: 20,
          paidAmount: 45,
          resultStatus: BetStatus.open,
          placedAt: DateTime(2026, 6, 9, 14, 30),
          createdAt: DateTime(2026, 6, 9),
          updatedAt: DateTime(2026, 6, 9),
        ),
      ];
}
