part of 'basket_bloc_bloc.dart';

enum BasketStatus { initial, done, error }

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
  double? totalCost = 0;

  BasketState({required this.basketStatus, this.positions, this.totalCost});
}
