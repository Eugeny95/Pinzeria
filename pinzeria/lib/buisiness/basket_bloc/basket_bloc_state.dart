part of 'basket_bloc_bloc.dart';

enum BasketStatus { initial, done, in_process, error }

class Position {
  double allCost = 0.0;
  int count = 1;
  DishHttpModel? dish;
  Position({required this.dish, required this.count});

  double calculateCost() {
    allCost = dish!.currentPrice! * count;
    return allCost;
  }
}

class BasketState {
  BasketStatus basketStatus;
  List<Position>? positions;
  double bonusesBalance = 0.0;
  double availableBonuses = 0.0;
  double? totalCost = 0;
  bool useBonuses = false;

  BasketState(
      {required this.basketStatus,
      this.positions,
      this.totalCost,
      required this.bonusesBalance,
      required this.availableBonuses,
      required this.useBonuses});
}
