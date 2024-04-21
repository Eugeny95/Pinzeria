part of 'history_bloc.dart';

class HistoryEvent {}

class AddHistoryOrder extends HistoryEvent {
  HistoryDbModel historyDbModel;
  AddHistoryOrder({required this.historyDbModel});
}

class GetHistoryOrders extends HistoryEvent {}
